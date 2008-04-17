Return-Path: <linux-kernel-owner+w=401wt.eu-S934610AbYDQSZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610AbYDQSZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763244AbYDQSYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:24:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:52583 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085AbYDQSYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=scIUNbcz/fMPbOtNpf1fYMASaJy3ivOe0LOML3PK3biGM7eXk+fsngSlKHoNdMKP6K2N+h8wuqE9QzDIGAPABgFYsf0FyylHlhysUJhjDlU4T1yVZtbV8uQv4ySGdrK6fo1gvHADJqSbvFoWlESaInWhjQpe2C1pKP3vVJ266EI=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86_64: reserve dma32 early for gart -fix
Date: Thu, 17 Apr 2008 11:24:34 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804171124.34523.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


using free_bootmem directly

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/pci-dma.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma.c
+++ linux-2.6/arch/x86/kernel/pci-dma.c
@@ -92,7 +92,6 @@ void __init dma32_reserve_bootmem(void)
 }
 static void __init dma32_free_bootmem(void)
 {
-	int node;
 
 	if (end_pfn <= MAX_DMA32_PFN)
 		return;
@@ -100,9 +99,7 @@ static void __init dma32_free_bootmem(vo
 	if (!dma32_bootmem_ptr)
 		return;
 
-	for_each_online_node(node)
-		free_bootmem_node(NODE_DATA(node), __pa(dma32_bootmem_ptr),
-				  dma32_bootmem_size);
+	free_bootmem(__pa(dma32_bootmem_ptr), dma32_bootmem_size);
 
 	dma32_bootmem_ptr = NULL;
 	dma32_bootmem_size = 0;
