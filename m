Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbXKNOv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbXKNOv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXKNOvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:51:40 -0500
Received: from v32413.1blu.de ([88.84.155.73]:47845 "EHLO mail.lenk.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377AbXKNOvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:51:38 -0500
From: Frank Lichtenheld <frank@lichtenheld.de>
To: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org, Frank Lichtenheld <frank@lichtenheld.de>,
       Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] [ISDN] sc: Really, really fix warning
Date: Wed, 14 Nov 2007 15:46:20 +0100
Message-Id: <1195051581-15842-1-git-send-email-frank@lichtenheld.de>
X-Mailer: git-send-email 1.5.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  drivers/isdn/sc/shmem.o
drivers/isdn/sc/shmem.c: In function ‘memcpy_toshmem’:
drivers/isdn/sc/shmem.c:53: warning: passing argument 1 of ‘memcpy_toio’ makes pointer from integer without a cast

9317d4313e0cd51b2256ea9a9316f2d8561e37a8 claimed to fix it, but
it didn't.

CC: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
---
 drivers/isdn/sc/shmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/sc/shmem.c b/drivers/isdn/sc/shmem.c
index e0331e0..06a5554 100644
--- a/drivers/isdn/sc/shmem.c
+++ b/drivers/isdn/sc/shmem.c
@@ -50,7 +50,7 @@ void memcpy_toshmem(int card, void *dest, const void *src, size_t n)
 
 	outb(((sc_adapter[card]->shmem_magic + ch * SRAM_PAGESIZE) >> 14) | 0x80,
 		sc_adapter[card]->ioport[sc_adapter[card]->shmem_pgport]);
-	memcpy_toio(sc_adapter[card]->rambase + dest_rem, src, n);
+	memcpy_toio((void*)(sc_adapter[card]->rambase + dest_rem), src, n);
 	spin_unlock_irqrestore(&sc_adapter[card]->lock, flags);
 	pr_debug("%s: set page to %#x\n",sc_adapter[card]->devicename,
 		((sc_adapter[card]->shmem_magic + ch * SRAM_PAGESIZE)>>14)|0x80);
-- 
1.5.3.4

