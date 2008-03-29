Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYC2Rqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYC2Rqd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYC2RqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:46:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:51409 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbYC2Rp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Vx5B3xrC/m4v4ySj8IsIMXs9yjeGBVgEUGWdhCDpiVn9xIGwzQtSmkLXiNj+HMS89mjq3B551GVXZJWXhJHZzxSBcSX0eDzvXE2KcTHdj97X0A4zBaVsXmC/ii8lE3JBBo/Laa+TZ7GG1HRjChjGktNVr8og+ryUjsgq0dMO69w=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 3/5] ide-tape: mv tape->pages_per_stage tape->pages_per_buffer
Date: Sat, 29 Mar 2008 18:46:07 +0100
Message-Id: <1206812769-10065-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1206812769-10065-1-git-send-email-petkovbb@gmail.com>
References: <1206812769-10065-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 7fa0cc0..cf4351c 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -315,8 +315,7 @@ typedef struct ide_tape_obj {
 	char *b_data;
 	int b_count;
 
-	/* Pipeline parameters. */
-	int pages_per_stage;
+	int pages_per_buffer;
 	/* Wasted space in each stage */
 	int excess_bh_size;
 
@@ -1302,7 +1301,7 @@ static idetape_stage_t *ide_tape_kmalloc_buffer(idetape_tape_t *tape, int full,
 {
 	idetape_stage_t *stage;
 	struct idetape_bh *prev_bh, *bh;
-	int pages = tape->pages_per_stage;
+	int pages = tape->pages_per_buffer;
 	unsigned int order, b_allocd;
 	char *b_data = NULL;
 
@@ -2746,9 +2745,9 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		tape->buffer_size = *ctl * tape->blk_size;
 	}
 	buffer_size = tape->buffer_size;
-	tape->pages_per_stage = buffer_size / PAGE_SIZE;
+	tape->pages_per_buffer = buffer_size / PAGE_SIZE;
 	if (buffer_size % PAGE_SIZE) {
-		tape->pages_per_stage++;
+		tape->pages_per_buffer++;
 		tape->excess_bh_size = PAGE_SIZE - buffer_size % PAGE_SIZE;
 	}
 
-- 
1.5.4.1

