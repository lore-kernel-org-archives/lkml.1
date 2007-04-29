Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbXD2LBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbXD2LBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbXD2LBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:01:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:51223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120AbXD2Kw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:52:59 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/48] x86_64: Don't disable basic block reordering
Message-Id: <20070429105251.D9859151D2@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:52:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When compiling with -Os (which is default) the compiler defaults to it
anyways. And with -O2 it probably generates somewhat better (although
also larger) code. 

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/Makefile |    3 ---
 1 file changed, 3 deletions(-)

Index: linux/arch/x86_64/Makefile
===================================================================
--- linux.orig/arch/x86_64/Makefile
+++ linux/arch/x86_64/Makefile
@@ -41,9 +41,6 @@ cflags-y += -mno-red-zone
 cflags-y += -mcmodel=kernel
 cflags-y += -pipe
 cflags-kernel-$(CONFIG_REORDER) += -ffunction-sections
-# this makes reading assembly source easier, but produces worse code
-# actually it makes the kernel smaller too.
-cflags-y += -fno-reorder-blocks
 cflags-y += -Wno-sign-compare
 cflags-y += -fno-asynchronous-unwind-tables
 ifneq ($(CONFIG_DEBUG_INFO),y)
