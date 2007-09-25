Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbXIYMPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbXIYMPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbXIYMPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:15:39 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59553 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbXIYMPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:15:38 -0400
Message-Id: <20070925121251.954162366@polymtl.ca>
References: <20070925121145.262664884@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 08:11:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 3/5] Add samples subdir
Content-Disposition: inline; filename=add-samples-subdir.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 25 Sep 2007 12:12:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Begin infrastructure for kernel code samples in the samples/ directory.
Add its Kconfig and Kbuild files.
Source its Kconfig file in all arch/ Kconfigs.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 Makefile               |   10 +++++++---
 arch/alpha/Kconfig     |    2 ++
 arch/arm/Kconfig       |    2 ++
 arch/avr32/Kconfig     |    2 ++
 arch/blackfin/Kconfig  |    2 ++
 arch/cris/Kconfig      |    2 ++
 arch/frv/Kconfig       |    2 ++
 arch/h8300/Kconfig     |    2 ++
 arch/i386/Kconfig      |    2 ++
 arch/ia64/Kconfig      |    2 ++
 arch/m32r/Kconfig      |    2 ++
 arch/m68k/Kconfig      |    2 ++
 arch/m68knommu/Kconfig |    2 ++
 arch/mips/Kconfig      |    2 ++
 arch/parisc/Kconfig    |    2 ++
 arch/powerpc/Kconfig   |    2 ++
 arch/ppc/Kconfig       |    2 ++
 arch/s390/Kconfig      |    2 ++
 arch/sh/Kconfig        |    2 ++
 arch/sh64/Kconfig      |    2 ++
 arch/sparc/Kconfig     |    2 ++
 arch/sparc64/Kconfig   |    2 ++
 arch/um/Kconfig        |    2 ++
 arch/v850/Kconfig      |    2 ++
 arch/x86_64/Kconfig    |    2 ++
 arch/xtensa/Kconfig    |    3 ++-
 samples/Kconfig        |   11 +++++++++++
 27 files changed, 68 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/Makefile
===================================================================
--- linux-2.6-lttng.orig/Makefile	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/Makefile	2007-09-24 18:21:06.000000000 -0400
@@ -436,6 +436,7 @@ drivers-y	:= drivers/ sound/
 net-y		:= net/
 libs-y		:= lib/
 core-y		:= usr/
+samples-y	:= samples/
 endif # KBUILD_EXTMOD
 
 ifeq ($(dot-config),1)
@@ -574,10 +575,12 @@ core-y		+= kernel/ mm/ fs/ ipc/ security
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
-		     $(net-y) $(net-m) $(libs-y) $(libs-m)))
+		     $(net-y) $(net-m) $(libs-y) $(libs-m))	\
+		     $(samples-y) $(samples-m))
+
 
 vmlinux-alldirs	:= $(sort $(vmlinux-dirs) $(patsubst %/,%,$(filter %/, \
-		     $(init-n) $(init-) \
+		     $(init-n) $(init-) $(samples-n) $(samples-) \
 		     $(core-n) $(core-) $(drivers-n) $(drivers-) \
 		     $(net-n)  $(net-)  $(libs-n)    $(libs-))))
 
@@ -588,6 +591,7 @@ net-y		:= $(patsubst %/, %/built-in.o, $
 libs-y1		:= $(patsubst %/, %/lib.a, $(libs-y))
 libs-y2		:= $(patsubst %/, %/built-in.o, $(libs-y))
 libs-y		:= $(libs-y1) $(libs-y2)
+samples-y	:= $(patsubst %/, %/built-in.o, $(samples-y))
 
 # Build vmlinux
 # ---------------------------------------------------------------------------
@@ -617,7 +621,7 @@ libs-y		:= $(libs-y1) $(libs-y2)
 # System.map is generated to document addresses of all kernel symbols
 
 vmlinux-init := $(head-y) $(init-y)
-vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y)
+vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y) $(samples-y)
 vmlinux-all  := $(vmlinux-init) $(vmlinux-main)
 vmlinux-lds  := arch/$(ARCH)/kernel/vmlinux.lds
 export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
Index: linux-2.6-lttng/samples/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/samples/Kconfig	2007-09-24 18:20:40.000000000 -0400
@@ -0,0 +1,11 @@
+# samples/Kconfig
+
+menuconfig SAMPLES
+	bool "Sample kernel code"
+	help
+	  You can build and test sample kernel code here.
+
+if SAMPLES
+
+
+endif # SAMPLES
Index: linux-2.6-lttng/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/alpha/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -669,5 +669,7 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
 
Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/arm/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -1069,4 +1069,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/avr32/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/avr32/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -237,4 +237,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/blackfin/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/blackfin/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/blackfin/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -1012,4 +1012,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/cris/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/cris/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/cris/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -204,4 +204,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/frv/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/frv/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/frv/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -383,4 +383,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/h8300/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/h8300/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -231,4 +231,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/i386/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/i386/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/i386/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -1259,6 +1259,8 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
 
 #
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/ia64/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -586,3 +586,5 @@ source "arch/ia64/Kconfig.debug"
 source "security/Kconfig"
 
 source "crypto/Kconfig"
+
+source "samples/Kconfig"
Index: linux-2.6-lttng/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -434,4 +434,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/m68k/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -691,4 +691,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68knommu/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/m68knommu/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -704,4 +704,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/mips/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -1969,4 +1969,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/parisc/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -275,4 +275,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -650,3 +650,5 @@ config KEYS_COMPAT
 	default y
 
 source "crypto/Kconfig"
+
+source "samples/Kconfig"
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/ppc/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -1314,3 +1314,5 @@ source "arch/ppc/Kconfig.debug"
 source "security/Kconfig"
 
 source "crypto/Kconfig"
+
+source "samples/Kconfig"
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/s390/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -537,4 +537,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/sh/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -757,4 +757,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/sh64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/sh64/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -293,6 +293,8 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
 
 #
Index: linux-2.6-lttng/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -328,4 +328,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -468,4 +468,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/um/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/um/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/um/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -274,6 +274,8 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
 
 source "drivers/scsi/Kconfig"
Index: linux-2.6-lttng/arch/v850/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/v850/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/v850/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -339,6 +339,8 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
 
 #############################################################################
Index: linux-2.6-lttng/arch/x86_64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -841,4 +841,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "samples/Kconfig"
+
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/xtensa/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/Kconfig	2007-09-24 18:12:11.000000000 -0400
+++ linux-2.6-lttng/arch/xtensa/Kconfig	2007-09-24 18:12:12.000000000 -0400
@@ -259,6 +259,7 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
-source "lib/Kconfig"
+source "samples/Kconfig"
 
+source "lib/Kconfig"
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
