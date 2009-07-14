Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZGNTzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZGNTzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbZGNTzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:55:20 -0400
Received: from ms01.sssup.it ([193.205.80.99]:43027 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755469AbZGNTzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:55:18 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "James H. Anderson" <anderson@cs.unc.edu>,
       Chris Friesen <cfriesen@nortel.com>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
In-Reply-To: <1247589099.7500.191.camel@twins>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>
	 <4A5C9ABA.9070909@nortel.com>
	 <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu>
	 <1247589099.7500.191.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Gr5SOStY/8HMQWAPltg5"
Date: Tue, 14 Jul 2009 21:54:54 +0200
Message-Id: <1247601294.4839.137.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Gr5SOStY/8HMQWAPltg5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-14 at 18:31 +0200, Peter Zijlstra wrote:
> > but the discussion since has been entirely about synchronization issues=
.
>=20
> Right, this seems to be a very hot topic.
>=20
Indeed! :-D

> Right, Ted holds similar opinions.
>=20
> Practically though, active Priority Inheritance has enormous benefits
> for us simple people that need to get things done :-)
>=20
> It has allowed us to convert this huge mass of code into something that
> is real-time enough for a lot of practical uses, including industrial
> robots and the like without the need to analyze each and every lock out
> there.
>=20
As said to you personally, I put quite a lot of efforts trying to find
some code using PI-futexes directly or PTHREAD_PRIO_INHERIT POSIX
mutexes, for personal curiosity and research interest... But I did not
manage for now. :-(

Do you think it would be possible to have some pointers?

> > In this approach, critical-section lengths must be known, and any
> > lock request that occurs when a task doesn't have sufficient
> > budget is simply denied -- the request is done later when that task
> > receives additional budget.  This avoids a task in one group from
> > holding a lock while it is preempted (which could severely hurt
> > lock-requesting tasks in other groups).  This scheme is really easy
> > to implement in conjunction with the FMLP and it doesn't require
> > complicated budget tracking.  Its effects on blocking terms are
> > also easy to analyze.  Thomas Nolte and colleagues (in Sweden) have
> > written some papers where they've used skip-based locks in
> > hierarchically-scheduled systems.
>=20
> Not granting locks when the contender doesn't have enough budget to
> finish them seems like a very attractive solution, however the cost of
> having to analyze the critical section seems prohibitive.
>=20
I've always thought so... We have some work related to this as well (can
give pointers if interested), but I personally like PI/BWI-PEP etc.
because such a knowledge is not required at all... Anyway...

> That said, we could maybe experiment with this for a few key lock sites.
>=20
... This would be nice!

> Furthermore we're limited by the existing legacy (both spec and code
> wise), but I think we have been able to make good progress through tools
> that help us, such as lockdep and the latency tracer (now ftrace), which
> help us find trouble in an active manner.
>=20
Well, in my very humble opinion you're definitely doing great job! :-D

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-Gr5SOStY/8HMQWAPltg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpc4o4ACgkQk4XaBE3IOsT7WQCaA43n07lRdElL3mJUuN1fO4D0
f0AAn12dihlRyUy3x/TtCI/SXkTcCz30
=UiOy
-----END PGP SIGNATURE-----

--=-Gr5SOStY/8HMQWAPltg5--

