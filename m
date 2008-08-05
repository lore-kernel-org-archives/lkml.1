Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYHEOVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYHEOVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbYHEOVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:21:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:51741 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754520AbYHEOVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:21:45 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] quota: Documentation for sending "below quota" messages via netlink and tiny doc update
Date: Tue,  5 Aug 2008 16:21:43 +0200
Message-Id: <1217946103446-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/filesystems/quota.txt |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/quota.txt b/Documentation/filesystems/quota.txt
index a590c40..5e8de25 100644
--- a/Documentation/filesystems/quota.txt
+++ b/Documentation/filesystems/quota.txt
@@ -3,14 +3,14 @@ Quota subsystem
 ===============
 
 Quota subsystem allows system administrator to set limits on used space and
-number of used inodes (inode is a filesystem structure which is associated
-with each file or directory) for users and/or groups. For both used space and
-number of used inodes there are actually two limits. The first one is called
-softlimit and the second one hardlimit.  An user can never exceed a hardlimit
-for any resource. User is allowed to exceed softlimit but only for limited
-period of time. This period is called "grace period" or "grace time". When
-grace time is over, user is not able to allocate more space/inodes until he
-frees enough of them to get below softlimit.
+number of used inodes (inode is a filesystem structure which is associated with
+each file or directory) for users and/or groups. For both used space and number
+of used inodes there are actually two limits. The first one is called softlimit
+and the second one hardlimit.  An user can never exceed a hardlimit for any
+resource (unless he has CAP_SYS_RESOURCE capability). User is allowed to exceed
+softlimit but only for limited period of time. This period is called "grace
+period" or "grace time". When grace time is over, user is not able to allocate
+more space/inodes until he frees enough of them to get below softlimit.
 
 Quota limits (and amount of grace time) are set independently for each
 filesystem.
@@ -53,6 +53,12 @@ in parentheses):
 		QUOTA_NL_BSOFTLONGWARN - space (block) softlimit is exceeded
 		  longer than given grace period.
 		QUOTA_NL_BSOFTWARN - space (block) softlimit
+	  - four warnings are also defined for the event when user stops
+	    exceeding some limit:
+		QUOTA_NL_IHARDBELOW - inode hardlimit
+		QUOTA_NL_ISOFTBELOW - inode softlimit
+		QUOTA_NL_BHARDBELOW - space (block) hardlimit
+		QUOTA_NL_BSOFTBELOW - space (block) softlimit
         QUOTA_NL_A_DEV_MAJOR (u32)
 	  - major number of a device with the affected filesystem
         QUOTA_NL_A_DEV_MINOR (u32)
-- 
1.5.2.4

