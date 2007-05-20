Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbXETRvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbXETRvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 13:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbXETRvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 13:51:09 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49948 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586AbXETRvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 13:51:07 -0400
Date: Sun, 20 May 2007 19:52:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: kconfig - scan all Kconfig files
Message-ID: <20070520175203.GA24511@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I did a quick hack so kconfig could scan all Kconfig files
in the kernel tree.
By scanning all Kconfig files we gain the following:

-> kconfig can report when a depends on refer to an undefined symbol
-> kconfig can report when a select refer to an undefined symbol

Later we can push a lot of common stuff to the top-level Kconfig file.
And that may in the end result in a better structure overall for
Kconfig files.

When executing mconf like this:
ARCH=x86_64 scripts/kconfig/mconf Kconfig

I got the following list of warnings/errors:

arch/arm26/Kconfig:144:warning: type of 'FPE_NWFPE' redefined from 'boolean' to 'tristate'
arch/s390/Kconfig:114:warning: type of 'MATHEMU' redefined from 'tristate' to 'boolean'
arch/s390/Kconfig:524:warning: type of 'PCMCIA' redefined from 'tristate' to 'boolean'
arch/sh64/Kconfig:219:warning: type of 'SH_DMA' redefined from 'boolean' to 'tristate'
arch/um/Kconfig:31:warning: type of 'PCMCIA' redefined from 'tristate' to 'boolean'
arch/um/Kconfig:331:warning: type of 'INPUT' redefined from 'tristate' to 'boolean'
arch/arm/mach-omap1/Kconfig:41:warning: 'select' used by config symbol 'MACH_OMAP_H3' refers to undefined symbol 'GPIOEXPANDER_OMAP'
arch/arm/Kconfig:592:warning: choice values currently only support a single prompt
arch/arm26/Kconfig:163:warning: choice values currently only support a single prompt
arch/cris/Kconfig:87:warning: choice values currently only support a single prompt
arch/h8300/Kconfig.cpu:181:warning: choice values currently only support a single prompt
arch/h8300/Kconfig.cpu:182:warning: defaults for choice values not supported
arch/ia64/Kconfig:325:warning: choice values currently only support a single prompt
arch/m32r/Kconfig:247:warning: choice values currently only support a single prompt
arch/sh64/Kconfig:223:warning: choice values currently only support a single prompt
arch/xtensa/Kconfig:76:warning: choice values currently only support a single prompt
arch/mips/Kconfig:1672:warning: choice values currently only support a single prompt
arch/mips/Kconfig:1678:warning: choice values currently only support a single prompt
arch/mips/Kconfig:1684:warning: choice values currently only support a single prompt
arch/h8300/Kconfig.cpu:102:warning: choice values currently only support a single prompt
arch/h8300/Kconfig.cpu:125:warning: defaults for choice values not supported
arch/h8300/Kconfig.cpu:139:warning: defaults for choice values not supported
arch/m68knommu/Kconfig:607:warning: choice values currently only support a single prompt
arch/h8300/Kconfig.cpu:107:warning: choice values currently only support a single prompt
arch/m68knommu/Kconfig:612:warning: choice values currently only support a single prompt
arch/cris/arch-v10/drivers/Kconfig:607:warning: 'select' used by config symbol 'ETRAX_AXISFLASHMAP' refers to undefined symbol 'MTD_OBSOLETE_CHIPS'
arch/cris/arch-v10/drivers/Kconfig:608:warning: 'select' used by config symbol 'ETRAX_AXISFLASHMAP' refers to undefined symbol 'MTD_AMDSTD'
arch/h8300/Kconfig.cpu:145:warning: defaults for choice values not supported
arch/h8300/Kconfig.cpu:117:warning: defaults for choice values not supported
arch/h8300/Kconfig.cpu:131:warning: defaults for choice values not supported
arch/h8300/Kconfig.cpu:155:warning: defaults for choice values not supported
arch/h8300/Kconfig.cpu:164:warning: defaults for choice values not supported
arch/blackfin/Kconfig:548:warning: choice values currently only support a single prompt
arch/h8300/Kconfig.cpu:125:warning: defaults for choice values not supported
arch/h8300/Kconfig.cpu:139:warning: defaults for choice values not supported
arch/m68knommu/Kconfig:607:warning: choice values currently only support a single prompt
arch/blackfin/Kconfig:553:warning: choice values currently only support a single prompt
arch/m68knommu/Kconfig:612:warning: choice values currently only support a single prompt
arch/x86_64/Kconfig:132:warning: choice values currently only support a single prompt
arch/x86_64/Kconfig:168:warning: choice values currently only support a single prompt
arch/x86_64/Kconfig:151:warning: choice values currently only support a single prompt
arch/m32r/Kconfig:187:warning: defaults for choice values not supported
arch/m32r/Kconfig:343:warning: choice values currently only support a single prompt
arch/m32r/Kconfig:359:warning: choice values currently only support a single prompt
arch/m32r/Kconfig:362:warning: choice values currently only support a single prompt
arch/i386/Kconfig:1094:warning: choice values currently only support a single prompt
arch/i386/Kconfig:1100:warning: choice values currently only support a single prompt
arch/i386/Kconfig:1103:warning: choice values currently only support a single prompt
arch/blackfin/Kconfig:548:warning: choice values currently only support a single prompt
arch/h8300/Kconfig.cpu:102:warning: choice values currently only support a single prompt
arch/h8300/Kconfig.cpu:125:warning: defaults for choice values not supported
arch/h8300/Kconfig.cpu:139:warning: defaults for choice values not supported
arch/blackfin/Kconfig:553:warning: choice values currently only support a single prompt
arch/h8300/Kconfig.cpu:107:warning: choice values currently only support a single prompt
arch/arm/mm/Kconfig:541:warning: choice values currently only support a single prompt
arch/sh/Kconfig:346:warning: choice values currently only support a single prompt
arch/m32r/Kconfig:163:warning: choice values currently only support a single prompt
arch/m32r/Kconfig:164:warning: defaults for choice values not supported
arch/sh/Kconfig:343:warning: choice values currently only support a single prompt
arch/s390/Kconfig:67:warning: defaults for choice values not supported
arch/sh/mm/Kconfig:268:warning: choice values currently only support a single prompt
arch/sh/mm/Kconfig:270:warning: defaults for choice values not supported
arch/alpha/Kconfig:15:warning: defaults for choice values not supported
arch/ia64/Kconfig:26:warning: defaults for choice values not supported
arch/parisc/Kconfig:145:warning: choice values currently only support a single prompt
arch/powerpc/Kconfig:23:warning: defaults for choice values not supported
arch/s390/Kconfig:60:warning: choice values currently only support a single prompt
arch/sparc64/Kconfig:29:warning: defaults for choice values not supported
arch/x86_64/Kconfig:19:warning: defaults for choice values not supported
arch/sh/mm/Kconfig:318:warning: choice values currently only support a single prompt
arch/sh/mm/Kconfig:323:warning: choice values currently only support a single prompt
arch/sh/mm/Kconfig:329:warning: choice values currently only support a single prompt
kernel/Kconfig.hz:20:warning: choice values currently only support a single prompt
kernel/Kconfig.hz:27:warning: choice values currently only support a single prompt
kernel/Kconfig.hz:43:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:795:warning: defaults for choice values not supported
arch/ppc/Kconfig:90:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:94:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:101:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:585:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:395:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:399:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:407:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:522:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:537:warning: choice values currently only support a single prompt
arch/ppc/8xx_io/Kconfig:109:warning: choice values currently only support a single prompt
arch/ppc/8xx_io/Kconfig:112:warning: choice values currently only support a single prompt
arch/ppc/8xx_io/Kconfig:117:warning: choice values currently only support a single prompt
arch/ppc/8xx_io/Kconfig:122:warning: choice values currently only support a single prompt
arch/ppc/platforms/85xx/Kconfig:20:warning: choice values currently only support a single prompt
arch/ppc/platforms/85xx/Kconfig:35:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:1270:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:1273:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:1276:warning: choice values currently only support a single prompt
arch/ppc/Kconfig:1279:warning: choice values currently only support a single prompt
arch/ppc/Kconfig.debug:20:warning: choice values currently only support a single prompt
arch/ppc/Kconfig.debug:23:warning: choice values currently only support a single prompt
arch/ppc/Kconfig.debug:26:warning: choice values currently only support a single prompt
arch/ppc/Kconfig.debug:29:warning: choice values currently only support a single prompt
arch/powerpc/Kconfig:196:warning: choice values currently only support a single prompt
arch/powerpc/Kconfig:200:warning: choice values currently only support a single prompt
arch/powerpc/Kconfig:205:warning: choice values currently only support a single prompt
arch/powerpc/platforms/44x/Kconfig:10:warning: choice values currently only support a single prompt
arch/powerpc/platforms/44x/Kconfig:12:warning: defaults for choice values not supported
arch/powerpc/platforms/85xx/Kconfig:7:warning: choice values currently only support a single prompt
arch/powerpc/platforms/85xx/Kconfig:13:warning: choice values currently only support a single prompt
arch/powerpc/platforms/8xx/Kconfig:14:warning: choice values currently only support a single prompt
arch/powerpc/platforms/8xx/Kconfig:18:warning: choice values currently only support a single prompt
arch/powerpc/platforms/8xx/Kconfig:26:warning: choice values currently only support a single prompt
arch/powerpc/platforms/8xx/Kconfig:53:warning: choice values currently only support a single prompt
arch/powerpc/platforms/8xx/Kconfig:60:warning: choice values currently only support a single prompt
arch/powerpc/platforms/prep/Kconfig:2:warning: choice values currently only support a single prompt
arch/powerpc/platforms/prep/Kconfig:9:warning: defaults for choice values not supported
arch/powerpc/platforms/Kconfig:20:warning: choice values currently only support a single prompt
arch/powerpc/Kconfig:725:warning: choice values currently only support a single prompt
arch/powerpc/Kconfig:728:warning: choice values currently only support a single prompt
arch/powerpc/Kconfig:731:warning: choice values currently only support a single prompt
arch/powerpc/Kconfig:734:warning: choice values currently only support a single prompt
arch/powerpc/platforms/8xx/Kconfig:109:warning: choice values currently only support a single prompt
arch/powerpc/platforms/8xx/Kconfig:112:warning: choice values currently only support a single prompt
arch/powerpc/platforms/8xx/Kconfig:117:warning: choice values currently only support a single prompt
arch/powerpc/platforms/8xx/Kconfig:122:warning: choice values currently only support a single prompt
arch/powerpc/Kconfig.debug:66:warning: choice values currently only support a single prompt
arch/powerpc/Kconfig.debug:69:warning: choice values currently only support a single prompt
arch/powerpc/Kconfig.debug:72:warning: choice values currently only support a single prompt
arch/powerpc/Kconfig.debug:75:warning: choice values currently only support a single prompt
arch/mips/Kconfig:1277:warning: choice values currently only support a single prompt
arch/mips/Kconfig:1285:warning: choice values currently only support a single prompt
arch/mips/Kconfig:1304:warning: choice values currently only support a single prompt
arch/sh64/Kconfig:133:warning: choice values currently only support a single prompt
arch/sparc64/Kconfig:211:warning: choice values currently only support a single prompt
arch/sh64/Kconfig:136:warning: choice values currently only support a single prompt
arch/sparc64/Kconfig:203:warning: choice values currently only support a single prompt
arch/m32r/Kconfig:163:warning: choice values currently only support a single prompt
arch/m32r/Kconfig:164:warning: defaults for choice values not supported
arch/mips/Kconfig:798:warning: choice values currently only support a single prompt
arch/arm/mm/Kconfig:541:warning: choice values currently only support a single prompt
arch/mips/Kconfig:794:warning: choice values currently only support a single prompt
arch/sh/mm/Kconfig:343:warning: choice values currently only support a single prompt
arch/sparc64/Kconfig:211:warning: choice values currently only support a single prompt
arch/sh/mm/Kconfig:350:warning: choice values currently only support a single prompt
arch/sh/mm/Kconfig:353:warning: choice values currently only support a single prompt
arch/sh/mm/Kconfig:343:warning: choice values currently only support a single prompt
arch/sh64/Kconfig:133:warning: choice values currently only support a single prompt
arch/i386/Kconfig:128:warning: choice values currently only support a single prompt
arch/i386/Kconfig.cpu:138:warning: choice values currently only support a single prompt
arch/i386/Kconfig.cpu:108:warning: choice values currently only support a single prompt
arch/alpha/Kconfig:557:error: found recursive dependency: NUMA -> ARCH_SPARSEMEM_ENABLE -> ARCH_SELECT_MEMORY_MODEL -> SELECT_MEMORY_MODEL -> DISCONTIGMEM -> NUMA
 -> X86_64_ACPI_NUMA -> ACPI -> ACPI_ACarch/powerpc/Kconfig:166:error: found recursive dependency: PPC_83xx -> 83xx -> PPC_83xx
 -> 6xx -> PPC_STD_MMU -> SMP -> SOFTWARE_SUSPEND -> PM_STD_PARTITIONarch/alpha/Kconfig:301:error: found recursive dependency: ISA -> EISA -> ISA
 -> SND_WAVEFRONTinit/Kconfig:427:error: found recursive dependency: HOTPLUG -> HOTPLUG_CPU -> HOTPLUG
 -> PCCARD -> PCMCIA -> NET_PCMCIA -> PCMCIA_FMVJ18Xarch/arm/Kconfig:775:error: found recursive dependency: ZBOOT_ROM -> ZBOOT_ROM_TEXT -> ZBOOT_ROM
 -> XIP_KERNEL -> XIP_PHYS_ADDRARCH=x86_64


