Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbXEEUVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbXEEUVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933409AbXEEUVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:21:47 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:48977 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320AbXEEUVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:21:45 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 3/3] [PATCH] fix unionfs compilation
Date: Sat,  5 May 2007 16:18:25 -0400
Message-Id: <1178396305843-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.1043.g4342
In-Reply-To: <11783963052286-git-send-email-jsipek@cs.sunysb.edu>
References: <11783963052286-git-send-email-jsipek@cs.sunysb.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>

On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc7-mm2:
>...
>  git-unionfs.patch
>...
>  git trees
>...

<--  snip  -->

...
  CC      fs/unionfs/super.o
/home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/unionfs/super.c: In function ‘init_once’:
/home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/unionfs/super.c:822: error: ‘SLAB_CTOR_VERIFY’ undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/unionfs/super.c:822: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/unionfs/super.c:822: error: for each function it appears in.)
make[3]: *** [fs/unionfs/super.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 02c0cc8..af5a1c5 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -821,8 +821,7 @@ static void init_once(void *v, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct unionfs_inode_info *i = v;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&i->vfs_inode);
 }
 
-- 
1.5.0.3.1043.g4342

