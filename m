Return-Path: <linux-kernel-owner+w=401wt.eu-S1030592AbXBMAcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030592AbXBMAcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030590AbXBMAcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:32:13 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:46469 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030592AbXBMAcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:32:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=QFTwped3kR5+wpkt7TaJAXAldY5i4eAa7mDAkqTJoWKhWh+HF23kHS02+egMSibFdHbxWTTeFeP0rQFBk15IKkxlCCi3WDLrIcrF1qUzQAOoTb30zAMxI9ZTprRSVGhD;
Message-ID: <45D10704.8030008@simon.arlott.org.uk>
Date: Tue, 13 Feb 2007 00:32:04 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add an option for the VIA C7 which sets appropriate L1
 cache
References: <45D10391.30806@simon.arlott.org.uk>
In-Reply-To: <45D10391.30806@simon.arlott.org.uk>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig3648AB361C02324EECBCFA44"
Reply-To: Simon Arlott <80e573f3758387c7251hglae0001pw2z@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3648AB361C02324EECBCFA44
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The VIA C7 is a 686 (with TSC) that supports MMX, SSE and SSE2, it also h=
as a cache line length of 64 according to http://www.digit-life.com/artic=
les2/cpu/rmma-via-c7.html. This patch sets gcc to -march=3D686 and select=
s the correct cache shift.

This version adds it to include/asm-i386/module.h too so it will actually=
 compile.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

---
 arch/i386/Kconfig.cpu     |   13 ++++++++++---
 arch/i386/Makefile.cpu    |    1 +
 arch/i386/defconfig       |    1 +
 arch/um/defconfig         |    1 +
 include/asm-i386/module.h |    2 ++
 5 files changed, 15 insertions(+), 3 deletions(-)

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
diff --git a/arch/i386/defconfig b/arch/i386/defconfig
index bb0c376..04001ab 100644
--- a/arch/i386/defconfig
+++ b/arch/i386/defconfig
@@ -137,6 +137,7 @@ # CONFIG_MGEODEGX1 is not set
 # CONFIG_MGEODE_LX is not set
 # CONFIG_MCYRIXIII is not set
 # CONFIG_MVIAC3_2 is not set
+# CONFIG_MVIAC7 is not set
 CONFIG_X86_GENERIC=3Dy
 CONFIG_X86_CMPXCHG=3Dy
 CONFIG_X86_XADD=3Dy
diff --git a/arch/um/defconfig b/arch/um/defconfig
index 780cc0a..f938fa8 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -41,6 +41,7 @@ # CONFIG_MGEODEGX1 is not set
 # CONFIG_MGEODE_LX is not set
 # CONFIG_MCYRIXIII is not set
 # CONFIG_MVIAC3_2 is not set
+# CONFIG_MVIAC7 is not set
 # CONFIG_X86_GENERIC is not set
 CONFIG_X86_CMPXCHG=3Dy
 CONFIG_X86_XADD=3Dy
diff --git a/include/asm-i386/module.h b/include/asm-i386/module.h
index 02f8f54..7e5fda6 100644
--- a/include/asm-i386/module.h
+++ b/include/asm-i386/module.h
@@ -54,6 +54,8 @@ #elif defined CONFIG_MCYRIXIII
 #define MODULE_PROC_FAMILY "CYRIXIII "
 #elif defined CONFIG_MVIAC3_2
 #define MODULE_PROC_FAMILY "VIAC3-2 "
+#elif defined CONFIG_MVIAC7
+#define MODULE_PROC_FAMILY "VIAC7 "
 #elif defined CONFIG_MGEODEGX1
 #define MODULE_PROC_FAMILY "GEODEGX1 "
 #elif defined CONFIG_MGEODE_LX
--=20
1.4.3.1

--=20
Simon Arlott


--------------enig3648AB361C02324EECBCFA44
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRdEHBaRtx1WjQ8ihAQqgcA/+JJGGoibK+ZCEtp5+eG2DZEedIMQg67xT
lY6h+w1EKd/zpsR7zF8Zhk7ftu5Z4PUTSVG8PYqS0cx1+th3GRWnlnTAdZg3BIZU
WGIqfzl/y3STEMAsjatbWDWp739/cJZiBk1jwAA0/a2Q9D1fEeDxS90wNGLR8+3c
YMOuq77UDxG63PhZgeJXOk2XeIv1ykX2g09h/hm91uMAZPghI/ju4E8rwfjOMZrw
EzUusnXFkivr8oeLOvvv/e5N97gE/Yx+3uOgXVDzwI+f2cIRTJ5uyhqsrQorNYp/
p7GRIn07p1De+eE8g3v784x7V85ftnWYOBn6AZs+Lnnq26j0neNwgp5wa8ZuZz9N
jhA/LezPluXgabUh8yXybIMZeh9wLse/nxs+5zQtoAHEOllw+oNjG7B/xGd4YP8l
2Q+7OJmLOmImlsQrDOgwoFBTSO+mMuvV6S3zxyBUjdLnoXLbVy8e/YWnFA3KknyF
qPELhCmsldkBJAkFL4N+uVb/kokPKd1knIB5Rov7MTICx+A6x/QJvYJYPkUXsD1X
bMssBTFpJr0rU6aTvEPi7ZgIP4cszIjCH7zklcs7vkQMFO6iChIqV6JFL2Zyr6/v
iyXCnfaUTkBkGAKD3bNnQ/9A84TPr8K2U5w4LTvrZ5iiDPqu2pZm+OcPeotIYwxI
PlCIrRZqL+Y=
=cVg4
-----END PGP SIGNATURE-----

--------------enig3648AB361C02324EECBCFA44--
