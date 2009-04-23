Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbZDWTNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbZDWTNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758991AbZDWTMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:12:24 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61329 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758909AbZDWTMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=pQfuZbGC05EHvIiKXZD8hKXRGRkxe2wnF99NeDuYTwq6H48V6lwE16svw80tNqUcwp
         Gx034hG/ELo8OLaVdGoiBeFV/8jIGHnk1PCb9kFFgO5ol+Ou4DSRs04uDJUrpQKWPQIq
         KyGp4bLmLktVIt7zgSletejwNOzpoNQRym/Ug=
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 5/5 -tip] vfs: Don-t call umount_begin with BKL held
Date: Thu, 23 Apr 2009 21:12:05 +0200
Message-Id: <1240513925-5603-6-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1240513925-5603-5-git-send-email-abogani@texware.it>
References: <1240513925-5603-1-git-send-email-abogani@texware.it>
 <1240513925-5603-2-git-send-email-abogani@texware.it>
 <1240513925-5603-3-git-send-email-abogani@texware.it>
 <1240513925-5603-4-git-send-email-abogani@texware.it>
 <1240513925-5603-5-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every filesystem should acquire BKL or provide an adeguate locking
mechanism.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/namespace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c6f54e4..f046f4b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1073,9 +1073,7 @@ static int do_umount(struct vfsmount *mnt, int flags)
 	 */
 
 	if (flags & MNT_FORCE && sb->s_op->umount_begin) {
-		lock_kernel();
 		sb->s_op->umount_begin(sb);
-		unlock_kernel();
 	}
 
 	/*
-- 
1.6.0.4

