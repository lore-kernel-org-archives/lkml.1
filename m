Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbYKIUQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbYKIUQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbYKIUQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:16:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:57322 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbYKIUQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:16:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xcyUhWEUMMjQ2Bvnv41NSRDYa5zoHfPKVR/Nu2GqUTG+reFeujJf69jQAHBc0yb81D
         ozXO3oF0rVLx/6sgIMX7XRvyLdMLs+h8u4HaT3y0MeIvycdEylkBKR+G/BbtjtYJzDFG
         cHX6X583sDdSqqRx30c9c0SwM1N12IGQ2T5vM=
Date: Sun, 9 Nov 2008 23:19:55 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH] proc: remove useless WARN_ONs
Message-ID: <20081109201955.GA28502@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added to proc.git]

commit 9f5560c4df483908659fca33e7fa768832f933b2
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Sun Nov 9 23:12:18 2008 +0300

    proc: remove useless WARN_ONs
    
    NULL "struct inode *" means VFS passed NULL inode to ->open.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 486cf3f..4a1c578 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1186,8 +1186,6 @@ static int sched_show(struct seq_file *m, void *v)
 	struct inode *inode = m->private;
 	struct task_struct *p;
 
-	WARN_ON(!inode);
-
 	p = get_proc_task(inode);
 	if (!p)
 		return -ESRCH;
@@ -1205,8 +1203,6 @@ sched_write(struct file *file, const char __user *buf,
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct task_struct *p;
 
-	WARN_ON(!inode);
-
 	p = get_proc_task(inode);
 	if (!p)
 		return -ESRCH;
