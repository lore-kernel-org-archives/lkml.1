Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbZGWFAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbZGWFAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 01:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZGWFAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 01:00:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:62275 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbZGWFAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 01:00:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YUn0ywb/sVQJ/SJfEHle/WlmbyyzBm1H5jFpC9eHjebjgNNxseztUapXqWJ8PknbR3
         NKgx7K8GTpBk+iIuni3+a7+o4YWHHLQVQif7CfFqen1aOB1XACUZjndwegRr8exp4+Wl
         8O6G6zzhZIXpvSODWLhuatntTljKnnnOL47b0=
From: unsik Kim <donari75@gmail.com>
To: axboe@kernel.dk, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, unsik Kim <donari75@gmail.com>
Subject: [PATCH 1/2] mg_disk: remove prohibited sleep operation
Date: Thu, 23 Jul 2009 13:57:45 +0900
Message-Id: <1248325066-4071-1-git-send-email-donari75@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mflash's polling driver operate in standard request_fn_proc's context,
sleep in this isn't permitted.
Signed-off-by: unsik Kim <donari75@gmail.com>
---
 drivers/block/mg_disk.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 64f90f5..26371d5 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -244,8 +244,6 @@ static unsigned int mg_wait(struct mg_host *host, u32 expect, u32 msec)
 			mg_dump_status("not ready", status, host);
 			return MG_ERR_INV_STAT;
 		}
-		if (prv_data->use_polling)
-			msleep(1);
 
 		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
 	} while (time_before(cur_jiffies, expire));
-- 
1.6.0.6

