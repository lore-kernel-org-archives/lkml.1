Return-Path: <linux-kernel-owner+w=401wt.eu-S1422829AbXCOGGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422829AbXCOGGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 02:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422830AbXCOGGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 02:06:46 -0400
Received: from gw.goop.org ([64.81.55.164]:56884 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422829AbXCOGGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 02:06:46 -0400
Message-ID: <45F8E276.5020609@goop.org>
Date: Wed, 14 Mar 2007 23:06:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH REPOST] No need to use -traditional for processing asm in
 arch/i386/
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No need to use -traditional for processing asm in arch/i386/

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/boot/Makefile            |    4 ++--
 arch/i386/boot/compressed/Makefile |    1 -
 arch/i386/kernel/Makefile          |    2 --
 arch/i386/kernel/entry.S           |    2 +-
 include/asm-i386/percpu.h          |    4 ++--
 5 files changed, 5 insertions(+), 8 deletions(-)

===================================================================
--- a/arch/i386/boot/Makefile
+++ b/arch/i386/boot/Makefile
@@ -36,9 +36,9 @@ HOSTCFLAGS_build.o := $(LINUXINCLUDE)
 # ---------------------------------------------------------------------------
 
 $(obj)/zImage:  IMAGE_OFFSET := 0x1000
-$(obj)/zImage:  EXTRA_AFLAGS := -traditional $(SVGA_MODE) $(RAMDISK)
+$(obj)/zImage:  EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK)
 $(obj)/bzImage: IMAGE_OFFSET := 0x100000
-$(obj)/bzImage: EXTRA_AFLAGS := -traditional $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
+$(obj)/bzImage: EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
 $(obj)/bzImage: BUILDFLAGS   := -b
 
 quiet_cmd_image = BUILD   $@
===================================================================
--- a/arch/i386/boot/compressed/Makefile
+++ b/arch/i386/boot/compressed/Makefile
@@ -6,7 +6,6 @@
 
 targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o \
 			vmlinux.bin.all vmlinux.relocs
-EXTRA_AFLAGS	:= -traditional
 
 LDFLAGS_vmlinux := -T
 CFLAGS_misc.o += -fPIC
===================================================================
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -44,8 +44,6 @@ obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-y				+= pcspeaker.o
 
-EXTRA_AFLAGS   := -traditional
-
 obj-$(CONFIG_SCx200)		+= scx200.o
 
 # vsyscall.o contains the vsyscall DSO images as __initdata.
===================================================================
--- a/arch/i386/kernel/entry.S
+++ b/arch/i386/kernel/entry.S
@@ -635,7 +635,7 @@ ENTRY(name)				\
 	SAVE_ALL;			\
 	TRACE_IRQS_OFF			\
 	movl %esp,%eax;			\
-	call smp_/**/name;		\
+	call smp_##name;		\
 	jmp ret_from_intr;		\
 	CFI_ENDPROC;			\
 ENDPROC(name)
===================================================================
--- a/include/asm-i386/percpu.h
+++ b/include/asm-i386/percpu.h
@@ -20,10 +20,10 @@
 #ifdef CONFIG_SMP
 #define PER_CPU(var, cpu) \
 	movl __per_cpu_offset(,cpu,4), cpu;	\
-	addl $per_cpu__/**/var, cpu;
+	addl $per_cpu__##var, cpu;
 #else /* ! SMP */
 #define PER_CPU(var, cpu) \
-	movl $per_cpu__/**/var, cpu;
+	movl $per_cpu__##var, cpu;
 #endif	/* SMP */
 
 #endif /* !__ASSEMBLY__ */


