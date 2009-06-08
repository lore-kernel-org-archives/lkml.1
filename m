Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZFHTe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZFHTe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZFHTYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:24:04 -0400
Received: from thunk.org ([69.25.196.29]:39639 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZFHTXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 12/49] ext4: Remove outdated comment about lock_super()
Date: Mon,  8 Jun 2009 15:22:30 -0400
Message-Id: <1244488987-32564-13-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-12-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
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
index fcd7b24..e3b35f2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2828,14 +2828,6 @@ no_journal:
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
1.6.3.2.1.gb9f7d.dirty

