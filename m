Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYJIIzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYJIIzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 04:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYJIIzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 04:55:38 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:41105 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYJIIzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:55:37 -0400
From: David John <davidjon@xenontk.org>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, bob.picco@hp.com
Subject: [PATCH] HPET: Remove the BKL.
Date: Thu,  9 Oct 2008 14:25:35 +0530
Message-Id: <1223542535-3272-1-git-send-email-davidjon@xenontk.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Concurrent access is protected by the spin lock hpet_lock. The
BKL is not required.

Signed-off-by: David John <davidjon@xenontk.org>
---
 drivers/char/hpet.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index b3f5dbc..00765f9 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -194,7 +194,6 @@ static int hpet_open(struct inode *inode, struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
 
-	lock_kernel();
 	spin_lock_irq(&hpet_lock);
 
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
@@ -209,7 +208,6 @@ static int hpet_open(struct inode *inode, struct file *file)
 
 	if (!devp) {
 		spin_unlock_irq(&hpet_lock);
-		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -217,7 +215,6 @@ static int hpet_open(struct inode *inode, struct file *file)
 	devp->hd_irqdata = 0;
 	devp->hd_flags |= HPET_OPEN;
 	spin_unlock_irq(&hpet_lock);
-	unlock_kernel();
 
 	return 0;
 }
