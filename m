Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbYACBgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbYACBgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYACBga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:36:30 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51888 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbYACBg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:36:29 -0500
Date: Wed, 02 Jan 2008 17:41:25 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: not clear empty_zero_page again
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801021741.26217.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: not clear empty_zero_page again

empty_zero_page is in .bss section, and it is cleared in clear_bss by x86_64_start_kernel. So don't clear that again in mem_init

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -521,8 +521,7 @@ void __init mem_init(void)
 
 	pci_iommu_alloc();
 
-	/* clear the zero-page */
-	memset(empty_zero_page, 0, PAGE_SIZE);
+	/* clear_bss() already clear the empty_zero_page */
 
 	reservedpages = 0;
 
