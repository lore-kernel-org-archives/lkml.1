Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbXJWWic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbXJWWic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXJWWgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:36:44 -0400
Received: from havoc.gtf.org ([69.61.125.42]:48683 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbXJWWgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:36:43 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 5/12] ISDN/sc: fix longstanding warning
Message-Id: <20071023223639.DF51F1F81AB@havoc.gtf.org>
Date: Tue, 23 Oct 2007 18:36:39 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/isdn/sc/shmem.c: In function ‘memcpy_toshmem’:
drivers/isdn/sc/shmem.c:54: warning: passing argument 1 of ‘memcpy_toio’ makes pointer from integer without a cast

Also, remove some unneeded braces, and add some useful whitespace.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/drivers/isdn/sc/shmem.c b/drivers/isdn/sc/shmem.c
index 034d41a..e0331e0 100644
--- a/drivers/isdn/sc/shmem.c
+++ b/drivers/isdn/sc/shmem.c
@@ -28,15 +28,15 @@ void memcpy_toshmem(int card, void *dest, const void *src, size_t n)
 {
 	unsigned long flags;
 	unsigned char ch;
+	unsigned long dest_rem = ((unsigned long) dest) % 0x4000;
 
-	if(!IS_VALID_CARD(card)) {
+	if (!IS_VALID_CARD(card)) {
 		pr_debug("Invalid param: %d is not a valid card id\n", card);
 		return;
 	}
 
-	if(n > SRAM_PAGESIZE) {
+	if (n > SRAM_PAGESIZE)
 		return;
-	}
 
 	/*
 	 * determine the page to load from the address
@@ -50,8 +50,7 @@ void memcpy_toshmem(int card, void *dest, const void *src, size_t n)
 
 	outb(((sc_adapter[card]->shmem_magic + ch * SRAM_PAGESIZE) >> 14) | 0x80,
 		sc_adapter[card]->ioport[sc_adapter[card]->shmem_pgport]);
-	memcpy_toio(sc_adapter[card]->rambase +
-		((unsigned long) dest % 0x4000), src, n);
+	memcpy_toio(sc_adapter[card]->rambase + dest_rem, src, n);
 	spin_unlock_irqrestore(&sc_adapter[card]->lock, flags);
 	pr_debug("%s: set page to %#x\n",sc_adapter[card]->devicename,
 		((sc_adapter[card]->shmem_magic + ch * SRAM_PAGESIZE)>>14)|0x80);
