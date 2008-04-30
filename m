Return-Path: <linux-kernel-owner+w=401wt.eu-S933448AbYD3WFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbYD3WFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbYD3WDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:03:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:9632 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764595AbYD3WD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:03:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KnZ3+YBG/j0s8wIvaHQ6lOCR3L9SEWdFosQAZZBENsKzYuad/dvN19heFnfHqea36NIjwMUUqBrLy1ca8HZgRJB/bZjVJXNo5Hrq8lpYjFVjrvk4tIWS3ScuA2wKhEw4kuG+ypTY/sE1eUHjP8TPx2vjqo4grymJ6RBj7fn/hKw=
Subject: [PATCH 05/10] misc: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 15:03:42 -0700
Message-Id: <1209593022.24729.115.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/md/raid10.c:889:17: warning: Using plain integer as NULL pointer
drivers/media/video/cx18/cx18-driver.c:616:12: warning: Using plain integer as NULL pointer
sound/oss/kahlua.c:70:12: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/md/raid10.c                    |    2 +-
 drivers/media/video/cx18/cx18-driver.c |    2 +-
 sound/oss/kahlua.c                     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5938fa9..faf3d89 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -886,7 +886,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	 */
 	raid10_find_phys(conf, r10_bio);
  retry_write:
-	blocked_rdev = 0;
+	blocked_rdev = NULL;
 	rcu_read_lock();
 	for (i = 0;  i < conf->copies; i++) {
 		int d = r10_bio->devs[i].devnum;
diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index 8f5ed9b..3f55d47 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -613,7 +613,7 @@ static int __devinit cx18_probe(struct pci_dev *dev,
 	}
 
 	cx = kzalloc(sizeof(struct cx18), GFP_ATOMIC);
-	if (cx == 0) {
+	if (!cx) {
 		spin_unlock(&cx18_cards_lock);
 		return -ENOMEM;
 	}
diff --git a/sound/oss/kahlua.c b/sound/oss/kahlua.c
index dfe670f..928b567 100644
--- a/sound/oss/kahlua.c
+++ b/sound/oss/kahlua.c
@@ -67,7 +67,7 @@ static int __devinit probe_one(struct pci_dev *pdev, const struct pci_device_id
 		return 1;
 	
 	mem = ioremap(base, 128);
-	if(mem == 0UL)
+	if(!mem)
 		return 1;
 	map = readw(mem + 0x18);	/* Read the SMI enables */
 	iounmap(mem);
-- 
1.5.5.1.305.g7c84


