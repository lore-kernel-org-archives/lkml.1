Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZG3Psf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZG3Psf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbZG3Psf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:48:35 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:54933 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZG3Pse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:48:34 -0400
Message-Id: <4A71DD2A020000780000D482@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 30 Jul 2009 16:49:30 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: fix double accounting in reserve_top_address()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With VMALLOC_END included in the calculation of MAXMEM (as of 2.6.28)
it is no longer correct to also bump __VMALLOC_RESERVE in
reserve_top_address(). Doing so results in needlessly small lowmem.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/pgtable.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.31-rc4/arch/x86/mm/pgtable.c	2009-07-28 09:36:41.000000000 +0200
+++ 2.6.31-rc4-i386-reserve-top-address/arch/x86/mm/pgtable.c	2009-07-30 17:27:52.000000000 +0200
@@ -329,7 +329,6 @@ void __init reserve_top_address(unsigned
 	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
 	       (int)-reserve);
 	__FIXADDR_TOP = -reserve - PAGE_SIZE;
-	__VMALLOC_RESERVE += reserve;
 #endif
 }
 



