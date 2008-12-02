Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbYLBS4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbYLBS4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 13:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbYLBS4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 13:56:41 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:25995 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYLBS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 13:56:40 -0500
Date: Tue, 2 Dec 2008 13:56:34 -0500
From: "Michael B. Trausch" <mike@trausch.us>
To: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org, pazke@ports.donpac.ru
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202135634.6dd63d1d@zest.spicerack.trausch.us>
In-Reply-To: <20081202190617.61b61592@varda>
References: <fa.IDjfwzrT2B02+NHfmYwtICnzOOA@ifi.uio.no>
	<fa.J8MFTCUT8El3sK8BuYDBvaMRaB8@ifi.uio.no>
	<fa.q/4H3AtoJGSJ+i8tlXR4X35LFFU@ifi.uio.no>
	<fa.98CeSgxJ/GGaLLyZ97s1oHgh7hE@ifi.uio.no>
	<20081202121111.245d2ecc@zest.spicerack.trausch.us>
	<20081202190617.61b61592@varda>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
X-Face: V.VYf~Py*A]A=Ig&q'ryc:4rZ;J![}&08<H1=7E_.O\dF8Pbw,VE~_9QSzcs]DSM%TGA4j\
 .0/Sz8G(4s<D2VQ/uwq$dEL]LbY/y5TYyD$/6It5Yv#c=zo>wpW.<5dFb>I:aB^uO~EL+FT]m5[I4H
 s,s=
X-Operating-System: Ubuntu 8.10 (Intrepid Ibex)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6HpEvdWFtFTFkSNhRpUn4o.";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6HpEvdWFtFTFkSNhRpUn4o.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Dec 2008 19:06:17 +0100
Alejandro Riveira Fern=C3=A1ndez <ariveira@gmail.com> wrote:

> El Tue, 2 Dec 2008 12:11:11 -0500
> "Michael B. Trausch" <mike@trausch.us> escribi=C3=B3:
>=20
> [...]
> >=20
> > Alejandro, can you switch back to VTs again after rebuilding your
> > NVIDIA module?
> =20
>   I can switch to VT's and the bug still manifest 2.6.28-rc7
>  =20
>=20
> >  Also, you seem to have mentioned that you're not using
> > Ubuntu's packaged NVIDIA driver... this may mean that you've
> > overwritten and/or moved other files that Ubuntu uses, since the
> > NVIDIA driver installer does this automatically.
>=20
>   I'm using the nvidia installer for the 180.06 driver yes
>=20

It may be a bug in the 180.06 driver.  Try 177.80 which comes with
Ubuntu 8.10.  However...

> > Can you try using a stock
> > system, updated kernel, and let DKMS build the NVIDIA module?
> > You'll need to make some alterations, but I can help with those.
>=20
>  Would the nvidia.com uninstaller leave things as in a stock install?

Not really.  You'll either need a snapshot of the way things were, or
to reinstall, to bring it back to normal.  The NVIDIA custom installer
plays with all sorts of files all over the place, not just the kernel
configuration.  The main issue is that it will have modified files that
are under the control of the package manager (or are delegated by the
package manager to other utilities to manage).

>  Where can i find help about DKMS? also does it work if you use the
>  "vanilla way" of installing kernels? i do:
>   make ; make install ; make modules_install ; and mkinitramfs to
> install kernels i test

"man dkms" will get you started with learning about DKMS, and you can
also look it up on Google.

The point of DKMS is to permit you to update your kernel and have it
manage the binary drivers with source interfaces (or even pure-source
drivers that aren't in the kernel tree) for you.  As such, it does work
with a vanilla kernel---this is how I use it because installing new
kernels doesn't do anything that would confuse dpkg.

On Ubuntu, you probably want to do:

 $ make all && make install && make modules_install && \
   update-initramfs -c -k ${KERNEL_VERSION} && update-grub

That is how I do mine.

update-initramfs and update-grub are utilities provided by
Debian/Ubuntu.

	--- Mike

--=20
My sigfile ran away and is on hiatus.
http://www.trausch.us/

--Sig_/6HpEvdWFtFTFkSNhRpUn4o.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk1hOMACgkQ0kE/IBnFmjBSSACfSv1zQDeaQgWCYxl5XKG8reMA
0KQAnAxiKb3mgNOOtE1PD/hX0728PCM/
=xBeI
-----END PGP SIGNATURE-----

--Sig_/6HpEvdWFtFTFkSNhRpUn4o.--
