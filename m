Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZCKTXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZCKTXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZCKTXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:23:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:60101 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbZCKTXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:23:35 -0400
Message-ID: <49B80F7B.2020007@kernel.org>
Date: Wed, 11 Mar 2009 12:22:35 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: relocs is only used with 32bit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

those lines is not needed for 64bit

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/compressed/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/arch/x86/boot/compressed/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/Makefile
+++ linux-2.6/arch/x86/boot/compressed/Makefile
@@ -26,6 +26,7 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
+ifeq ($(CONFIG_X86_32),y)
 
 targets += vmlinux.bin.all vmlinux.relocs relocs
 hostprogs-$(CONFIG_X86_32) += relocs
@@ -42,8 +43,6 @@ quiet_cmd_relocbin = BUILD   $@
 $(obj)/vmlinux.bin.all: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,relocbin)
 
-ifeq ($(CONFIG_X86_32),y)
-
 ifdef CONFIG_RELOCATABLE
 $(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin.all FORCE
 	$(call if_changed,gzip)
