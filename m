Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbZAFVjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbZAFVjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZAFVck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:40 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:14867 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZAFVci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=CqxwStAjCMbiEKbnav/gbHWEhWU+IdJ44BQ+Jf4Na1BAoDfl8i1XGbVwZXb1tJEsDM
         l0gT3+p7a2B+luSyGvh8dGzLk7v1bpBLVdyTUrrX/z/SAznbk8vWbxc82xHQ+uThpBAQ
         931yhzkP+zKs/KCMSUEKjOJCd7fDDKTlg7oqk=
Subject: [PATCH 22/23] byteorder: make swab.h include asm/swab.h like a
 regular header
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:57 -0800
Message-Id: <1231277457.964.281.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add swab.h to kbuild.asm and remove the individual entries from
each arch, mark as unifdef as some arches have some kernel-only
bits inside.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/alpha/include/asm/Kbuild          |    1 -
 arch/alpha/include/asm/byteorder.h     |    1 -
 arch/arm/include/asm/Kbuild            |    1 -
 arch/arm/include/asm/byteorder.h       |    2 --
 arch/avr32/include/asm/Kbuild          |    1 -
 arch/avr32/include/asm/byteorder.h     |    1 -
 arch/blackfin/include/asm/Kbuild       |    1 -
 arch/blackfin/include/asm/byteorder.h  |    1 -
 arch/cris/include/asm/Kbuild           |    1 -
 arch/cris/include/asm/byteorder.h      |    1 -
 arch/h8300/include/asm/Kbuild          |    1 -
 arch/h8300/include/asm/byteorder.h     |    1 -
 arch/ia64/include/asm/Kbuild           |    1 -
 arch/ia64/include/asm/byteorder.h      |    1 -
 arch/m68knommu/include/asm/Kbuild      |    2 --
 arch/m68knommu/include/asm/byteorder.h |    1 -
 arch/mips/include/asm/Kbuild           |    1 -
 arch/mips/include/asm/byteorder.h      |    2 --
 arch/parisc/include/asm/Kbuild         |    1 -
 arch/parisc/include/asm/byteorder.h    |    1 -
 arch/powerpc/include/asm/Kbuild        |    1 -
 arch/powerpc/include/asm/byteorder.h   |    2 --
 arch/s390/include/asm/Kbuild           |    1 -
 arch/s390/include/asm/byteorder.h      |    1 -
 arch/sh/include/asm/Kbuild             |    1 -
 arch/sh/include/asm/byteorder.h        |    2 --
 arch/sparc/include/asm/Kbuild          |    1 -
 arch/sparc/include/asm/byteorder.h     |    1 -
 arch/x86/include/asm/Kbuild            |    1 -
 arch/x86/include/asm/byteorder.h       |    1 -
 arch/xtensa/include/asm/Kbuild         |    2 --
 arch/xtensa/include/asm/byteorder.h    |    2 --
 include/asm-frv/Kbuild                 |    1 -
 include/asm-frv/byteorder.h            |    1 -
 include/asm-generic/Kbuild.asm         |    1 +
 include/asm-m32r/Kbuild                |    1 -
 include/asm-m32r/byteorder.h           |    2 --
 include/asm-m68k/Kbuild                |    1 -
 include/asm-m68k/byteorder.h           |    1 -
 include/asm-mn10300/Kbuild             |    1 -
 include/asm-mn10300/byteorder.h        |    1 -
 include/linux/swab.h                   |    2 +-
 42 files changed, 2 insertions(+), 49 deletions(-)

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index 4dad273..b7c8f18 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -9,4 +9,3 @@ unifdef-y += console.h
 unifdef-y += fpu.h
 unifdef-y += sysinfo.h
 unifdef-y += compiler.h
-unifdef-y += swab.h
diff --git a/arch/alpha/include/asm/byteorder.h b/arch/alpha/include/asm/byteorder.h
index 6772f31..7368309 100644
--- a/arch/alpha/include/asm/byteorder.h
+++ b/arch/alpha/include/asm/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _ALPHA_BYTEORDER_H
 #define _ALPHA_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/little_endian.h>
 
 #endif /* _ALPHA_BYTEORDER_H */
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 43b0b2b..73237bd 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -1,4 +1,3 @@
 include include/asm-generic/Kbuild.asm
 
 unifdef-y += hwcap.h
-unifdef-y += swab.h
diff --git a/arch/arm/include/asm/byteorder.h b/arch/arm/include/asm/byteorder.h
index c02b6fc..7737974 100644
--- a/arch/arm/include/asm/byteorder.h
+++ b/arch/arm/include/asm/byteorder.h
@@ -15,8 +15,6 @@
 #ifndef __ASM_ARM_BYTEORDER_H
 #define __ASM_ARM_BYTEORDER_H
 
