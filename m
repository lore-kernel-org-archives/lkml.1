Return-Path: <linux-kernel-owner+w=401wt.eu-S933211AbXEERAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbXEERAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933580AbXEERAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:00:14 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38926 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933211AbXEERAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:00:12 -0400
Date: Sat, 5 May 2007 19:00:12 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, jsipek@cs.sunysb.edu,
       Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: [-mm patch] fix unionfs compilation
Message-ID: <20070505170012.GF8975@stusta.de>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

---
--- linux-2.6.21-mm1/fs/unionfs/super.c.old	2007-05-05 18:45:25.000000000 +0200
+++ linux-2.6.21-mm1/fs/unionfs/super.c	2007-05-05 18:46:03.000000000 +0200
@@ -819,8 +819,7 @@
 {
 	struct unionfs_inode_info *i = v;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&i->vfs_inode);
 }
 

