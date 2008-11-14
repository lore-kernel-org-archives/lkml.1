Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYKNJii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYKNJii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 04:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYKNJi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 04:38:29 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:42726 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbYKNJi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 04:38:28 -0500
Date: Fri, 14 Nov 2008 10:38:53 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: petkovbb@gmail.com, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] checkpatch: Add warning for p0-patches
Message-ID: <20081114093853.GA3152@pengutronix.de>
References: <1225467370-19143-1-git-send-email-w.sang@pengutronix.de> <20081112135522.GD8302@shadowen.org> <9ea470500811120623q4334f840t4540649edba935@mail.gmail.com> <20081113225540.GA11912@pengutronix.de> <20081114064919.GB29121@gollum.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20081114064919.GB29121@gollum.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boris,

> --- /dev/null   2008-11-09 02:46:02.525014459 +0100
> +++ arch/x86/kernel/tsc_resync.c        2008-11-14 07:22:34.000000000 +01=
00
> @@ -0,0 +1 @@
> +This is a new file
>=20
> and, as you can see, it is a -p0 patch. Now, in the code you do:
>=20
> if ($tree && -e "$root/$p1_prefix") {
> 	WARN("Patch prefix '$p1_prefix' exists. Is it maybe a p0-patch?\n");
>=20
> and the "$root/$p1_prefix" won't exist - as a matter of fact - would
> lose its "arch" part due to the regex before and the if-condition won't
> trigger.

Careful. My approach is a bit different (inverse so to say) from yours
which I missed back then. $p1_prefix is the part which _was_ cut off and
it is wrong if it _does_ exist. See:

-                       $realfile =3D~ s@^[^/]*/@@;
+                       $realfile =3D~ s@^([^/]*)/@@;
+
+                       $p1_prefix =3D $1;

(So, a way to fool this algorithm is to give your kernel root dir the
same name as a directory inside the root dir, like:

--- drivers.orig/drivers/...
+++ drivers/drivers/...

This will generate a false positive. Oh, well...)

I decided to go this way intentionally to handle the new file problem.
So, in your case (I tried) it will cut off "arch", find the "arch"
directory and will complain. (Did you actually apply this patch? ;))

I thought the variable name 'p1_prefix' would speak for itself, but as
you misinterpreted it, maybe it should be renamed?

All the best,

   Wolfram

--=20
  Dipl.-Ing. Wolfram Sang | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkdRy0ACgkQD27XaX1/VRvdtwCgw1KGpawFPdS3X19kUZA6P9yl
/xwAnjZNSckanTUKswwi5P/tIFOu0dNb
=p8P2
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
