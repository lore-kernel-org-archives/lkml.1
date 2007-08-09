Return-Path: <linux-kernel-owner+w=401wt.eu-S965027AbXHIMrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965027AbXHIMrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939670AbXHIMlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:42 -0400
Received: from mx1.suse.de ([195.135.220.2]:50901 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939666AbXHIMll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:41 -0400
From: Andi Kleen <ak@suse.de>
References: <20070809241.425881000@suse.de>
In-Reply-To: <20070809241.425881000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [12/12] x86_64: Fix start_kernel warning
Message-Id: <20070809124140.3F8B514F3B@wotan.suse.de>
Date: Thu,  9 Aug 2007 14:41:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix

WARNING: vmlinux.o(.text+0x183): Section mismatch: reference to .init.text:start_kernel (between 'is386' and 'check_x87')

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/head.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/head.S
===================================================================
--- linux.orig/arch/i386/kernel/head.S
+++ linux/arch/i386/kernel/head.S
@@ -163,7 +163,7 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
  */
 
 #ifdef CONFIG_HOTPLUG_CPU
-.section .text,"ax",@progbits
+.section .text.init,"ax",@progbits
 #else
 .section .init.text,"ax",@progbits
 #endif
