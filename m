Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYERSn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYERSn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbYERSjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:39:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:24872 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbYERSjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:39:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=L0pBdmtcJQNhc1ypJxg6iFYIkVNouZodjkGGHCKoSLR4+yeZVjbwRhWaTB8E7e2bM1KL/n3tr03iLkrqAVukUuOw/Iu/NkrgY0UNJADib6UHzChTYkXTW28uCYx7Mi+4Odh2MtGOlNosgwJVBDGJWGmUxAK5IxRuruM+s0XpfeM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:56:25 +0200
Message-Id: <20080518185625.5636.30760.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/40] ide-tape: remove SIMULATE_ERRORS debug code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |   14 --------------
 1 file changed, 14 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -144,9 +144,6 @@ enum {
 
 /*************************** End of tunable parameters ***********************/
 
-/* Read/Write error simulation */
-#define SIMULATE_ERRORS			0
-
 /* tape directions */
 enum {
 	IDETAPE_DIR_NONE  = (1 << 0),
@@ -745,9 +742,6 @@ static ide_startstop_t idetape_pc_intr(i
 	xfer_func_t *xferfunc;
 	idetape_io_buf *iobuf;
 	unsigned int temp;
-#if SIMULATE_ERRORS
-	static int error_sim_count;
-#endif
 	u16 bcount;
 	u8 stat, ireason;
 
@@ -775,14 +769,6 @@ static ide_startstop_t idetape_pc_intr(i
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		local_irq_enable_in_hardirq();
 
-#if SIMULATE_ERRORS
-		if ((pc->c[0] == WRITE_6 || pc->c[0] == READ_6) &&
-		    (++error_sim_count % 100) == 0) {
-			printk(KERN_INFO "ide-tape: %s: simulating error\n",
-				tape->name);
-			stat |= ERR_STAT;
-		}
-#endif
 		if ((stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
 			stat &= ~ERR_STAT;
 		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
