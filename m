Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYA3HKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYA3HKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbYA3HKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:10:05 -0500
Received: from swsoft-msk-nat.sw.ru ([195.214.232.10]:53950 "EHLO iris.sw.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753582AbYA3HKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:10:03 -0500
X-Greylist: delayed 1795 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2008 02:10:03 EST
From: "Denis V. Lunev" <den@openvz.org>
To: greg@kroah.com, davem@davemloft.net
Cc: randy.dunlap@oracle.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH] Debugfs compile fix.
Date: Wed, 30 Jan 2008 09:40:00 +0300
Message-Id: <1201675200-9310-1-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugfs is not compiled without CONFIG_SYSFS in net-2.6 tree. Move
kobject_create_and_add under appropriate ifdef. The fix looks correct
from a first glance, but may be the dependency should be added into
the Kconfig.

Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 fs/debugfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index d26e282..61cc937 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -432,9 +432,11 @@ static int __init debugfs_init(void)
 {
 	int retval;
 
+#ifdef CONFIG_SYSFS
 	debug_kobj = kobject_create_and_add("debug", kernel_kobj);
 	if (!debug_kobj)
 		return -EINVAL;
+#endif
 
 	retval = register_filesystem(&debug_fs_type);
 	if (retval)
-- 
1.5.3.rc5

