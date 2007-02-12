Return-Path: <linux-kernel-owner+w=401wt.eu-S1030453AbXBLXda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030453AbXBLXda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030493AbXBLXda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:33:30 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:53435 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030453AbXBLXd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:33:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=FVRL3Z+5e/lJCmkUpumqVvVcwqL6hTxkpdJ8Iaj2VOpzWnhk9/uAnDEg1fjhkkb36KuGYgb2ZQF8K/S/fr4rqLmaSEXloL2yMh6CJO+qXXzmTIUNfALAp9JNgpx/oExN;
Message-ID: <45D0F943.6040205@simon.arlott.org.uk>
Date: Mon, 12 Feb 2007 23:33:23 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Make VMSPLIT options less ambiguous
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigE4E6821671C0967A5C896320"
Reply-To: Simon Arlott <755ee186f5da2da0671hgkfq0000gu05@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE4E6821671C0967A5C896320
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This changes VMSPLIT_2G to really mean 2G, adding VMSPLIT_2G_OPT for the =
1920/2176 split. It also prevents either _OPT setting being used when PAE=
 is enabled (http://lkml.org/lkml/2006/12/1/44 - there doesn't appear to =
be any patches/commits which allow non-1GB boundary VMSPLIT with PAE yet)=
=2E The existing !HIGHMEM doesn't make sense, VMSPLIT_3G_OPT may be desir=
eable for a kernel built for multiple systems some of which may only have=
 1GB. This will require anyone using VMSPLIT_2G to change to VMSPLIT_2G_O=
PT to get the same effect, but the option was badly named when it was add=
ed.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

---

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 0dfee81..e57922b 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -539,10 +539,13 @@ choice
 	config VMSPLIT_3G
 		bool "3G/1G user/kernel split"
 	config VMSPLIT_3G_OPT
-		depends on !HIGHMEM
+		depends on !X86_PAE
 		bool "3G/1G user/kernel split (for full 1G low memory)"
 	config VMSPLIT_2G
 		bool "2G/2G user/kernel split"
+	config VMSPLIT_2G_OPT
+		depends on !X86_PAE
+		bool "2G/2G user/kernel split (for full 2G low memory)"
 	config VMSPLIT_1G
 		bool "1G/3G user/kernel split"
 endchoice
@@ -550,7 +553,8 @@ endchoice
 config PAGE_OFFSET
 	hex
 	default 0xB0000000 if VMSPLIT_3G_OPT
-	default 0x78000000 if VMSPLIT_2G
+	default 0x80000000 if VMSPLIT_2G
+	default 0x78000000 if VMSPLIT_2G_OPT
 	default 0x40000000 if VMSPLIT_1G
 	default 0xC0000000
=20

--=20
Simon Arlott


--------------enigE4E6821671C0967A5C896320
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRdD5RqRtx1WjQ8ihAQozkA/8DRxZWhNNGksYbziHgZKH79SDCWy4Wfbs
UqP1nJtceZD8FPL830Ow+SdaIqAPCWC2mHBbXx/1Oc0tDmllGHAwYEMnMr5m9xn0
0ra0ybFPOR9b7ZAE12CDN0Jhtu8Y478DkqhHpS7Ken8+lBFRLc4gd7JxDSGHWyLN
Qa9H/3MQByJAt4xzo3/X4YMJFwvnNWv3vnu8wnd9z9UpUxWuvPKUa0jQ31HyapjP
E1GOqjdChsaYLocfHmcrz9rP7p3BAEWlLiKYoBGsm56dZQzz4/McIHj6ob41H9W1
oigrhhqSSTyOjxvgVya+SxBYvFp5DM1OE8IdXCYrAjOjK2uzvYJCH69ZSyBXwsKj
57NDSu8AgnigCWDX5mhORZN+IgsUMUOQGQYNhrkpteRB8jIX3t/QdiLfSkF5ZtEN
rf2AfuoMzJyt7FEvVo/N6yEtKC/MMdPi51TeAVM/Jg9b+p7bYbpl9ixSVr0UIleu
CiQuCGrUIO9wD4eTJpouK9gG3XIe0KDrOt2l1WGZ/pcmvkYlS+DYu5D/NDW4Dyi/
UXCyrNYSN56VXy9J0S2iNF0tLexAtzX7/wVNkdMb7KsvBiVAemEWkJmRC9xKzW6R
gCzkxYWoYh00T2/SWXT3C3s1G3z1F/z7TAswSfELnu5rSBwXUn6+MBCL3pVpNQcj
4aMYCsmX5dw=
=OQY9
-----END PGP SIGNATURE-----

--------------enigE4E6821671C0967A5C896320--
