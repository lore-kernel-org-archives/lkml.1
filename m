Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbYAQWqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbYAQWqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYAQWhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:37:07 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:10991 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759922AbYAQWgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:52 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>
Subject: [PATCH 14/30] ocfs2: Add missing permission checks
Date: Thu, 17 Jan 2008 14:35:40 -0800
Message-Id: <1200609356-17788-15-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check that an online resize is being driven by a user with permission to
change system resource limits.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/ioctl.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 7003d58..5177fba 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -144,12 +144,18 @@ int ocfs2_ioctl(struct inode * inode, struct file * filp,
 
 		return ocfs2_change_file_space(filp, cmd, &sr);
 	case OCFS2_IOC_GROUP_EXTEND:
+		if (!capable(CAP_SYS_RESOURCE))
+			return -EPERM;
+
 		if (get_user(new_clusters, (int __user *)arg))
 			return -EFAULT;
 
 		return ocfs2_group_extend(inode, new_clusters);
 	case OCFS2_IOC_GROUP_ADD:
 	case OCFS2_IOC_GROUP_ADD64:
+		if (!capable(CAP_SYS_RESOURCE))
+			return -EPERM;
+
 		if (copy_from_user(&input, (int __user *) arg, sizeof(input)))
 			return -EFAULT;
 
-- 
1.5.3.6

