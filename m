Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZI0HOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZI0HOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 03:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZI0HOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 03:14:44 -0400
Received: from panacea.frsk.net ([92.243.16.10]:45748 "EHLO panacea.frsk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbZI0HOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 03:14:43 -0400
X-Greylist: delayed 1114 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Sep 2009 03:14:43 EDT
From: Henrik Austad <henrik@austad.us>
To: Peter Zijlstra <peterz@infradead.org>
Date: Sun, 27 Sep 2009 08:55:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Raistlin <raistlin@linux.it>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
References: <1253615424.20345.76.camel@Palantir> <1253623867.20345.156.camel@Palantir> <1253644603.18939.25.camel@laptop>
In-Reply-To: <1253644603.18939.25.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2961817.d7cvJMcIgH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909270855.49367.henrik@austad.us>
X-SA-Exim-Connect-IP: 129.241.93.108
X-SA-Exim-Mail-From: henrik@austad.us
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on panacea.frsk.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2961817.d7cvJMcIgH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 22. September 2009 20.36.43 Peter Zijlstra wrote:
> On Tue, 2009-09-22 at 14:51 +0200, Raistlin wrote:

>[...]
> > > >  * In case a SCHED_EDF tasks forks, parent's budget is split among
> > > >    parent and child.
> > >
> > > Right, I guess there's really nothing else you can do here...
> >
> > Well, me too... But during tests I run into a poor EDF shell that, after
> > each `ls' or `cat', lost half of its bandwidth up to be no longer
> > capable of running at all! :(
> >
> > We may avoid this having the son giving back its bandwidth to the father
> > when dieing (what a sad story! :( ) but this would need distinguishing
> > between fork-ed and setschedul-ed EDF tasks. Moreover, e.g., what if the
> > son changed its EDF bandwidth in the meanwhile? Or worse if it changed
> > its scheduling policy?
> >
> > At the current time, I'm just splitting the bandwidth, and nothing more.
> > Actually, I also think the solution is the right one, but I would really
> > like to discuss the issues it raises.
>
> Ooh, good point,.. yes we can put some exit hooks in there folding the
> runtime back.
>
> An alternative is starting the child out with 0 runtime, and have the
> parent run sched_setscheduler() on it giving us a clear point to run
> admission on.

Why not start it as sched_fair/sched_rt and let the child apply for
resources the same way the parent did? That would be fairly
straightforward and lead to predictable behaviour, and also make a nice,=20
simple hook into the acceptance-tests.

=2D-=20
     henrik

--nextPart2961817.d7cvJMcIgH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq/DHAACgkQ6k5VT6v45lkLygCg+h9HuD7h5YokQb/j0M5c1E4V
oIAAoKRQSL2duniUW7+g6w7rIBdhug1K
=qM+X
-----END PGP SIGNATURE-----

--nextPart2961817.d7cvJMcIgH--
