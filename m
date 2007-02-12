Return-Path: <linux-kernel-owner+w=401wt.eu-S933123AbXBLHpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123AbXBLHpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933088AbXBLHnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:43:53 -0500
Received: from mail.suse.de ([195.135.220.2]:38422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100AbXBLHiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:20 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [31/39] x86_64: Unexport __supported_pte_mask
Message-Id: <20070212073819.62C0313D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The symbol is needed to manipulate page tables, and modules shouldn't
do that.

Leftover from 2.4, but no in tree module should need it now.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/setup64.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/arch/x86_64/kernel/setup64.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup64.c
+++ linux/arch/x86_64/kernel/setup64.c
@@ -37,7 +37,6 @@ struct desc_ptr idt_descr = { 256 * 16 -
 char boot_cpu_stack[IRQSTACKSIZE] __attribute__((section(".bss.page_aligned")));
 
 unsigned long __supported_pte_mask __read_mostly = ~0UL;
-EXPORT_SYMBOL(__supported_pte_mask);
 static int do_not_nx __cpuinitdata = 0;
 
 /* noexec=on|off
