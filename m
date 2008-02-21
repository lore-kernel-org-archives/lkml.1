Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbYBURwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbYBURwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 12:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYBURw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 12:52:27 -0500
Received: from qb-out-0506.google.com ([72.14.204.231]:33559 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbYBURwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 12:52:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rfCosykrOSn0FkEVVWxYX5J/NcY/MIOYZKjjcG1lj7NsYNRaoMjOTSm0lQBwjrCJjci/1iXEV7V7K5FA6I7vUn8gHJYxJo2FNBf34YnTP56SkugwjQL0Wksyq5CZzH3MyZF8NKRQUhaaUvjTlJAtY8Ik3yI17bYHHV1huvOvBNw=
Subject: [PATCH] saa7146: fix sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 09:52:36 -0800
Message-Id: <1203616356.20345.45.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Went along with the existing file style.
drivers/media/common/saa7146_core.c:309:6: warning: Using plain integer as NULL pointer
drivers/media/common/saa7146_core.c:311:8: warning: Using plain integer as NULL pointer
drivers/media/common/saa7146_core.c:319:7: warning: Using plain integer as NULL pointer
drivers/media/common/saa7146_core.c:319:28: warning: Using plain integer as NULL pointer
drivers/media/common/saa7146_core.c:325:7: warning: Using plain integer as NULL pointer
drivers/media/common/saa7146_core.c:325:28: warning: Using plain integer as NULL pointer
drivers/media/common/saa7146_fops.c:275:12: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/common/saa7146_core.c |    8 ++++----
 drivers/media/common/saa7146_fops.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 168a8d3..8c755a1 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -306,9 +306,9 @@ static irqreturn_t interrupt_hw(int irq, void *dev_id)
 		return IRQ_NONE;
 	}
 
-	if( 0 != (dev->ext)) {
+	if( NULL != (dev->ext)) {
 		if( 0 != (dev->ext->irq_mask & isr )) {
-			if( 0 != dev->ext->irq_func ) {
+			if( NULL != dev->ext->irq_func ) {
 				dev->ext->irq_func(dev, &isr);
 			}
 			isr &= ~dev->ext->irq_mask;
@@ -316,13 +316,13 @@ static irqreturn_t interrupt_hw(int irq, void *dev_id)
 	}
 	if (0 != (isr & (MASK_27))) {
 		DEB_INT(("irq: RPS0 (0x%08x).\n",isr));
-		if( 0 != dev->vv_data && 0 != dev->vv_callback) {
+		if( NULL != dev->vv_data && NULL != dev->vv_callback) {
 			dev->vv_callback(dev,isr);
 		}
 		isr &= ~MASK_27;
 	}
 	if (0 != (isr & (MASK_28))) {
-		if( 0 != dev->vv_data && 0 != dev->vv_callback) {
+		if( NULL != dev->vv_data && NULL != dev->vv_callback) {
 			dev->vv_callback(dev,isr);
 		}
 		isr &= ~MASK_28;
diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index f0703d8..a73db79 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -272,7 +272,7 @@ static int fops_open(struct inode *inode, struct file *file)
 
 	result = 0;
 out:
-	if( fh != 0 && result != 0 ) {
+	if( fh != NULL && result != 0 ) {
 		kfree(fh);
 		file->private_data = NULL;
 	}
-- 
1.5.4.2.200.g99e75



