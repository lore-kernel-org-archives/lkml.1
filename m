Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZFRRC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZFRRC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZFRRCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:02:22 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:34613 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZFRRCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dsdlFDVCKduy6F+JuFEWnxdaTHoSRjeUrwPuy9pFvfZg712RbKOL2TJDagRZcPt4/F
         abWqf6iDlHCnyVd5gv8NJEMgVZnCuVW3sYd5TznLSCXrclFC29sE9TPh8WczNAeOtDzf
         HxqVHX8LEM8dp1zvW7bq6bdfIdYn3YUfNfqDg=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: android: replace oomkilladj with oom_adj
Date: Thu, 18 Jun 2009 21:02:08 +0400
Message-Id: <1245344528-16477-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2ff05b2b (oom: move oom_adj value from task_struct to mm_struct)
changed it.
Fix build.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/android/lowmemorykiller.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index fe72240..e34dc38 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -103,7 +103,7 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = p->oomkilladj;
+		oom_adj = p->mm->oom_adj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
-- 
1.6.3.1

