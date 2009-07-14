Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbZGNTsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbZGNTsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbZGNTsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:48:11 -0400
Received: from ms01.sssup.it ([193.205.80.99]:50783 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752986AbZGNTsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:48:10 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1247506102.7500.41.camel@twins>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop>  <1247499843.8107.548.camel@Palantir>
	 <1247506102.7500.41.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BcF+Cndpr+aaQrz+SxM1"
Date: Tue, 14 Jul 2009 21:47:17 +0200
Message-Id: <1247600837.4839.128.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BcF+Cndpr+aaQrz+SxM1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-13 at 19:28 +0200, Peter Zijlstra wrote:
> > - analyzable from the real-time theorist's point of view... Which is
> >   (un?)fortunately what we are :-)
> > - possible to implement... Which is not always (un!)fortunately obvious=
=20
> >   here :-)
>=20
> I would very much like a proper theoretical foundation for whatever we
> end up with ;-)
>=20
Well, thus let's hope to manage in it! :-D

> > Very basically: from the analysis point of view one easy and effective
> > solution would be to have the blocked-running tasks --i.e., the tasks
> > blocked on some lock that have been left on the rq to proxy-execute the
> > lock owner-- busy waiting while the lock owner is running. This allows
> > for retaining a lot of nice properties BWI already has, as far as
> > analyzability is concerned.
>=20
> Right, practically we cannot do this, since we expose the block graph to
> userspace and you could in userspace construct a program that would
> exploit this spinning to DoS the system.
>=20
I know and I share this belief with you, as I wrote in my original
mail... Even if I must say that it would not be a _real_ spinning, such
as raw_spinlock_t, with irq and preemption disabled (like in FMLP), but
only a mean to --preemptively-- consume some budget to avoid
schedulability to be lost!
Thus, I'm not sure it could be the basis for a DoS, especially if tasks
are, individually, as a group or as a whole class, enclosed within
groups (we used to call them reservations as well).

Anyway I'm aware that CPU bandwidth would be wasted, and that this is an
issue in systems like Linux... That's why we are striving for something
better... :-P

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-BcF+Cndpr+aaQrz+SxM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpc4L4ACgkQk4XaBE3IOsSRbACfU8YoMRuj+JVGX4FyDXlfkJp7
T2IAoJxsWTNSQ/8O5XXLDpVGNHpnjZFa
=5V5s
-----END PGP SIGNATURE-----

--=-BcF+Cndpr+aaQrz+SxM1--

