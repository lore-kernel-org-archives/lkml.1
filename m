Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbYHCWP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbYHCWP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 18:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760008AbYHCWPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 18:15:30 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:9073 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760002AbYHCWP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 18:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vtqq37y4vz2AGBmXkZB6l/xfbZ+yGJ/izqRwDvvMdkQMivDLmXryQ5lMEAPw08gdsj
         Q9WDb6IXkzEvlVcdmAe5jUrVMHhcg06FRWabUEz3z/vjT78lFwhufBNIaqGni+5T/j6F
         J5jWnFbKZJbBiw+rvefgnHIQInChrvMnz+Pjw=
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, Li Zefan <lizf@cn.fujitsu.com>,
       Carl Henrik Lunde <chlunde@ping.uio.no>, axboe@kernel.dk,
       matt@bluehost.com, roberto@unbit.it,
       Marco Innocenti <m.innocenti@cineca.it>, randy.dunlap@oracle.com,
       Divyesh Shah <dpshah@google.com>, subrata@linux.vnet.ibm.com,
       eric.rannaud@gmail.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH -mm 2/3] i/o controller infrastructure
Date: Mon,  4 Aug 2008 00:14:57 +0200
Message-Id: <1217801698-13438-3-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the core io-throttle kernel infrastructure. It creates the basic
interfaces to cgroups and implements the I/O measurement and throttling
functions.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 block/Makefile                |    2 ++
 include/linux/cgroup_subsys.h |    6 ++++++
 init/Kconfig                  |   10 ++++++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/block/Makefile b/block/Makefile
index 208000b..b3afc86 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -13,6 +13,8 @@ obj-$(CONFIG_IOSCHED_AS)	+= as-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
+obj-$(CONFIG_CGROUP_IO_THROTTLE)	+= blk-io-throttle.o
+
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 23c02e2..198ee52 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -52,3 +52,9 @@ SUBSYS(memrlimit_cgroup)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+SUBSYS(iothrottle)
+#endif
+
+/* */
diff --git a/init/Kconfig b/init/Kconfig
index a451916..39691c2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -306,6 +306,16 @@ config CGROUP_DEVICE
 	  Provides a cgroup implementing whitelists for devices which
 	  a process in the cgroup can mknod or open.
 
+config CGROUP_IO_THROTTLE
+	bool "Enable cgroup I/O throttling (EXPERIMENTAL)"
+	depends on CGROUPS && EXPERIMENTAL
+	help
+	  This allows to limit the maximum I/O bandwidth for specific
+	  cgroup(s).
+	  See Documentation/controllers/io-throttle.txt for more information.
+
+	  If unsure, say N.
+
 config CPUSETS
 	bool "Cpuset support"
 	depends on SMP && CGROUPS
-- 
1.5.4.3

