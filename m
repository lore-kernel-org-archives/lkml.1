Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404Ab0ACCzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab0ACCzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 21:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657Ab0ACCzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 21:55:50 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34391 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0ACCzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 21:55:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LN6SZMkOtlPgSOcCIeWf3NigqKNwqcQMvnmF8s5gg+hErXC4pzwNpwrl9DFKjsM5Np
         jtsWPWg0MsvrC8wNOHDakjgJZ6bwaz9d97+gHQnISrz9O5h7W70udJk9nxQTtvyld2ld
         os+lyDJGvO22kBbaah3ZKn0Rju86vXBGG01+4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] reiserfs: Fix mistake in down_write() conversion
Date: Sun,  3 Jan 2010 03:55:47 +0100
Message-Id: <1262487347-7346-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a mistake in commit 0719d3434747889b314a1e8add776418c4148bcf
(reiserfs: Fix reiserfs lock <-> i_xattr_sem dependency inversion)
that has converted a down_write() into a down_read() accidentally.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 9623cfe..75d3706 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -495,7 +495,7 @@ reiserfs_xattr_set_handle(struct reiserfs_transaction_handle *th,
 		return PTR_ERR(dentry);
 	}
 
-	down_read(&REISERFS_I(inode)->i_xattr_sem);
+	down_write(&REISERFS_I(inode)->i_xattr_sem);
 
 	reiserfs_write_lock(inode->i_sb);
 
-- 
1.6.2.3

