Return-Path: <linux-kernel-owner+w=401wt.eu-S933843AbZGQATp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843AbZGQATp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933838AbZGQATo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:19:44 -0400
Received: from ms01.sssup.it ([193.205.80.99]:36236 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933687AbZGQATn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:19:43 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Ted Baker <baker@cs.fsu.edu>
Cc: Henrik Austad <henrik@austad.us>, Chris Friesen <cfriesen@nortel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <20090716231323.GE27757@cs.fsu.edu>
References: <200907102350.47124.henrik@austad.us>
	 <4A5CCD5A.80108@nortel.com> <20090715221410.GE14993@cs.fsu.edu>
	 <200907160917.10098.henrik@austad.us>  <20090716231323.GE27757@cs.fsu.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LdgTw/7PkSw4aR9kHdpt"
Date: Fri, 17 Jul 2009 02:19:37 +0200
Message-Id: <1247789977.4929.147.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LdgTw/7PkSw4aR9kHdpt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 19:13 -0400, Ted Baker wrote:
> To be sure we are using A and B the same way here:
>   B is holding a lock. =20
>   A wants that lock.
>   A grants its priority B until B releases the lock.
>=20
> How to look at the charges for usage seems not to have a perfect
> solution.  That is, you can't get around the fact that either:
>
> [...]
>
> The right way to resolve this conflict seems to depend a lot on
> where B runs, as well as whether you are managing budget per-CPU
> (partitioned model) or managing it globally (free migration
> model).
>=20
> 1) In a global scheduling model, it does not matter where B runs.
> We want to charge B's critical section to B, since our
> schedulability analysis is based on the processor usage of each
> task.  It would be broken if A could be charged random bits of
> time for the execution of other tasks.  So, we must charge B.
>=20
Mmm... Why can't we make B able to exploit A's bandwidth to speed up
critical section completion, to the benefit of A as well? I mean, it
depends on how analysis is being carried out, and it is probably good or
bad depending on what you care most, e.g., making all task's deadline or
isolating the various components between each other... But I wouldn't
say it is "broken".

Especially because I implemented it once... Very rough, very
experimental, far from being ready for anything different than some
experiments... But it worked! :-)

> 2) In a partitioned scheuling model, we worry about the
> CPU utilization of each processor.  We have several cases, depending
> where B runs when it runs with A's priority:
>=20
Ok, I'm not going into this, since I need a little bit more time to
figure out the details... I'm concentrating on global scheduling for
now! :-D

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-LdgTw/7PkSw4aR9kHdpt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpfw5IACgkQk4XaBE3IOsSQnwCdELcvebzT4LYHjt7is8dWqYW5
8w8AnREW7vhwYlg88bxSIb7s6gvtDnS6
=aqI2
-----END PGP SIGNATURE-----

--=-LdgTw/7PkSw4aR9kHdpt--

