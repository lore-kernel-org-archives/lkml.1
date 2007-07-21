Return-Path: <linux-kernel-owner+w=401wt.eu-S1762836AbXGUS7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836AbXGUS7f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 14:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbXGUS7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 14:59:21 -0400
Received: from dev.gentooexperimental.org ([81.93.240.53]:43800 "EHLO
	dev.gentooexperimental.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762318AbXGUS7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 14:59:19 -0400
X-Greylist: delayed 1986 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Jul 2007 14:59:19 EDT
From: Charlie Shepherd <masterdriverz@gentoo.org>
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       torvalds@linux-foundation.org
Cc: Charlie Shepherd <masterdriverz@gentoo.org>
Subject: [PATCH] Remove 'isdn_* is defined but unused' warnings
Date: Sat, 21 Jul 2007 20:26:48 +0200
Message-Id: <11850424081791-git-send-email-masterdriverz@gentoo.org>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11850424083434-git-send-email-masterdriverz@gentoo.org>
References: <11850424083434-git-send-email-masterdriverz@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the #ifdef guard above these functions to remove the warnings.

Signed-off-by: Charlie Shepherd <masterdriverz@gentoo.org>
---
 drivers/isdn/divert/divert_procfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
index be77ee6..559a0d0 100644
--- a/drivers/isdn/divert/divert_procfs.c
+++ b/drivers/isdn/divert/divert_procfs.c
@@ -70,6 +70,8 @@ put_info_buffer(char *cp)
 	wake_up_interruptible(&(rd_queue));
 }				/* put_info_buffer */
 
+#ifdef CONFIG_PROC_FS
+
 /**********************************/
 /* deflection device read routine */
 /**********************************/
@@ -253,8 +255,6 @@ isdn_divert_ioctl(struct inode *inode, struct file *file,
 	return copy_to_user((void __user *)arg, &dioctl, sizeof(dioctl)) ? -EFAULT : 0;
 }				/* isdn_divert_ioctl */
 
-
-#ifdef CONFIG_PROC_FS
 static const struct file_operations isdn_fops =
 {
 	.owner          = THIS_MODULE,
-- 
1.5.2.2

