Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbZIDIJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbZIDIJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbZIDIJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:09:14 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32888 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbZIDIJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:09:12 -0400
Message-Id: <4AA0E74C02000078000136F0@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 04 Sep 2009 09:09:16 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: consolidate boot/compressed/Makefile's list of
	 targets
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Rather than (inconsistently) having some target specifications
scattered around and some listed at the top of the file, list them all
in one place. And make use of suffix-y to reduce the list's length.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/boot/compressed/Makefile |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- linux-2.6.31-rc8/arch/x86/boot/compressed/Makefile	2009-08-28 14:54:26.000000000 +0200
+++ 2.6.31-rc8-x86-boot-targets/arch/x86/boot/compressed/Makefile	2009-09-02 12:14:16.000000000 +0200
@@ -4,7 +4,12 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
+suffix-$(CONFIG_KERNEL_GZIP)	:= gz
+suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
+suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
+
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.$(suffix-y) \
+	vmlinux.bin.all vmlinux.relocs head_$(BITS).o misc.o piggy.o piggy.S
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -30,8 +35,6 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
-
-targets += vmlinux.bin.all vmlinux.relocs relocs
 hostprogs-$(CONFIG_X86_NEED_RELOCS) += relocs
 
 quiet_cmd_relocs = RELOCS  $@
@@ -49,13 +52,8 @@ $(obj)/vmlinux.bin.bz2: $(vmlinux.bin.al
 $(obj)/vmlinux.bin.lzma: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lzma)
 
-suffix-$(CONFIG_KERNEL_GZIP)	:= gz
-suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
-suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
-
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
 
-targets += piggy.S
 $(obj)/piggy.S: $(obj)/vmlinux.bin.$(suffix-y) $(obj)/mkpiggy FORCE
 	$(call if_changed,mkpiggy)