Notice we now have a few _valid_ "select refter to undefined symbol".

All the "choice values currently only support a single prompt" are caused
by using the same config symbol in a choice list for several architectures.
That will be the biggest challenge to fix before we can introduce this patch.
Maybe we can extend kconfig to accept it???

Patch follow.
I had to do: touch arch/um/Kconfig.arch
to actually run mconf.

	Sam

 a/Kconfig                             |  105 ++++++++++++++++++++++++++++++++++
 b/arch/arm/Kconfig                    |    2 
 b/arch/arm26/Kconfig                  |    2 
 b/arch/avr32/Kconfig                  |    2 
 b/arch/blackfin/Kconfig               |    2 
 b/arch/cris/Kconfig                   |    2 
 b/arch/frv/Kconfig                    |    2 
 b/arch/h8300/Kconfig                  |    2 
 b/arch/i386/Kconfig                   |    2 
 b/arch/ia64/Kconfig                   |    2 
 b/arch/m32r/Kconfig                   |    2 
 b/arch/m68k/Kconfig                   |    2 
 b/arch/m68knommu/Kconfig              |    2 
 b/arch/mips/Kconfig                   |    2 
 b/arch/parisc/Kconfig                 |    2 
 b/arch/powerpc/Kconfig                |    2 
 b/arch/ppc/Kconfig                    |    2 
 b/arch/s390/Kconfig                   |    2 
 b/arch/sh/Kconfig                     |    2 
 b/arch/sh64/Kconfig                   |    2 
 b/arch/sparc/Kconfig                  |    2 
 b/arch/sparc64/Kconfig                |    2 
 b/arch/um/Kconfig                     |    2 
 b/arch/v850/Kconfig                   |    2 
 b/arch/x86_64/Kconfig                 |    2 
 b/arch/xtensa/Kconfig                 |    2 
 b/scripts/kconfig/lex.zconf.c_shipped |   19 +++---
 27 files changed, 115 insertions(+), 59 deletions(-)
