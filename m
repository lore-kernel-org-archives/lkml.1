Return-Path: <linux-kernel-owner+w=401wt.eu-S1762229AbYA3KZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762229AbYA3KZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757860AbYA3KZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:25:13 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:50920 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbYA3KZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:25:11 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61207256"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-kernel@vger.kernel.org
Cc: Bernd Schmidt <bernd.schmidt@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/1] [NOMMU]: Dont use kobjsize on the area belonging to a VMA
Date: Wed, 30 Jan 2008 18:25:08 +0800
Message-Id: <1201688708-2152-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Schmidt <bernd.schmidt@analog.com>

Dont use kobjsize on the area belonging to a VMA, as it's allocated with
get_free_pages.

Signed-off-by: Bernd Schmidt <bernd.schmidt@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 fs/proc/task_nommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 1932c2c..1d0513e 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -76,7 +76,7 @@ unsigned long task_vsize(struct mm_struct *mm)
 	down_read(&mm->mmap_sem);
 	for (tbp = mm->context.vmlist; tbp; tbp = tbp->next) {
 		if (tbp->vma)
-			vsize += kobjsize((void *) tbp->vma->vm_start);
+			vsize += tbp->vma->vm_end - tbp->vma->vm_start;
 	}
 	up_read(&mm->mmap_sem);
 	return vsize;
@@ -93,7 +93,7 @@ int task_statm(struct mm_struct *mm, int *shared, int *text,
 		size += kobjsize(tbp);
 		if (tbp->vma) {
 			size += kobjsize(tbp->vma);
-			size += kobjsize((void *) tbp->vma->vm_start);
+			size += tbp->vma->vm_end - tbp->vma->vm_start;
 		}
 	}
 
-- 
1.5.3.4
