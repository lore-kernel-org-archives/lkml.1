Return-Path: <linux-kernel-owner+w=401wt.eu-S934249AbXHOAn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbXHOAn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 20:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbXHOAkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 20:40:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453AbXHOAki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 20:40:38 -0400
From: Andi Kleen <ak@suse.de>
References: <20070815240.194452000@suse.de>
In-Reply-To: <20070815240.194452000@suse.de>
To: jbeulich@novell.com, sam@ravnborg.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [PATCH] [4/4] x86_64: Check for .cfi_rel_offset in CFI probe
Message-Id: <20070815004037.7934714DC8@wotan.suse.de>
Date: Wed, 15 Aug 2007 02:40:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Very old 64bit binutils have .cfi_startproc/endproc, but
no .cfi_rel_offset. Check for .cfi_rel_offset too.

Cc: jbeulich@novell.com
Cc: sam@ravnborg.org

Index: linux/arch/x86_64/Makefile
===================================================================
--- linux.orig/arch/x86_64/Makefile
+++ linux/arch/x86_64/Makefile
@@ -57,8 +57,8 @@ cflags-y += $(call cc-option,-mno-sse -m
 cflags-y += -maccumulate-outgoing-args
 
 # do binutils support CFI?
-cflags-y += $(call as-instr,.cfi_startproc\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
-AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
 
 # is .cfi_signal_frame supported too?
 cflags-y += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
Index: linux/arch/i386/Makefile
===================================================================
--- linux.orig/arch/i386/Makefile
+++ linux/arch/i386/Makefile
@@ -51,8 +51,8 @@ cflags-y += -maccumulate-outgoing-args
 CFLAGS				+= $(shell if [ $(call cc-version) -lt 0400 ] ; then echo $(call cc-option,-fno-unit-at-a-time); fi ;)
 
 # do binutils support CFI?
-cflags-y += $(call as-instr,.cfi_startproc\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
-AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset esp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset esp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
 
 # is .cfi_signal_frame supported too?
 cflags-y += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
