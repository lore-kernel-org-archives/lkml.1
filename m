Return-Path: <linux-kernel-owner+w=401wt.eu-S1422714AbXBOXss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422714AbXBOXss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422700AbXBOXss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:48:48 -0500
Received: from gw.goop.org ([64.81.55.164]:58400 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422714AbXBOXsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:48:47 -0500
Message-ID: <45D4F138.9050405@goop.org>
Date: Thu, 15 Feb 2007 15:48:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] No need to use -traditional for processing asm in i386/kernel/
References: <45D4CE50.9020604@goop.org> <20070215224439.GA7909@uranus.ravnborg.org>
In-Reply-To: <20070215224439.GA7909@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Thu, Feb 15, 2007 at 01:19:12PM -0800, Jeremy Fitzhardinge wrote:
>   
>> No need to use -traditional for processing asm in i386/kernel/
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>>     
>
> Any possibility that you could 'fix' the three remaining
> uses of -traditional in i386?
>   

Sure.  Looks like they're not even really used.

    J

--

No need to use -traditional for processing asm in arch/i386/

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

diff -r 9e6791a29740 arch/i386/boot/Makefile
--- a/arch/i386/boot/Makefile	Thu Feb 15 11:57:29 2007 -0800
+++ b/arch/i386/boot/Makefile	Thu Feb 15 15:45:46 2007 -0800
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
diff -r 9e6791a29740 arch/i386/boot/compressed/Makefile
--- a/arch/i386/boot/compressed/Makefile	Thu Feb 15 11:57:29 2007 -0800
+++ b/arch/i386/boot/compressed/Makefile	Thu Feb 15 15:45:46 2007 -0800
@@ -6,7 +6,6 @@
 
 targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o \
 			vmlinux.bin.all vmlinux.relocs
-EXTRA_AFLAGS	:= -traditional
 
 LDFLAGS_vmlinux := -T
 CFLAGS_misc.o += -fPIC
diff -r 9e6791a29740 arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile	Thu Feb 15 11:57:29 2007 -0800
+++ b/arch/i386/kernel/Makefile	Thu Feb 15 15:45:46 2007 -0800
@@ -44,8 +44,6 @@ obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-y				+= pcspeaker.o
 
-EXTRA_AFLAGS   := -traditional
-
 obj-$(CONFIG_SCx200)		+= scx200.o
 
 # vsyscall.o contains the vsyscall DSO images as __initdata.
diff -r 9e6791a29740 arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S	Thu Feb 15 11:57:29 2007 -0800
+++ b/arch/i386/kernel/entry.S	Thu Feb 15 15:45:46 2007 -0800
@@ -635,7 +635,7 @@ ENTRY(name)				\
 	SAVE_ALL;			\
 	TRACE_IRQS_OFF			\
 	movl %esp,%eax;			\
-	call smp_/**/name;		\
+	call smp_##name;		\
 	jmp ret_from_intr;		\
 	CFI_ENDPROC;			\
 ENDPROC(name)
diff -r 9e6791a29740 include/asm-i386/percpu.h
--- a/include/asm-i386/percpu.h	Thu Feb 15 11:57:29 2007 -0800
+++ b/include/asm-i386/percpu.h	Thu Feb 15 15:45:46 2007 -0800
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

