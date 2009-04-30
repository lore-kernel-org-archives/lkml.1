Return-Path: <linux-kernel-owner+w=401wt.eu-S1762129AbZD3Moo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762129AbZD3Moo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 08:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbZD3Mof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 08:44:35 -0400
Received: from jack.hrz.tu-chemnitz.de ([134.109.132.46]:49966 "EHLO
	jack.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZD3Moe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 08:44:34 -0400
X-Greylist: delayed 2182 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Apr 2009 08:44:34 EDT
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Specific support for Intel Atom architecture
Date: Thu, 30 Apr 2009 14:08:04 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-atom; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2408241.O2HVrOyLGZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200904301408.09370.tobias.doerffel@gmail.com>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 9e4810297f606417ddb6c99342cf095f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2408241.O2HVrOyLGZ
Content-Type: multipart/mixed;
  boundary="Boundary-01=_kSZ+JIPg/Sl2c8b"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_kSZ+JIPg/Sl2c8b
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

as some of you already might know, work is going on to make GCC fully suppo=
rt=20
Intel Atom architecture specifics, i.e. make -mtune=3Datom generate code=20
optimized for in-order architectures like Intel Atom [1].

I therefore started to make up a small patch which adds Intel Atom as a new=
=20
processor family which can be selected upon configuration. It's nothing=20
special and also requires a patched GCC. I'd just like to get some feedback=
 on=20
it, i.e. is X86_L1_CACHE_SHIFT=3D6 ok for Atom CPUs (I was not able to find=
 any=20
information on Atom's cacheline size)? Any chance to include this patch onc=
e=20
the Atom patch went into GCC mainline (probably in GCC 4.5)? Any other=20
objections?

Please Cc me, I'm not on the list.

Regards,

Tobias

[1] http://gcc.gnu.org/viewcvs/branches/ix86/atom/



--Boundary-01=_kSZ+JIPg/Sl2c8b
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-x86-add-specific-support-for-Intel-Atom-architectur.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-x86-add-specific-support-for-Intel-Atom-architectur.patch"

=46rom 6aa86b4431619d38849d469c70904afe1e5a8ca0 Mon Sep 17 00:00:00 2001
=46rom: Tobias Doerffel <tobias.doerffel@gmail.com>
Date: Thu, 30 Apr 2009 12:36:46 +0200
Subject: [PATCH] x86: add specific support for Intel Atom architecture

This adds another option when selecting CPU family so the kernel can
be optimized for Intel Atom CPUs. This patch requires a GCC with a
patch applied which adds specific Intel Atom support.
=2D--
 arch/x86/Kconfig.cpu          |   19 ++++++++++++++-----
 arch/x86/Makefile_32.cpu      |    1 +
 arch/x86/include/asm/module.h |    2 ++
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 8130334..8e565b7 100644
=2D-- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -262,6 +262,15 @@ config MCORE2
 	  family in /proc/cpuinfo. Newer ones have 6 and older ones 15
 	  (not a typo)
=20
+config MATOM
+	bool "Intel Atom"
+	depends on X86_32
+	---help---
+
+	  Select this for Intel Atom platform. Intel Atom CPUs have an in-order
+	  pipelining architecture and thus can benefit from in-order optimized
+	  code (requires Intel Atom patch in GCC).
+
 config GENERIC_CPU
 	bool "Generic-x86-64"
 	depends on X86_64
@@ -310,7 +319,7 @@ config X86_L1_CACHE_SHIFT
 	default "7" if MPENTIUM4 || MPSC
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIX=
III || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M5=
86 || MVIAC3_2 || MGEODE_LX
=2D	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7 || X86_GENER=
IC || GENERIC_CPU
+	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X8=
6_GENERIC || GENERIC_CPU
=20
 config X86_XADD
 	def_bool y
@@ -355,11 +364,11 @@ config X86_ALIGNMENT_16
=20
 config X86_INTEL_USERCOPY
 	def_bool y
=2D	depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586M=
MX || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2
+	depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX=
 || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2 || MATOM
=20
 config X86_USE_PPRO_CHECKSUM
 	def_bool y
=2D	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENT=
IUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 |=
| MEFFICEON || MGEODE_LX || MCORE2
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIU=
M4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || =
MEFFICEON || MGEODE_LX || MCORE2 || MATOM
=20
 config X86_USE_3DNOW
 	def_bool y
@@ -387,7 +396,7 @@ config X86_P6_NOP
=20
 config X86_TSC
 	def_bool y
=2D	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || =
MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586M=
MX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCO=
RE2) && !X86_NUMAQ) || X86_64
+	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK=
6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX=
 || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE=
2 || MATOM) && !X86_NUMAQ) || X86_64
=20
 config X86_CMPXCHG64
 	def_bool y
@@ -397,7 +406,7 @@ config X86_CMPXCHG64
 # generates cmov.
 config X86_CMOV
 	def_bool y
=2D	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMI=
II || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X=
86_64)
+	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII=
 || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86=
_64 || MATOM)
=20
 config X86_MINIMUM_CPU_FAMILY
 	int
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 80177ec..07a11b0 100644
=2D-- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -33,6 +33,7 @@ cflags-$(CONFIG_MCYRIXIII)	+=3D $(call cc-option,-march=
=3Dc3,-march=3Di486) $(align)-f
 cflags-$(CONFIG_MVIAC3_2)	+=3D $(call cc-option,-march=3Dc3-2,-march=3Di68=
6)
 cflags-$(CONFIG_MVIAC7)		+=3D -march=3Di686
 cflags-$(CONFIG_MCORE2)		+=3D -march=3Di686 $(call tune,core2)
+cflags-$(CONFIG_MATOM)		+=3D -march=3Datom $(call tune,atom)
=20
 # AMD Elan support
 cflags-$(CONFIG_X86_ELAN)	+=3D -march=3Di486
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 47d6274..e959c4a 100644
=2D-- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -28,6 +28,8 @@ struct mod_arch_specific {};
 #define MODULE_PROC_FAMILY "586MMX "
 #elif defined CONFIG_MCORE2
 #define MODULE_PROC_FAMILY "CORE2 "
+#elif defined CONFIG_MATOM
+#define MODULE_PROC_FAMILY "ATOM "
 #elif defined CONFIG_M686
 #define MODULE_PROC_FAMILY "686 "
 #elif defined CONFIG_MPENTIUMII
=2D-=20
1.6.2.4


--Boundary-01=_kSZ+JIPg/Sl2c8b--

--nextPart2408241.O2HVrOyLGZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn5lKQACgkQHsjdpw2OaafxyQCfTe24QHNIlRw661XTGBbCX362
GnQAnRbnMhcFhkZPzbZ2Be7FYcBDsG3R
=KXiU
-----END PGP SIGNATURE-----

--nextPart2408241.O2HVrOyLGZ--