diff --git a/scripts/kconfig/lex.zconf.c_shipped b/scripts/kconfig/lex.zconf.c_shipped
index 0fdc904..dca0a63 100644
--- a/scripts/kconfig/lex.zconf.c_shipped
+++ b/scripts/kconfig/lex.zconf.c_shipped
@@ -2293,7 +2293,16 @@ void zconf_initscan(const char *name)
 void zconf_nextfile(const char *name)
 {
 	struct file *file = file_lookup(name);
-	struct buffer *buf = malloc(sizeof(*buf));
+	struct buffer *buf;
+	if (file->flags & FILE_BUSY) {
+		printf("kconfig: recursive scan (%s)?\n", name);
+		exit(1);
+	}
+	if (file->flags & FILE_SCANNED) {
+		//printf("kconfig: file %s already scanned?\n", name);
+		return;
+	}
+	buf = malloc(sizeof(*buf));
 	memset(buf, 0, sizeof(*buf));
 
 	current_buf->state = YY_CURRENT_BUFFER;
@@ -2306,14 +2315,6 @@ void zconf_nextfile(const char *name)
 	buf->parent = current_buf;
 	current_buf = buf;
 
-	if (file->flags & FILE_BUSY) {
-		printf("recursive scan (%s)?\n", name);
-		exit(1);
-	}
-	if (file->flags & FILE_SCANNED) {
-		printf("file %s already scanned?\n", name);
-		exit(1);
-	}
 	file->flags |= FILE_BUSY;
 	file->lineno = 1;
 	file->parent = current_file;
--- /dev/null	2007-04-11 18:11:35.000000000 +0200
+++ a/Kconfig	2007-05-20 19:35:02.000000000 +0200
@@ -0,0 +1,105 @@
+mainmenu "Linux kernel configuration"
+
+if ARCH = alpha
+source arch/alpha/Kconfig
+endif
+
+if ARCH = arm
+source arch/arm/Kconfig
+endif
+
+if ARCH = arm26
+source arch/arm26/Kconfig
+endif
+
+if ARCH = avr32
+source arch/avr32/Kconfig
+endif
+
+if ARCH = blackfin
+source arch/blackfin/Kconfig
+endif
+
+if ARCH = cris
+source arch/cris/Kconfig
+endif
+
+if ARCH = frv
+source arch/frv/Kconfig
+endif
+
+if ARCH = h8300
+source arch/h8300/Kconfig
+endif
+
+if ARCH = i386
+source arch/i386/Kconfig
+endif
+
+if ARCH = ia64
+source arch/ia64/Kconfig
+endif
+
+if ARCH = m32r
+source arch/m32r/Kconfig
+endif
+
+if ARCH = m68k
+source arch/m68k/Kconfig
+endif
+
+if ARCH = m68knommu
+source arch/m68knommu/Kconfig
+endif
+
+if ARCH = mips
+source arch/mips/Kconfig
+endif
+
+if ARCH = parisc
+source arch/parisc/Kconfig
+endif
+
+if ARCH = powerpc
+source arch/powerpc/Kconfig
+endif
+
+if ARCH = ppc
+source arch/ppc/Kconfig
+endif
+
+if ARCH = s390
+source arch/s390/Kconfig
+endif
+
+if ARCH = sh
+source arch/sh/Kconfig
+endif
+
+if ARCH = sh64
+source arch/sh64/Kconfig
+endif
+
+if ARCH = sparc
+source arch/sparc/Kconfig
+endif
+
+if ARCH = sparc64
+source arch/sparc64/Kconfig
+endif
+
+if ARCH = um
+source arch/um/Kconfig
+endif
+
+if ARCH = v850
+source arch/v850/Kconfig
+endif
+
+if ARCH = x86_64
+source arch/x86_64/Kconfig
+endif
+
+if ARCH = xtensa
+source arch/xtensa/Kconfig
+endif
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e55bbd3..5e476d3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "Linux Kernel Configuration"
-
 config ARM
 	bool
 	default y
diff --git a/arch/arm26/Kconfig b/arch/arm26/Kconfig
index 20688bc..fe58b5b 100644
--- a/arch/arm26/Kconfig
+++ b/arch/arm26/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "Linux Kernel Configuration"
-
 config ARM
 	bool
 	default y
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 3ec7658..04a5da9 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "Linux Kernel Configuration"
-
 config AVR32
 	bool
 	default y
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index d80e5b1..af4e2fa 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "uClinux/Blackfin (w/o MMU) Kernel Configuration"
-
 config MMU
 	bool
 	default n
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 4b41248..ddd83f6 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -3,8 +3,6 @@
 # see the Configure script.
 #
 
-mainmenu "Linux/CRIS Kernel Configuration"
-
 config MMU
 	bool
 	default y
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 74eef71..2841536 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -57,8 +57,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y
 
-mainmenu "Fujitsu FR-V Kernel Configuration"
-
 source "init/Kconfig"
 
 
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 618dbad..5a2eb69 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/config-language.txt.
 #
 
-mainmenu "uClinux/h8300 (w/o MMU) Kernel Configuration"
-
 config H8300
 	bool
 	default y
diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index c2d54b8..fc37622 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "Linux Kernel Configuration"
-
 config X86_32
 	bool
 	default y
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index de1bff6..a0233d2 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "IA-64 Linux Kernel Configuration"
-
 source "init/Kconfig"
 
 menu "Processor type and features"
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index c3bb8a7..7f13732 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "Linux/M32R Kernel Configuration"
-
 config M32R
 	bool
 	default y
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index b8536c7..980300f 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -45,8 +45,6 @@ config ARCH_MAY_HAVE_PC_FDC
 config NO_IOPORT
 	def_bool y
 
-mainmenu "Linux/68k Kernel Configuration"
-
 source "init/Kconfig"
 
 menu "Platform dependent setup"
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index adc64a2..3fdd46a 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "uClinux/68k (w/o MMU) Kernel Configuration"
-
 config M68K
 	bool
 	default y
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 0f09412..86081e9 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -4,8 +4,6 @@ config MIPS
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 
-mainmenu "Linux/MIPS Kernel Configuration"
-
 menu "Machine selection"
 
 config ZONE_DMA
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 3d73545..c4fa459 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "Linux/PA-RISC Kernel Configuration"
-
 config PARISC
 	def_bool y
 	help
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 56d3c0d..ea82a13 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -2,8 +2,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "Linux/PowerPC Kernel Configuration"
-
 config PPC64
 	bool "64-bit kernel"
 	default n
diff --git a/arch/ppc/Kconfig b/arch/ppc/Kconfig
index ccce2a4..4caf065 100644
--- a/arch/ppc/Kconfig
+++ b/arch/ppc/Kconfig
@@ -2,8 +2,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "Linux/PowerPC Kernel Configuration"
-
 config MMU
 	bool
 	default y
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 098c62c..8da1868 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -47,8 +47,6 @@ config NO_IOMEM
 config NO_DMA
 	def_bool y
 
-mainmenu "Linux Kernel Configuration"
-
 config S390
 	def_bool y
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 038179e..ead986f 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "Linux/SuperH Kernel Configuration"
-
 config SUPERH
 	bool
 	default y
diff --git a/arch/sh64/Kconfig b/arch/sh64/Kconfig
index ff65420..8ee67ef 100644
--- a/arch/sh64/Kconfig
+++ b/arch/sh64/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/config-language.txt.
 #
 
-mainmenu "Linux/SH64 Kernel Configuration"
-
 config SUPERH
 	bool
 	default y
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index bd992c0..ee8bf7a 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -3,8 +3,6 @@
 # see Documentation/kbuild/kconfig-language.txt.
 #
 
-mainmenu "Linux/SPARC Kernel Configuration"
-
 config MMU
 	bool
 	default y
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 831781c..6964829 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -3,8 +3,6 @@
 # see the Configure script.
 #
 
-mainmenu "Linux/UltraSPARC Kernel Configuration"
-
 config SPARC
 	bool
 	default y
diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index c504312..0a12528 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -19,8 +19,6 @@ config MMU
 config NO_IOMEM
 	def_bool y
 
-mainmenu "Linux/Usermode Kernel Configuration"
-
 config ISA
 	bool
 
diff --git a/arch/v850/Kconfig b/arch/v850/Kconfig
index ace479a..8a4594b 100644
--- a/arch/v850/Kconfig
+++ b/arch/v850/Kconfig
@@ -5,8 +5,6 @@
 #
 #############################################################################
 
-mainmenu "uClinux/v850 (w/o MMU) Kernel Configuration"
-
 config MMU
        	bool
 	default n
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 145bb82..31640d2 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -7,8 +7,6 @@
 # ISA drivers you need yourself.
 #
 
-mainmenu "Linux Kernel Configuration"
-
 config X86_64
 	bool
 	default y
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 7fbb44b..1db0de2 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -1,8 +1,6 @@
 # For a description of the syntax of this configuration file,
 # see Documentation/kbuild/config-language.txt.
 
-mainmenu "Linux/Xtensa Kernel Configuration"
-
 config FRAME_POINTER
 	bool
 	default n
