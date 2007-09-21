Return-Path: <linux-kernel-owner+w=401wt.eu-S1764602AbXIUUv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764602AbXIUUv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759270AbXIUUpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:07 -0400
Received: from mx1.suse.de ([195.135.220.2]:50046 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763321AbXIUUpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:03 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [20/45] x86_64: Use 8 byte stack alignment when possible
Message-Id: <20070921204502.2C61D14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Kernel doesn't use SSE2, so it doesn't need 16 byte alignment. Also
the stack can be already unaligned so letting the compiler align
is useless. This may make some stack frames smaller.
Only works with very recent gcc 4.3
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/Makefile |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/arch/x86_64/Makefile
===================================================================
--- linux.orig/arch/x86_64/Makefile
+++ linux/arch/x86_64/Makefile
@@ -49,6 +49,8 @@ CFLAGS += $(call cc-option,-mno-sse -mno
 # newer gccs do it by default
 CFLAGS += -maccumulate-outgoing-args
 
+CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
+
 # do binutils support CFI?
 CFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
 AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
