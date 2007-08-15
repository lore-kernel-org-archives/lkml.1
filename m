Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbXHOKj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbXHOKj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 06:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXHOKi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 06:38:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:45721 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbXHOKi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 06:38:56 -0400
From: Andi Kleen <ak@suse.de>
References: <200708151238.148026000@suse.de>
In-Reply-To: <200708151238.148026000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 2.6.22] [2/5] x86_64: Check for .cfi_rel_offset in CFI probe
Message-Id: <20070815103855.5338A14F28@wotan.suse.de>
Date: Wed, 15 Aug 2007 12:38:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Very old binutils have .cfi_startproc/endproc, but
no .cfi_rel_offset. Check for .cfi_rel_offset too.

Cc: jbeulich@novell.com

---
 arch/i386/Makefile   |    4 ++--
 arch/x86_64/Makefile |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.22-stable/arch/x86_64/Makefile
===================================================================
--- linux-2.6.22-stable.orig/arch/x86_64/Makefile
+++ linux-2.6.22-stable/arch/x86_64/Makefile
@@ -57,8 +57,8 @@ cflags-y += $(call cc-option,-mno-sse -m
 cflags-y += -maccumulate-outgoing-args
 
 # do binutils support CFI?
-cflags-y += $(call as-instr,.cfi_startproc\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
-AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
 
 # is .cfi_signal_frame supported too?
 cflags-y += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
Index: linux-2.6.22-stable/arch/i386/Makefile
===================================================================
--- linux-2.6.22-stable.orig/arch/i386/Makefile
+++ linux-2.6.22-stable/arch/i386/Makefile
@@ -51,8 +51,8 @@ cflags-y += -maccumulate-outgoing-args
 CFLAGS				+= $(shell if [ $(call cc-version) -lt 0400 ] ; then echo $(call cc-option,-fno-unit-at-a-time); fi ;)
 
 # do binutils support CFI?
-cflags-y += $(call as-instr,.cfi_startproc\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
-AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset esp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset esp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
 
 # is .cfi_signal_frame supported too?
 cflags-y += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
