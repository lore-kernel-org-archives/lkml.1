Return-Path: <linux-kernel-owner+w=401wt.eu-S1030573AbXBMAR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573AbXBMAR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030574AbXBMARZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:17:25 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:37143 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030573AbXBMARY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:17:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=Cfi1t9ja/Oa0CHCp7LgFQ0qX3c5yjkJYNjpIxpP9+PqDNQjHkkq3IyZxW7dBiiykOkNcYJHYA4PJ3t9cIYLIbpmoNsmyBWAboSgjUGAWjXRPgV75I3A/x1YdJ943A5zV;
Message-ID: <45D10391.30806@simon.arlott.org.uk>
Date: Tue, 13 Feb 2007 00:17:21 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add an option for the VIA C7 which sets appropriate L1 cache
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig860D53F7CEE9722A73D54B36"
Reply-To: Simon Arlott <372a14649b2863ca0d1hglml0000av1x@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig860D53F7CEE9722A73D54B36
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The VIA C7 is a 686 (with TSC) that supports MMX, SSE and SSE2, it also h=
as a cache line length of 64 according to http://www.digit-life.com/artic=
les2/cpu/rmma-via-c7.html. This patch sets gcc to -march=3D686 and select=
s the correct cache shift.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

---
 arch/i386/Kconfig.cpu  |   13 ++++++++++---
 arch/i386/Makefile.cpu |    1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/i386/Kconfig.cpu b/arch/i386/Kconfig.cpu
index 2aecfba..194d8c2 100644
--- a/arch/i386/Kconfig.cpu
+++ b/arch/i386/Kconfig.cpu
@@ -43,6 +43,7 @@ config M386
 	  - "Geode GX/LX" For AMD Geode GX and LX processors.
 	  - "CyrixIII/VIA C3" for VIA Cyrix III or VIA C3.
 	  - "VIA C3-2" for VIA C3-2 "Nehemiah" (model 9 and above).
+	  - "VIA C7" for VIA C7.
=20
 	  If you don't know what to do, choose "386".
=20
@@ -203,6 +204,12 @@ config MVIAC3_2
 	  of SSE and tells gcc to treat the CPU as a 686.
 	  Note, this kernel will not boot on older (pre model 9) C3s.
=20
+config MVIAC7
+	bool "VIA C7"
+	help
+	  Select this for a VIA C7.  Selecting this uses the correct cache
+	  shift and tells gcc to treat the CPU as a 686.
+
 endchoice
=20
 config X86_GENERIC
@@ -236,7 +243,7 @@ config X86_L1_CACHE_SHIFT
 	default "7" if MPENTIUM4 || X86_GENERIC
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCRUSOE || MEFF=
ICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX=
 || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
-	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2
+	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7
=20
 config RWSEM_GENERIC_SPINLOCK
 	bool
@@ -302,7 +309,7 @@ config X86_ALIGNMENT_16
=20
 config X86_GOOD_APIC
 	bool
-	depends on MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII |=
| M686 || M586MMX || MK8 || MEFFICEON || MCORE2
+	depends on MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII |=
| M686 || M586MMX || MK8 || MEFFICEON || MCORE2 || MVIAC7
 	default y
=20
 config X86_INTEL_USERCOPY
@@ -327,5 +334,5 @@ config X86_OOSTORE
=20
 config X86_TSC
 	bool
-	depends on (MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXII=
I || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII ||=
 M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MGEODEGX1 || MGEODE_LX =
|| MCORE2) && !X86_NUMAQ
+	depends on (MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXII=
I || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII ||=
 M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || =
MGEODE_LX || MCORE2) && !X86_NUMAQ
 	default y
diff --git a/arch/i386/Makefile.cpu b/arch/i386/Makefile.cpu
index a32c031..e0ada4e 100644
--- a/arch/i386/Makefile.cpu
+++ b/arch/i386/Makefile.cpu
@@ -32,6 +32,7 @@ cflags-$(CONFIG_MWINCHIP2)	+=3D $(call cc-
 cflags-$(CONFIG_MWINCHIP3D)	+=3D $(call cc-option,-march=3Dwinchip2,-mar=
ch=3Di586)
 cflags-$(CONFIG_MCYRIXIII)	+=3D $(call cc-option,-march=3Dc3,-march=3Di4=
86) $(align)-functions=3D0 $(align)-jumps=3D0 $(align)-loops=3D0
 cflags-$(CONFIG_MVIAC3_2)	+=3D $(call cc-option,-march=3Dc3-2,-march=3Di=
686)
+cflags-$(CONFIG_MVIAC7)		+=3D -march=3Di686
 cflags-$(CONFIG_MCORE2)		+=3D -march=3Di686 $(call cc-option,-mtune=3Dco=
re2,$(call cc-option,-mtune=3Dgeneric,-mtune=3Di686))
=20
 # AMD Elan support
--=20
1.4.3.1
--=20
Simon Arlott


--------------enig860D53F7CEE9722A73D54B36
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRdEDkaRtx1WjQ8ihAQry9w//aIfjAwwwA7j2cwwVd6A13wspKfNcHtu4
izueRrTLm2WjzuXwica3IFtEbOeWMRqmua9BkkluAGk18TWe9zc+1EXMsiaiuvPN
OFeXNUSB7VrbJ3GD2uvbF8yGcw3AlYHLUZ+f8LHginQHLiKmsidpGz01+/1q2R4W
vf3ehIqtl+GxJutzYSCfm13thBio8cu6cHYlJre32MwC1oJAZkbVCvSw3vBLH+Qz
Q9jItxrbXQeGRlT8agMLNh5Bk6C35VqEE/z7cUBypKYvCBfA13nr9UBHoD8MF+Sf
uromp1Koslvx/HkOsTiiEVPBFhOwSHYltzeOtwS3/gstC5s0YwCE3Gps33Ys6SvF
DrgRVl/FUZcKH40g5H17ZaxTXvMFgvUyN+aI21yttWsUXbjAd+1Ay0fj3nYsAMvj
hKe5t78CFmvqGmu/X4u2sIfjgzuOFY8qg6nbBK2P9KUp8jj07iniXh/1g+OrUY7w
iDkNoQxwmI7IaxGJ2yHDefAkbExThv6Dsy/KyZbJz7Q2uK1a5MmgOnkgY3sYhNpV
fYgH5WYhtaANWDEONL/7enJJyL01UCbVz9KiIgXz0+Ab+JC2OCp7Qjvs9o5RArE/
96HoT3KY3NYTUe5ghEkBvnB/8fhrC94N9upuRQ0JbXanWXOL5jglCajKSSdj2RoA
QIg3LHZEiks=
=UtOx
-----END PGP SIGNATURE-----

--------------enig860D53F7CEE9722A73D54B36--
