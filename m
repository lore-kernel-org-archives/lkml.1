Return-Path: <linux-kernel-owner+w=401wt.eu-S1765485AbXHPHqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765485AbXHPHqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757824AbXHPHpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:45:52 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:38419 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbXHPHpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:45:47 -0400
X-Greylist: delayed 17019 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 03:45:47 EDT
Message-Id: <200708160300.AA00236@paprika.lab.ntt.co.jp>
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Thu, 16 Aug 2007 12:00:42 +0900
To: trond.myklebust@fys.uio.no
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       moriai.satoshi@lab.ntt.co.jp
Subject: [PATCH] NFS: fix /proc/sys oops after module removal
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NFS client made without CONFIG_NFS_V4 option does not call
nfs_unregister_sysctl() when the module is unloaded, and
causes kernel oopses.  For instance, the oopses will occur
when accessing /proc/sys.

This fixes the problem.

Note that register_nfs_fs() requires no change in this regard.
It looks similar at the first glance, but written properly.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index b2a851c..e784310 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -345,8 +345,8 @@ void __exit unregister_nfs_fs(void)
 	unregister_shrinker(&acl_shrinker);
 #ifdef CONFIG_NFS_V4
 	unregister_filesystem(&nfs4_fs_type);
-	nfs_unregister_sysctl();
 #endif
+	nfs_unregister_sysctl();
 	unregister_filesystem(&nfs_fs_type);
 }
 
