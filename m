Return-Path: <linux-kernel-owner+w=401wt.eu-S1761743AbXGYJyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761743AbXGYJyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 05:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbXGYJxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 05:53:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:17583 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbXGYJxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 05:53:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=iF3YF6tcowC5N0ZKLhxxwo09nVAI1bO0K0kSM/DozB6ldDfC+ivOQV66e+x91ab/P3bQ8NLeNsMqCxEIeLQ4nsc+IEetc2yCyeZ/C8dIrOpqDxNaPXMNWc6I/OX9jk6Rtzw7DIUKYHmjV64Yvs+r5hScYR3F3QkFnn/C/+hv3pg=
From: Denis Cheng <crquan@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       Denis Cheng <crquan@gmail.com>
Subject: [PATCH] gfs2/locking/dlm: use an temp variable to reduce a spin_unlock
Date: Wed, 25 Jul 2007 17:53:58 +0800
Message-Id: <11853572382497-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this is more clear.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/gfs2/locking/dlm/plock.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/locking/dlm/plock.c b/fs/gfs2/locking/dlm/plock.c
index fba1f1d..1f7b038 100644
--- a/fs/gfs2/locking/dlm/plock.c
+++ b/fs/gfs2/locking/dlm/plock.c
@@ -346,15 +346,16 @@ static ssize_t dev_write(struct file *file, const char __user *u, size_t count,
 
 static unsigned int dev_poll(struct file *file, poll_table *wait)
 {
+	unsigned int mask = 0;
+
 	poll_wait(file, &send_wq, wait);
 
 	spin_lock(&ops_lock);
-	if (!list_empty(&send_list)) {
-		spin_unlock(&ops_lock);
-		return POLLIN | POLLRDNORM;
-	}
+	if (!list_empty(&send_list))
+		mask = POLLIN | POLLRDNORM;
 	spin_unlock(&ops_lock);
-	return 0;
+
+	return mask;
 }
 
 static const struct file_operations dev_fops = {
-- 
1.5.2.2

