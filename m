Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZEUUB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZEUUB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbZEUUBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:01:15 -0400
Received: from thunk.org ([69.25.196.29]:39197 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbZEUUBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:01:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       sfr@canb.auug.org.au
Subject: [PATCH 3/5] fs: Slim down inode by only using an unsigned int for i_dnotify_mask
Date: Thu, 21 May 2009 16:01:01 -0400
Message-Id: <1242936063-31689-4-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.1.1.g75fc.dirty
In-Reply-To: <1242936063-31689-3-git-send-email-tytso@mit.edu>
References: <1242936063-31689-1-git-send-email-tytso@mit.edu>
 <1242936063-31689-2-git-send-email-tytso@mit.edu>
 <1242936063-31689-3-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dnotify mask values range from 0x0001 through 0x0020, as well as
0x80000000 (for DN_MULTISHOT).  There is no need for this field to be
an unsigned long (which is 8 bytes on 64-bit systems).  Using an
unsigned int will save 4 bytes for the inode structure on 64-bit
systems.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: sfr@canb.auug.org.au
Cc: linux-fsdevel@vger.kernel.org
---
 include/linux/dnotify.h |    2 +-
 include/linux/fs.h      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dnotify.h b/include/linux/dnotify.h
index 102a902..d573542 100644
--- a/include/linux/dnotify.h
+++ b/include/linux/dnotify.h
@@ -10,7 +10,7 @@
 
 struct dnotify_struct {
 	struct dnotify_struct *	dn_next;
-	unsigned long		dn_mask;
+	unsigned int		dn_mask;
 	int			dn_fd;
 	struct file *		dn_filp;
 	fl_owner_t		dn_owner;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e3b8334..7c73c59 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -755,7 +755,7 @@ struct inode {
 	__u32			i_generation;
 
 #ifdef CONFIG_DNOTIFY
-	unsigned long		i_dnotify_mask; /* Directory notify events */
+	unsigned int		i_dnotify_mask; /* Directory notify events */
 	struct dnotify_struct	*i_dnotify; /* for directory notifications */
 #endif
 
-- 
1.6.3.1.1.g75fc.dirty

