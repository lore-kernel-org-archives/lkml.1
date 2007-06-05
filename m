Return-Path: <linux-kernel-owner+w=401wt.eu-S1766016AbXFEUow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766016AbXFEUow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 16:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765257AbXFEUoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:44:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58305 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761044AbXFEUon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:44:43 -0400
X-Originating-Ip: 72.143.66.27
Date: Tue, 5 Jun 2007 16:43:02 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: schwidefsky@de.ibm.com, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] S390:  Replace __get_free_pages() with __get_dma_pages().
Message-ID: <Pine.LNX.4.64.0706051641020.19228@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replace the call to __get_free_pages() with the more specific
__get_dma_pages().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 8ff2fea..108e7df 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -708,7 +708,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)

 	for_each_possible_cpu(i) {
 		lowcore_ptr[i] = (struct _lowcore *)
-			__get_free_pages(GFP_KERNEL | GFP_DMA,
+			__get_dma_pages(GFP_KERNEL,
 					 sizeof(void*) == 8 ? 1 : 0);
 		stack = __get_free_pages(GFP_KERNEL, ASYNC_ORDER);
 		if (!lowcore_ptr[i] || !stack)
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
