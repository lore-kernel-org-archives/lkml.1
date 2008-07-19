Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYGSKSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYGSKSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYGSKSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:18:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbYGSKSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:18:14 -0400
Message-ID: <4881BEF4.2020201@cn.fujitsu.com>
Date: Sat, 19 Jul 2008 18:16:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] vfs: use kstrdup()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This piece of code can be replaced by a kstrdup().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/namespace.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 4f6f763..08c3b2d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -127,14 +127,7 @@ struct vfsmount *alloc_vfsmnt(const char *name)
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
 		atomic_set(&mnt->__mnt_writers, 0);
-		if (name) {
-			int size = strlen(name) + 1;
-			char *newname = kmalloc(size, GFP_KERNEL);
-			if (newname) {
-				memcpy(newname, name, size);
-				mnt->mnt_devname = newname;
-			}
-		}
+		mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
 	}
 	return mnt;
 }
-- 
1.5.4.rc3


