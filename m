Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbXJYHuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbXJYHuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 03:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbXJYHu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 03:50:27 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58318 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbXJYHuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 03:50:25 -0400
Date: Thu, 25 Oct 2007 03:50:24 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] warning fix
Message-ID: <20071025075024.GA8919@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ack'd by the ISDN maintainer.

Please pull from 'warnings-upstream' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git warnings-upstream

to receive the following updates:

 drivers/isdn/sc/shmem.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

Jeff Garzik (1):
      ISDN/sc: fix longstanding warning

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
