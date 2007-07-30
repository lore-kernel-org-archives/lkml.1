Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbXG3Emj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbXG3Emj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 00:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbXG3Ema
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 00:42:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41670 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbXG3Ema (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 00:42:30 -0400
Date: Mon, 30 Jul 2007 14:42:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Gadi Oxman <gadio@netvision.net.il>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Eliminate warnings in ide-tape.c
Message-Id: <20070730144227.a002faf3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ide/ide-tape.c: In function '__idetape_kmalloc_stage':
drivers/ide/ide-tape.c:2588: warning: large integer implicitly truncated to unsigned type
drivers/ide/ide-tape.c:2616: warning: large integer implicitly truncated to unsigned type

b_size in struct idetape_bh is an unsigned short.  We sometimes assigne
PAGE_SIZE to it and PAGE_SIZE can be 64K or larger, so make it a u32.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/ide/ide-tape.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index e82bfa5..1fa5794 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -640,7 +640,7 @@ typedef enum {
 } idetape_chrdev_direction_t;
 
 struct idetape_bh {
-	unsigned short b_size;
+	u32 b_size;
 	atomic_t b_count;
 	struct idetape_bh *b_reqnext;
 	char *b_data;
-- 
1.5.2.4

