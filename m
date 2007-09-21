Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbXIUIIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbXIUIIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXIUII1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:08:27 -0400
Received: from canadatux.org ([85.214.62.144]:42823 "EHLO
	zoidberg.canadatux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbXIUIIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:08:25 -0400
Date: Fri, 21 Sep 2007 10:08:08 +0200
From: Matthias Hensler <matthias@wspse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       richard kennedy <richard@rsk.demon.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
Message-ID: <20070921080808.GA28849@kobayashi-maru.wspse.de>
Reply-To: Matthias Hensler <matthias@wspse.de>
References: <46B10BB7.60900@redhat.com> <20070803113407.0b04d44e.akpm@linux-foundation.org> <20070804084426.GA20464@kobayashi-maru.wspse.de> <20070809095943.GA7763@kobayashi-maru.wspse.de> <20070809095534.25ae1c42.akpm@linux-foundation.org> <46F2E103.8000907@redhat.com> <20070920142927.d87ab5af.akpm@linux-foundation.org> <46F2EE76.4000203@redhat.com> <20070920153654.b9e90616.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <20070920153654.b9e90616.akpm@linux-foundation.org>
Organization: WSPse (http://www.wspse.de/)
X-Gummibears: Bouncing here and there and everywhere
X-Face: &Tv]9SsNpb/$w8\G-O%>W02aApFW^P>[x+Upv9xQB!2;iD9Y1-Lz'qlc{+lL2Y>J(u76 Jk,cJ@$tP2-M%y?^'jn2J]3C'ss_~"u?kA^X&{]h?O?@*VwgSGob73I9r}&S%ktup0k2 !neScg3'HO}PU#Ac>jwNL|P@f|f*sz*cP'hi)/<JQC4|Q[$D@aQ"C{$>a=6.rc-P1vXa rjVXlzClmNfcSy/$4tQz
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 20, 2007 at 03:36:54PM -0700, Andrew Morton wrote:
> That's all a bit crappy if the wrong races happen and some other task
> is somehow exceeding the dirty limits each time this task polls them.
> Seems unlikely that such a condition would persist forever.

How exactly do you define forever? It looks to me, that this condition
never resolves on its own, at least not in a window of several hours
(the system used to get stuck around 3am and was normally rebooted
between 7am and 8am, so at least hours are not enough to have the problem
resolve on its own).

> So the question is, why do we have large amounts of dirty pages for
> one disk which appear to be sitting there not getting written?

Unfortunately I have no idea. The full stacktrace for all processes was
attached to the original bugreport, maybe that can give a clue to that.

> Do we know if there's any writeout at all happening when the system is
> in this state?

Not sure about that. The system is responsible on a still open SSH
session, allowing several tasks still to be executed. However, that SSH
session gets stuck very fast if the wrong commands are executed. New
logins are not possible (Connection is akzepted but resulting in a
timeout 60 seconds later, so most likely /bin/login is not able to log
into wtmp).

=46rom all that I suspect that there is no more write activity on that
system, but cannot say for sure.

> Did anyone try running /bin/sync when the system is in this state?

I did not, no.

Regards,
Matthias

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUBRvN74oagCBsispUdAQIpKwP/WdZAUgPDbPKcRe72BcsQTVlOuQOZWezJ
7hSs41O23jmSFsXxrOUBBqVfOacQcSCv3JuI0jFLX1D8wiQaLIlzsQjDAGhqWGU1
Gm/ob1OPfXM7FEfo8/EVzOFLKvT8H4KwkQd1UvuMM2VRG8hdhabc+1j2shhaza/X
VYQDbXYsdOQ=
=mqgu
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
