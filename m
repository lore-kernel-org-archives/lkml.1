Return-Path: <linux-kernel-owner+w=401wt.eu-S1762396AbXE1QMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762396AbXE1QMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762472AbXE1QKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:10:53 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:10108 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762304AbXE1QKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:10:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=RpGnBqDLxybmHbmbs0ctLs+fC4AMkzQON9curXJOMX2C7Zh/huhUdKgmRaU2cabQZW0YVyd4Xt53JBv0Qj4JFCi9ZFDPzNUace1ANxCQOxQWoL4gCGJSm8UmbWtzfm/0qy6TNZHiwJUNuqvK5RrNx0+LpytVv5EEUIbuSSIgdkI=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 5/5] sysfs: fix root sysfs_dirent -> root dentry association
In-Reply-To: <1180368625600-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:10:26 +0900
Message-Id: <11803686261278-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The root sysfs_dirent didn't point to the root dentry fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/mount.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 7f2779e..2d6294b 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -63,6 +63,7 @@ static int sysfs_fill_super(struct super
 		iput(inode);
 		return -ENOMEM;
 	}
+	sysfs_root.s_dentry = root;
 	root->d_fsdata = &sysfs_root;
 	sb->s_root = root;
 	return 0;
-- 
1.4.3.4


