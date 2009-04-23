Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbZDWTMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbZDWTMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758363AbZDWTMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:12:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:23378 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZDWTMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=C99N3dIyiopa4AJrAxlWPfatbbsO/b0Za5Bte07c8D+E4I3fNPVrmnBWqrXz/Bmlg0
         0O4Wl4pgQyIqCTKl58FJji8NM7EEMLoUaIRDyLz9Rpzo6rmg2oY/mgsBAMx1cpvpp0d2
         Ib03JxBuGsPNDRlGt4cZUR9qPEqPY+S9UotXo=
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 1/5 -tip] 9p: umount_begin BKL pushdown
Date: Thu, 23 Apr 2009 21:12:01 +0200
Message-Id: <1240513925-5603-2-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1240513925-5603-1-git-send-email-abogani@texware.it>
References: <1240513925-5603-1-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/9p/vfs_super.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 5f8ab8a..2f64462 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -37,6 +37,7 @@
 #include <linux/mount.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
@@ -232,7 +233,9 @@ v9fs_umount_begin(struct super_block *sb)
 {
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
 
+	lock_kernel();
 	v9fs_session_cancel(v9ses);
+	unlock_kernel();
 }
 
 static const struct super_operations v9fs_super_ops = {
-- 
1.6.0.4

