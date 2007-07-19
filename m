Return-Path: <linux-kernel-owner+w=401wt.eu-S1762143AbXGSJ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143AbXGSJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXGSJys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:54:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:35331 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbXGSJyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:46 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/58] x86_64: Tell gcc to only align stack to 8 bytes
Message-Id: <20070719095445.DC94514E04@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Don't need 16 byte alignment because kernel doesn't use SSE2

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/Makefile |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86_64/Makefile
===================================================================
--- linux.orig/arch/x86_64/Makefile
+++ linux/arch/x86_64/Makefile
@@ -55,6 +55,7 @@ cflags-y += $(call cc-option,-mno-sse -m
 # this works around some issues with generating unwind tables in older gccs
 # newer gccs do it by default
 cflags-y += -maccumulate-outgoing-args
+cflags-y += -mpreferred-stack-boundary=4
 
 # do binutils support CFI?
 cflags-y += $(call as-instr,.cfi_startproc\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
