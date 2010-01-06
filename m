Return-Path: <linux-kernel-owner+w=401wt.eu-S932972Ab0AFWJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab0AFWJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932820Ab0AFWJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:09:54 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:40881 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab0AFWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:09:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       reiserfs-devel@vger.kernel.org
Subject: [PATCH 1/1] FS: reiserfs, fix unreachable statement
Date: Wed,  6 Jan 2010 23:09:50 +0100
Message-Id: <1262815790-5864-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found an unreachable statement in reiserfs_ioctl. There is
if followed by assignment and `break'. with no braces. Add the
braces so that we don't break every time, but only in error case.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: reiserfs-devel@vger.kernel.org
---
 fs/reiserfs/ioctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index ace7745..f53505d 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -104,9 +104,10 @@ setflags_out:
 		err = put_user(inode->i_generation, (int __user *)arg);
 		break;
 	case REISERFS_IOC_SETVERSION:
-		if (!is_owner_or_cap(inode))
+		if (!is_owner_or_cap(inode)) {
 			err = -EPERM;
 			break;
+		}
 		err = mnt_want_write(filp->f_path.mnt);
 		if (err)
 			break;
-- 
1.6.5.7

