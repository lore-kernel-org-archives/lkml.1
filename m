Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbYA0JxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbYA0JxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbYA0JtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:23 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58951 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755956AbYA0JtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:16 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 18/32] ide-tape: use generic byteorder macros
Date: Sun, 27 Jan 2008 10:48:06 +0100
Message-Id: <1201427300-3954-13-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

This is not a network driver.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1435f4e..5a18158 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -784,7 +784,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	if (test_bit(PC_DMA_ERROR, &pc->flags)) {
 		pc->actually_transferred = pc->request_transfer -
 			tape->tape_block_size *
-			ntohl(get_unaligned((u32 *)&sense[3]));
+			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
 		idetape_update_buffers(pc);
 	}
 
@@ -1617,7 +1617,7 @@ static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsi
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_6;
-	put_unaligned(htonl(length), (unsigned int *) &pc->c[1]);
+	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->callback = &idetape_rw_callback;
 	pc->bh = bh;
@@ -1653,7 +1653,7 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, uns
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_6;
-	put_unaligned(htonl(length), (unsigned int *) &pc->c[1]);
+	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->callback = &idetape_rw_callback;
 	set_bit(PC_WRITING, &pc->flags);
@@ -2188,7 +2188,7 @@ static void idetape_create_locate_cmd (ide_drive_t *drive, idetape_pc_t *pc, uns
 	idetape_init_pc(pc);
 	pc->c[0] = POSITION_TO_ELEMENT;
 	pc->c[1] = 2;
-	put_unaligned(htonl(block), (unsigned int *) &pc->c[3]);
+	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[3]);
 	pc->c[8] = partition;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
 	pc->callback = &idetape_pc_callback;
@@ -2379,7 +2379,7 @@ static void idetape_create_space_cmd (idetape_pc_t *pc,int count, u8 cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = SPACE;
-	put_unaligned(htonl(count), (unsigned int *) &pc->c[1]);
+	put_unaligned(cpu_to_be32(count), (unsigned int *) &pc->c[1]);
 	pc->c[1] = cmd;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
 	pc->callback = &idetape_pc_callback;
-- 
1.5.3.7