-#include <asm/swab.h>
-
 #ifdef __ARMEB__
 #include <linux/byteorder/big_endian.h>
 #else
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 219822c..3136628 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -1,4 +1,3 @@
 include include/asm-generic/Kbuild.asm
 
-header-y	+= swab.h
 header-y	+= cachectl.h
diff --git a/arch/avr32/include/asm/byteorder.h b/arch/avr32/include/asm/byteorder.h
index 2aba64b..50abc21 100644
--- a/arch/avr32/include/asm/byteorder.h
+++ b/arch/avr32/include/asm/byteorder.h
@@ -4,7 +4,6 @@
 #ifndef __ASM_AVR32_BYTEORDER_H
 #define __ASM_AVR32_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/big_endian.h>
 
 #endif /* __ASM_AVR32_BYTEORDER_H */
diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/Kbuild
index d0d1ac4..606ecfd 100644
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -1,4 +1,3 @@
 include include/asm-generic/Kbuild.asm
 
 unifdef-y += fixed_code.h
-unifdef-y += swab.h
diff --git a/arch/blackfin/include/asm/byteorder.h b/arch/blackfin/include/asm/byteorder.h
index b9e797a..3e69106 100644
--- a/arch/blackfin/include/asm/byteorder.h
+++ b/arch/blackfin/include/asm/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _BLACKFIN_BYTEORDER_H
 #define _BLACKFIN_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/little_endian.h>
 
 #endif				/* _BLACKFIN_BYTEORDER_H */
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index b79b7c6..d5b6319 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -9,4 +9,3 @@ header-y += sync_serial.h
 
 unifdef-y += etraxgpio.h
 unifdef-y += rs485.h
-unifdef-y += swab.h
diff --git a/arch/cris/include/asm/byteorder.h b/arch/cris/include/asm/byteorder.h
index 7678d86..bcd1897 100644
--- a/arch/cris/include/asm/byteorder.h
+++ b/arch/cris/include/asm/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _CRIS_BYTEORDER_H
 #define _CRIS_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/little_endian.h>
 
 #endif
diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index 27b108a..c68e168 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -1,2 +1 @@
 include include/asm-generic/Kbuild.asm
-unifdef-y += swab.h
diff --git a/arch/h8300/include/asm/byteorder.h b/arch/h8300/include/asm/byteorder.h
index c36b80a..13539da 100644
--- a/arch/h8300/include/asm/byteorder.h
+++ b/arch/h8300/include/asm/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _H8300_BYTEORDER_H
 #define _H8300_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/big_endian.h>
 
 #endif /* _H8300_BYTEORDER_H */
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index 3b25bd9..ccbe8ae 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -14,4 +14,3 @@ unifdef-y += gcc_intrin.h
 unifdef-y += intrinsics.h
 unifdef-y += perfmon.h
 unifdef-y += ustack.h
-unifdef-y += swab.h
diff --git a/arch/ia64/include/asm/byteorder.h b/arch/ia64/include/asm/byteorder.h
index 0f84c5c..a8dd735 100644
--- a/arch/ia64/include/asm/byteorder.h
+++ b/arch/ia64/include/asm/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_IA64_BYTEORDER_H
 #define _ASM_IA64_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/little_endian.h>
 
 #endif /* _ASM_IA64_BYTEORDER_H */
diff --git a/arch/m68knommu/include/asm/Kbuild b/arch/m68knommu/include/asm/Kbuild
index 58c02a4..c68e168 100644
--- a/arch/m68knommu/include/asm/Kbuild
+++ b/arch/m68knommu/include/asm/Kbuild
@@ -1,3 +1 @@
 include include/asm-generic/Kbuild.asm
-
-unifdef-y += swab.h
diff --git a/arch/m68knommu/include/asm/byteorder.h b/arch/m68knommu/include/asm/byteorder.h
index a6f0b8f..9c6c76a 100644
--- a/arch/m68knommu/include/asm/byteorder.h
+++ b/arch/m68knommu/include/asm/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _M68KNOMMU_BYTEORDER_H
 #define _M68KNOMMU_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/big_endian.h>
 
 #endif /* _M68KNOMMU_BYTEORDER_H */
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 023866c..7897f05 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -1,4 +1,3 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += cachectl.h sgidefs.h sysmips.h
-header-y += swab.h
diff --git a/arch/mips/include/asm/byteorder.h b/arch/mips/include/asm/byteorder.h
index 607b718..9579051 100644
--- a/arch/mips/include/asm/byteorder.h
+++ b/arch/mips/include/asm/byteorder.h
@@ -8,8 +8,6 @@
 #ifndef _ASM_BYTEORDER_H
 #define _ASM_BYTEORDER_H
 
