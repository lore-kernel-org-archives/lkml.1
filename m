Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZEUUBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZEUUBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZEUUBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:01:13 -0400
Received: from thunk.org ([69.25.196.29]:39201 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002AbZEUUBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:01:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 1/5] fs: i_flags and i_state in struct inode only need to be unsigned short
Date: Thu, 21 May 2009 16:00:59 -0400
Message-Id: <1242936063-31689-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.1.1.g75fc.dirty
In-Reply-To: <1242936063-31689-1-git-send-email-tytso@mit.edu>
References: <1242936063-31689-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently i_flags and i_state do not need to be an unsigned int and an
unsigned long, respectively.  (We currently use 9 i_flags bits, and 8
i_state bits.)  Changing them to be an unsigned short saves 4 bytes
per inode on an x86 platform, and 8 bytes on an x86_64 platform.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org
---
 include/linux/fs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b534e5..9b20f13 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -765,10 +765,10 @@ struct inode {
 	struct mutex		inotify_mutex;	/* protects the watches list */
 #endif
 
-	unsigned long		i_state;
 	unsigned long		dirtied_when;	/* jiffies of first dirtying */
 
-	unsigned int		i_flags;
+	unsigned short		i_state;
+	unsigned short		i_flags;
 
 	atomic_t		i_writecount;
 #ifdef CONFIG_SECURITY
-- 
1.6.3.1.1.g75fc.dirty

