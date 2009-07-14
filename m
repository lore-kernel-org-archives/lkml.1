Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbZGNLQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbZGNLQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 07:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZGNLQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 07:16:24 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54661 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751161AbZGNLQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 07:16:23 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ted Baker <baker@cs.fsu.edu>, Noah Watkins <jayhawk@soe.ucsc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <4A5BAAE7.5020906@nortel.com>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <1247505941.7500.39.camel@twins>
	 <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
	 <20090713201305.GA25386@cs.fsu.edu>  <4A5BAAE7.5020906@nortel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-F4cUQnlwK9ZPxDXPdR/F"
Date: Tue, 14 Jul 2009 13:16:17 +0200
Message-Id: <1247570177.9086.173.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F4cUQnlwK9ZPxDXPdR/F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-13 at 15:45 -0600, Chris Friesen wrote:
> > The only selling point for PIP has been the ability of a thread to
> > suspend itself while holding a lock, such as to wait for
> > completion of an I/O operation.
>=20
> You're comparing a full-featured PI implementation with a stripped-down
> PP (priority protection, aka priority ceiling) approach.  In an
> apples-to-apples comparison, the selling point for PI vs PP is that
> under PIP the priority of the lock holder is automatically boosted only
> if necessary, and only as high as necessary.  On the other hand, PP
> requires code analysis to properly set the ceilings for each individual
> mutex.
>=20
I think I agree with this.

Moreover, talking about server/group based scheduling and considering
BWI/PEP, which are natural extensions of PI, you get the very nice
property of being independent from the actual knowledge of the blocking
time(s): you can run your scheduling test only considering the bandwidth
assigned to each component... And this is, at least for now and as far
as I know, not possible if you go for preventivate-blocking approaches
like P(C)P or SRP, and also for BROE or SIRAP I think.

I mean, if you only want to be sure to isolate applications and/or
components among themselves, without any knowledge of the blocking times
and critical section access patterns of the task running inside such
components, you can do it! Just pick up the bandwidths and see if they
fit with a scheduling test unmodified by any --very difficult to find
out, actually-- blocking term.
I know, this does not cover all the possible situations, and that it is
biased toward _soft_ real-time workloads, but I think it's a meaningful
use-case, especially considering Linux...

Anyway, it is more than possible that this belief is due to lack of
knowledge of mine about some other already existing solution... If so,
please, any pointer to it/them is more than welcome. :-)

> > Regarding the notion of charging proxy execution to the budget of
> > the client task, I have grave concerns. It is already hard enough
> > to estimate the amount of budget that a real-time task requires,
> > without this additional complication. =20
>=20
> Agreed.
>=20
Well, indeed, I agre with this as well... But it yields the, to me, very
nice property described above (and in the other e-mail).

However, I'm light year far from proposing it as the "solutions for all
evils"! I know that, for instance, overhead and code twisting are severe
issues. The all I hope is to be able and have the time to give it a try,
and try to guess if it is worth. :-D

Regards again,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-F4cUQnlwK9ZPxDXPdR/F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpcaPoACgkQk4XaBE3IOsTFWgCgj/vHKSDWIbJQkEpmo5yCFplp
77gAniAUENFCB1hlWugSh/DmqJ6H187l
=aFoP
-----END PGP SIGNATURE-----

--=-F4cUQnlwK9ZPxDXPdR/F--

