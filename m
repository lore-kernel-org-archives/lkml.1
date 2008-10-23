Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYJWAJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYJWAJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYJWAJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:09:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:15055 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYJWAJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:09:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=YBvRB7Ix/5kicVPsmSgfHVY1X1w0aMlC9TyQCvTUu74S29LC7F/2gmKEtrSDQACmAH
         e0qJeaACYGi2I9nUWl5EYMEziHbdNYkdfK6QpZnGbakooYhbUUG3Kbx2unHbgzc4ieJZ
         eRW4xi/TxkoLz7dlKB8DKBOK4IKw2UUSezlIk=
Subject: [PATCH] mmc: trivial annotation of 'blocks'
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 17:09:00 -0700
Message-Id: <1224720540.6823.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sg_init_one is reading a be32, annotate as such.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/mmc/card/block.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 3d067c3..903c8aa 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -145,7 +145,7 @@ struct mmc_blk_request {
 static u32 mmc_sd_num_wr_blocks(struct mmc_card *card)
 {
 	int err;
-	u32 blocks;
+	__be32 blocks;
 
 	struct mmc_request mrq;
 	struct mmc_command cmd;
@@ -204,9 +204,7 @@ static u32 mmc_sd_num_wr_blocks(struct mmc_card *card)
 	if (cmd.error || data.error)
 		return (u32)-1;
 
-	blocks = ntohl(blocks);
-
-	return blocks;
+	return ntohl(blocks);
 }
 
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
-- 
1.6.0.3.723.g757e



