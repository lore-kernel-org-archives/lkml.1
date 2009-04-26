Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZDZDuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZDZDuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 23:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbZDZDte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 23:49:34 -0400
Received: from THUNK.ORG ([69.25.196.29]:60017 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbZDZDtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 23:49:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 2/5] ext4: Remove outdated comment about lock_super()
Date: Sat, 25 Apr 2009 23:49:22 -0400
Message-Id: <1240717765-16572-3-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1240717765-16572-2-git-send-email-tytso@mit.edu>
References: <1240717765-16572-1-git-send-email-tytso@mit.edu>
 <1240717765-16572-2-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext4_fill_super() is no longer called by read_super(), and it is no
longer called with the superblock locked.  The
unlock_super()/lock_super() is no longer present, so this comment is
entirely superfluous.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e20ff9c..e0b0c9f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2806,14 +2806,6 @@ no_journal:
 		goto failed_mount4;
 	};
 
-	/*
-	 * akpm: core read_super() calls in here with the superblock locked.
-	 * That deadlocks, because orphan cleanup needs to lock the superblock
-	 * in numerous places.  Here we just pop the lock - it's relatively
-	 * harmless, because we are now ready to accept write_super() requests,
-	 * and aviro says that's the only reason for hanging onto the
-	 * superblock lock.
-	 */
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
 	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
-- 
1.5.6.3

