Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbXGVX1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbXGVX1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761790AbXGVX1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:27:00 -0400
Received: from systemlinux.org ([83.151.29.59]:57502 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759567AbXGVX07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:26:59 -0400
Date: Mon, 23 Jul 2007 01:23:38 +0200
From: Andre Noll <maan@systemlinux.org>
To: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linus 2.6.23-rc1
Message-ID: <20070722232338.GI30660@skl-net.de>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070722221001.GH30660@skl-net.de> <200707230022.11831.ak@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="itqfrb9Qq3wY07cp"
Content-Disposition: inline
In-Reply-To: <200707230022.11831.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--itqfrb9Qq3wY07cp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 00:22, Andi Kleen wrote:
> > /usr/bin/ld: section .text [ffffffffff700500 -> ffffffffff7007e3] overl=
aps section .gnu.version_d [ffffffffff7004d8 -> ffffffffff70050f]
>=20
> Does this patch fix it?

Nope, with 0x600 I still get the same error. But it helped to further
increase VDSO_TEXT_OFFSET to 0xc00. I tried 0x700, 0x800,... and 0xc00
is the smallest value in this series that makes the error go away, i.e.
the patch below works for me.

Thanks
Andre


diff --git a/arch/x86_64/vdso/voffset.h b/arch/x86_64/vdso/voffset.h
index 5304204..61667d5 100644
--- a/arch/x86_64/vdso/voffset.h
+++ b/arch/x86_64/vdso/voffset.h
@@ -1 +1 @@
-#define VDSO_TEXT_OFFSET 0x500
+#define VDSO_TEXT_OFFSET 0xc00

--=20
The only person who always got his work done by Friday was Robinson Crusoe

--itqfrb9Qq3wY07cp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGo+b6Wto1QDEAkw8RArGbAJwJbu+M4aTGgpL+QVfqBZhQKol7CACfe3LS
rhHR2vbEfgKVR+Qm6cW7ytQ=
=7A4e
-----END PGP SIGNATURE-----

--itqfrb9Qq3wY07cp--
