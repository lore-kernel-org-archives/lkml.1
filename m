Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbZEKVah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbZEKVah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759125AbZEKVa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:30:28 -0400
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:47679 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756428AbZEKVa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:30:26 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Specific support for Intel Atom architecture
Date: Mon, 11 May 2009 23:30:19 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5; KDE/4.2.2; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>
References: <200904301408.09370.tobias.doerffel@gmail.com> <877i0xib7d.fsf@basil.nowhere.org>
In-Reply-To: <877i0xib7d.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2472823.7CnAgtPJWG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905112330.20509.tobias.doerffel@gmail.com>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 20ee82dba8ba6ac69bd3d74d1db5f04e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2472823.7CnAgtPJWG
Content-Type: multipart/mixed;
  boundary="Boundary-01=_sjJCKXkZKT27IdY"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_sjJCKXkZKT27IdY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

thanks for your comments. Fixed some of your remarks and attached a new pat=
ch.

Am Montag, 4. Mai 2009 09:22:46 schrieb Andi Kleen:
> This is wrong, There are Atom CPUs which support 64bit code too.
=46ixed.

> >  config X86_XADD
> >  	def_bool y
> > @@ -355,11 +364,11 @@ config X86_ALIGNMENT_16
> >
> >  config X86_INTEL_USERCOPY
> >  	def_bool y
> > -	depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII ||
> > M586MMX || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2 +	depends on
> > MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX ||
> > X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2 || MATOM
>
> I don't think that's necessarily a good idea. You would need benchmarks
> showing that intel user copy performs better on Atom than the original on=
e.
> Do you have some?
You're right here. I made some quick benchmarks of=20
__copy_user[_intel[_nocache]]() and __copy_zeroing[_intel[_nocache]]() in=20
userspace and the generic ones indeed were about 15% faster.

> >  config X86_USE_PPRO_CHECKSUM
> >  	def_bool y
> > -	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 ||
> > MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 ||
> > MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2 +	depends on MWINCHIP3D ||
> > MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM ||
> > MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON ||
> > MGEODE_LX || MCORE2 || MATOM
>
> Similar here. Atom is quite different from PPro/K8.
Made some benchmarks of csum_partial() and csum_partial_copy_generic() as=20
well. Here the PPro version of csum_partial() performed 10-15% better=20
(depending on buffer len) while both implementations of=20
csum_partial_copy_generic() performed equal.


> > diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
> > index 80177ec..07a11b0 100644
> > --- a/arch/x86/Makefile_32.cpu
> > +++ b/arch/x86/Makefile_32.cpu
> > @@ -33,6 +33,7 @@ cflags-$(CONFIG_MCYRIXIII)	+=3D $(call
> > cc-option,-march=3Dc3,-march=3Di486) $(align)-f cflags-$(CONFIG_MVIAC3_=
2)	+=3D
> > $(call cc-option,-march=3Dc3-2,-march=3Di686) cflags-$(CONFIG_MVIAC7)		=
+=3D
> > -march=3Di686
> >  cflags-$(CONFIG_MCORE2)		+=3D -march=3Di686 $(call tune,core2)
> > +cflags-$(CONFIG_MATOM)		+=3D -march=3Datom $(call tune,atom)
> >
> >  # AMD Elan support
> >  cflags-$(CONFIG_X86_ELAN)	+=3D -march=3Di486
>
> That needs to be in the 64bit version too.
=46ixed as well. Also included changes to call cc-option as recommended by =
hpa.

> > diff --git a/arch/x86/include/asm/module.h
> > b/arch/x86/include/asm/module.h index 47d6274..e959c4a 100644
> > --- a/arch/x86/include/asm/module.h
> > +++ b/arch/x86/include/asm/module.h
> > @@ -28,6 +28,8 @@ struct mod_arch_specific {};
> >  #define MODULE_PROC_FAMILY "586MMX "
> >  #elif defined CONFIG_MCORE2
> >  #define MODULE_PROC_FAMILY "CORE2 "
> > +#elif defined CONFIG_MATOM
> > +#define MODULE_PROC_FAMILY "ATOM "
>
> This should be obsolete anyways, you can just uses CORE2. They have
> compatible ISAs.
So you would recommend writing

