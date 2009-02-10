Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZBJIVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZBJIVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 03:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbZBJIVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 03:21:13 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59588 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbZBJIVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 03:21:13 -0500
X-Sasl-enc: KwmYl20UvJa3ePxnwIoLj3s4iJgQxrUKcCQXPQSRkxiQ 1234254071
Message-ID: <499138F3.9060903@ladisch.de>
Date: Tue, 10 Feb 2009 09:21:07 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] i8327: fix outb() parameter order
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In i8237A_resume(), when resetting the DMA controller, the parameters to
dma_outb() were mixed up.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- linux-2.6.orig/arch/x86/kernel/i8237.c
+++ linux-2.6/arch/x86/kernel/i8237.c
@@ -28,8 +28,8 @@ static int i8237A_resume(struct sys_devi
 
 	flags = claim_dma_lock();
 
-	dma_outb(DMA1_RESET_REG, 0);
-	dma_outb(DMA2_RESET_REG, 0);
+	dma_outb(0, DMA1_RESET_REG);
+	dma_outb(0, DMA2_RESET_REG);
 
 	for (i = 0;i < 8;i++) {
 		set_dma_addr(i, 0x000000);