-#include <asm/swab.h>
-
 #if defined(__MIPSEB__)
 #include <linux/byteorder/big_endian.h>
 #elif defined(__MIPSEL__)
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index 2121d99..f88b252 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,4 +1,3 @@
 include include/asm-generic/Kbuild.asm
 
 unifdef-y += pdc.h
-unifdef-y += swab.h
diff --git a/arch/parisc/include/asm/byteorder.h b/arch/parisc/include/asm/byteorder.h
index da66029..58af2c5 100644
--- a/arch/parisc/include/asm/byteorder.h
+++ b/arch/parisc/include/asm/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _PARISC_BYTEORDER_H
 #define _PARISC_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/big_endian.h>
 
 #endif /* _PARISC_BYTEORDER_H */
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 9268602..5ab7d7f 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -35,4 +35,3 @@ unifdef-y += spu_info.h
 unifdef-y += termios.h
 unifdef-y += types.h
 unifdef-y += unistd.h
-unifdef-y += swab.h
diff --git a/arch/powerpc/include/asm/byteorder.h b/arch/powerpc/include/asm/byteorder.h
index 5cca27a..aa6cc4f 100644
--- a/arch/powerpc/include/asm/byteorder.h
+++ b/arch/powerpc/include/asm/byteorder.h
@@ -7,8 +7,6 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
-
-#include <asm/swab.h>
 #include <linux/byteorder/big_endian.h>
 
 #endif /* _ASM_POWERPC_BYTEORDER_H */
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index f2af416..63a2341 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -13,4 +13,3 @@ unifdef-y += cmb.h
 unifdef-y += debug.h
 unifdef-y += chpid.h
 unifdef-y += schid.h
-unifdef-y += swab.h
diff --git a/arch/s390/include/asm/byteorder.h b/arch/s390/include/asm/byteorder.h
index b95a2b2..a332e59 100644
--- a/arch/s390/include/asm/byteorder.h
+++ b/arch/s390/include/asm/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _S390_BYTEORDER_H
 #define _S390_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/big_endian.h>
 
 #endif /* _S390_BYTEORDER_H */
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index f1a2a0d..43910cd 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -6,4 +6,3 @@ unifdef-y += unistd_32.h
 unifdef-y += unistd_64.h
 unifdef-y += posix_types_32.h
 unifdef-y += posix_types_64.h
-unifdef-y += swab.h
diff --git a/arch/sh/include/asm/byteorder.h b/arch/sh/include/asm/byteorder.h
index e95c41a..db2f5d7 100644
--- a/arch/sh/include/asm/byteorder.h
+++ b/arch/sh/include/asm/byteorder.h
@@ -1,8 +1,6 @@
 #ifndef __ASM_SH_BYTEORDER_H
 #define __ASM_SH_BYTEORDER_H
 
-#include <asm/swab.h>
-
 #ifdef __LITTLE_ENDIAN__
 #include <linux/byteorder/little_endian.h>
 #else
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index d012070..58f9b3a 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -23,4 +23,3 @@ header-y += traps.h
 header-y += uctx.h
 header-y += utrap.h
 header-y += watchdog.h
-header-y += swab.h
diff --git a/arch/sparc/include/asm/byteorder.h b/arch/sparc/include/asm/byteorder.h
index 48a047c..ccc1b6b 100644
--- a/arch/sparc/include/asm/byteorder.h
+++ b/arch/sparc/include/asm/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _SPARC_BYTEORDER_H
 #define _SPARC_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/big_endian.h>
 
 #endif /* _SPARC_BYTEORDER_H */
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index a9f8a81..4a8e80c 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -22,4 +22,3 @@ unifdef-y += unistd_32.h
 unifdef-y += unistd_64.h
 unifdef-y += vm86.h
 unifdef-y += vsyscall.h
-unifdef-y += swab.h
diff --git a/arch/x86/include/asm/byteorder.h b/arch/x86/include/asm/byteorder.h
index 7c49917..b13a7a8 100644
--- a/arch/x86/include/asm/byteorder.h
+++ b/arch/x86/include/asm/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_BYTEORDER_H
 #define _ASM_X86_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/little_endian.h>
 
 #endif /* _ASM_X86_BYTEORDER_H */
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index 58c02a4..c68e168 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -1,3 +1 @@
 include include/asm-generic/Kbuild.asm