#elif defined CONFIG_MCORE2 || defined CONFIG_ATOM
#define MODULE_PROC_FAMILY "CORE2 "

?

Regards,

Tobias

--Boundary-01=_sjJCKXkZKT27IdY
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-x86-add-specific-support-for-Intel-Atom-architectur.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-x86-add-specific-support-for-Intel-Atom-architectur.patch"

=46rom bd9378b21f86a783dc17a741d2167e7158070d97 Mon Sep 17 00:00:00 2001
=46rom: Tobias Doerffel <tobias.doerffel@gmail.com>
Date: Mon, 11 May 2009 23:20:54 +0200
Subject: [PATCH] x86: add specific support for Intel Atom architecture

This adds another option when selecting CPU family so the kernel can
be optimized for Intel Atom CPUs. If GCC supports tuning options for
Intel Atom they will be used.
=2D--
 arch/x86/Kconfig.cpu          |   17 +++++++++++++----
 arch/x86/Makefile             |    2 ++
 arch/x86/Makefile_32.cpu      |    1 +
 arch/x86/include/asm/module.h |    2 ++
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 8130334..f88a7f6 100644
=2D-- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -262,6 +262,15 @@ config MCORE2
 	  family in /proc/cpuinfo. Newer ones have 6 and older ones 15
 	  (not a typo)
=20
+config MATOM
+	bool "Intel Atom"
+	---help---
+
+	  Select this for Intel Atom platform. Intel Atom CPUs have an in-order
+	  pipelining architecture and thus can benefit from in-order optimized
+	  code. Use a recent GCC with specific Intel Atom support in order to
+	  fully benefit from selecting this option.
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
@@ -359,7 +368,7 @@ config X86_INTEL_USERCOPY
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
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 8c86b72..3cfbd74 100644
=2D-- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -57,6 +57,8 @@ else
=20
         cflags-$(CONFIG_MCORE2) +=3D \
                 $(call cc-option,-march=3Dcore2,$(call cc-option,-mtune=3D=
generic))
+	cflags-$(CONFIG_MATOM) +=3D $(call cc-option,-march=3Datom) \
+		$(call cc-option,-mtune=3Datom)
         cflags-$(CONFIG_GENERIC_CPU) +=3D $(call cc-option,-mtune=3Dgeneri=
c)
         KBUILD_CFLAGS +=3D $(cflags-y)
=20
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 80177ec..4470fa0 100644
=2D-- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -33,6 +33,7 @@ cflags-$(CONFIG_MCYRIXIII)	+=3D $(call cc-option,-march=
=3Dc3,-march=3Di486) $(align)-f
 cflags-$(CONFIG_MVIAC3_2)	+=3D $(call cc-option,-march=3Dc3-2,-march=3Di68=
6)
 cflags-$(CONFIG_MVIAC7)		+=3D -march=3Di686
 cflags-$(CONFIG_MCORE2)		+=3D -march=3Di686 $(call tune,core2)
+cflags-$(CONFIG_MATOM)		+=3D $(call cc-option,-march=3Datom,-march=3Dcore2=
) $(call cc-option,-mtune=3Datom)
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


--Boundary-01=_sjJCKXkZKT27IdY--

--nextPart2472823.7CnAgtPJWG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoImOwACgkQHsjdpw2OaadpxQCgpRJWGMVfb7lu+u8RHPC0enaV
eHwAoMVU5lqaichbdw9/O9xgkDG6mIFd
=1v2+
-----END PGP SIGNATURE-----

--nextPart2472823.7CnAgtPJWG--
