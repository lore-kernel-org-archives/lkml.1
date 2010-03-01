Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab0CAPSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:18:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab0CAPR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:17:57 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/5] GFS2: Remove old, unused linked list code from quota
Date: Mon,  1 Mar 2010 15:08:24 +0000
Message-Id: <1267456106-3084-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1267456106-3084-3-git-send-email-swhiteho@redhat.com>
References: <1267456106-3084-1-git-send-email-swhiteho@redhat.com>
 <1267456106-3084-2-git-send-email-swhiteho@redhat.com>
 <1267456106-3084-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

This is the kernel portion of the patch-set for upstream gfs2,
to remove the quota-linked-list stuff and replace it with
fiemap-based traversal of the quota file.

The corresponding userland fixes have been pushed to
STABLE3 and master branches of cluster.git and gfs2-utils.git
respectively (Refer Red Hat bug #536902).

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 include/linux/gfs2_ondisk.h |   30 +-----------------------------
 1 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index 81f90a5..4f44629 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -180,33 +180,6 @@ struct gfs2_rgrp {
 };
 
 /*
- * quota linked list: user quotas and group quotas form two separate 
- * singly linked lists. ll_next stores uids or gids of next quotas in the 
- * linked list.
-
-Given the uid/gid, how to calculate the quota file offsets for the corresponding
-gfs2_quota structures on disk:
-
-for user quotas, given uid,
-offset = uid * sizeof(struct gfs2_quota);
-
-for group quotas, given gid,
-offset = (gid * sizeof(struct gfs2_quota)) + sizeof(struct gfs2_quota);
-
-
-  uid:0   gid:0       uid:12   gid:12      uid:17   gid:17     uid:5142 gid:5142
-+-------+-------+    +-------+-------+    +-------+- - - -+    +- - - -+-------+
-| valid | valid | :: | valid | valid | :: | valid | inval | :: | inval | valid |
-+-------+-------+    +-------+-------+    +-------+- - - -+    +- - - -+-------+
-next:12   next:12    next:17 next:5142    next:NULL                    next:NULL
-    |       |            |       |            |<-- user quota list         |
-     \______|___________/ \______|___________/         group quota list -->|
-            |                    |                                         |
-             \__________________/ \_______________________________________/
-
-*/
-
-/*
  * quota structure
  */
 
@@ -214,8 +187,7 @@ struct gfs2_quota {
 	__be64 qu_limit;
 	__be64 qu_warn;
 	__be64 qu_value;
-	__be32 qu_ll_next; /* location of next quota in list */
-	__u8 qu_reserved[60];
+	__u8 qu_reserved[64];
 };
 
 /*
-- 
1.6.2.5