-
-unifdef-y += swab.h
diff --git a/arch/xtensa/include/asm/byteorder.h b/arch/xtensa/include/asm/byteorder.h
index 329b945..54eb631 100644
--- a/arch/xtensa/include/asm/byteorder.h
+++ b/arch/xtensa/include/asm/byteorder.h
@@ -1,8 +1,6 @@
 #ifndef _XTENSA_BYTEORDER_H
 #define _XTENSA_BYTEORDER_H
 
-#include <asm/swab.h>
-
 #ifdef __XTENSA_EL__
 #include <linux/byteorder/little_endian.h>
 #elif defined(__XTENSA_EB__)
diff --git a/include/asm-frv/Kbuild b/include/asm-frv/Kbuild
index 1f44e7c..0f8956d 100644
--- a/include/asm-frv/Kbuild
+++ b/include/asm-frv/Kbuild
@@ -3,4 +3,3 @@ include include/asm-generic/Kbuild.asm
 header-y += registers.h
 
 unifdef-y += termios.h
-unifdef-y += swab.h
diff --git a/include/asm-frv/byteorder.h b/include/asm-frv/byteorder.h
index 1187e51..f29b759 100644
--- a/include/asm-frv/byteorder.h
+++ b/include/asm-frv/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_BYTEORDER_H
 #define _ASM_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/big_endian.h>
 
 #endif /* _ASM_BYTEORDER_H */
diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index 1870d5e..70d1855 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -31,6 +31,7 @@ unifdef-y += socket.h
 unifdef-y += sockios.h
 unifdef-y += stat.h
 unifdef-y += statfs.h
+unifdef-y += swab.h
 unifdef-y += termbits.h
 unifdef-y += termios.h
 unifdef-y += types.h
diff --git a/include/asm-m32r/Kbuild b/include/asm-m32r/Kbuild
index 27b108a..c68e168 100644
--- a/include/asm-m32r/Kbuild
+++ b/include/asm-m32r/Kbuild
@@ -1,2 +1 @@
 include include/asm-generic/Kbuild.asm
-unifdef-y += swab.h
diff --git a/include/asm-m32r/byteorder.h b/include/asm-m32r/byteorder.h
index 61ff9cf..21855d8 100644
--- a/include/asm-m32r/byteorder.h
+++ b/include/asm-m32r/byteorder.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_BYTEORDER_H
 #define _ASM_M32R_BYTEORDER_H
 
-#include <asm/swab.h>
-
 #if defined(__LITTLE_ENDIAN__)
 #  include <linux/byteorder/little_endian.h>
 #else
diff --git a/include/asm-m68k/Kbuild b/include/asm-m68k/Kbuild
index 52fd96b..1a922fa 100644
--- a/include/asm-m68k/Kbuild
+++ b/include/asm-m68k/Kbuild
@@ -1,3 +1,2 @@
 include include/asm-generic/Kbuild.asm
 header-y += cachectl.h
-unifdef-y += swab.h
diff --git a/include/asm-m68k/byteorder.h b/include/asm-m68k/byteorder.h
index 3008665..31b260a 100644
--- a/include/asm-m68k/byteorder.h
+++ b/include/asm-m68k/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _M68K_BYTEORDER_H
 #define _M68K_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/big_endian.h>
 
 #endif /* _M68K_BYTEORDER_H */
diff --git a/include/asm-mn10300/Kbuild b/include/asm-mn10300/Kbuild
index 27b108a..c68e168 100644
--- a/include/asm-mn10300/Kbuild
+++ b/include/asm-mn10300/Kbuild
@@ -1,2 +1 @@
 include include/asm-generic/Kbuild.asm
-unifdef-y += swab.h
diff --git a/include/asm-mn10300/byteorder.h b/include/asm-mn10300/byteorder.h
index 45b18de..5dd0bdd 100644
--- a/include/asm-mn10300/byteorder.h
+++ b/include/asm-mn10300/byteorder.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_BYTEORDER_H
 #define _ASM_BYTEORDER_H
 
-#include <asm/swab.h>
 #include <linux/byteorder/little_endian.h>
 
 #endif /* _ASM_BYTEORDER_H */
diff --git a/include/linux/swab.h b/include/linux/swab.h
index 9a2d33e..26f5f65 100644
--- a/include/linux/swab.h
+++ b/include/linux/swab.h
@@ -3,7 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <asm/byteorder.h>
+#include <asm/swab.h>
 
 /*
  * casts are necessary for constants, because we never know how for sure
-- 
1.6.1.94.g9388


