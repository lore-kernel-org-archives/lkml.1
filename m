Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbXI3XFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbXI3XFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbXI3XFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:05:13 -0400
Received: from 70-56-134-241.albq.qwest.net ([70.56.134.241]:57197 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752854AbXI3XFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:05:11 -0400
Date: Sun, 30 Sep 2007 16:43:29 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ericvh@gmail.com
Subject: [RFC][PATCH 6/6] 9p: 9P server Kconfig and Makefile changes
Message-ID: <20070930224329.GF25590@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides support for in-kernel 9P2000 servers.

9P server Kconfig and Makefile changes.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
---
 net/9p/Kconfig      |    1 +
 net/9p/Makefile     |    1 +
 net/9p/srv/Kconfig  |    9 +++++++++
 net/9p/srv/Makefile |    7 +++++++
 4 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 net/9p/srv/Kconfig
 create mode 100644 net/9p/srv/Makefile

diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index eecbf12..007ce2b 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -29,3 +29,4 @@ config NET_9P_DEBUG
 	help
 	  Say Y if you want the 9P subsistem to log debug information.
 
+source "net/9p/srv/Kconfig"
diff --git a/net/9p/Makefile b/net/9p/Makefile
index 5059bc0..be4d93e 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_NET_9P) := 9pnet.o
 obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
+obj-$(CONFIG_NET_9P_SRV) += srv/
 
 9pnet-objs := \
 	mod.o \
diff --git a/net/9p/srv/Kconfig b/net/9p/srv/Kconfig
new file mode 100644
index 0000000..2013945
--- /dev/null
+++ b/net/9p/srv/Kconfig
@@ -0,0 +1,9 @@
+#
+# 9P server configuration
+#
+
+config NET_9P_SRV
+	tristate "9P server support"
+	depends on NET_9P
+	help
+	  Say Y if you want the 9P server support
diff --git a/net/9p/srv/Makefile b/net/9p/srv/Makefile
new file mode 100644
index 0000000..c669592
--- /dev/null
+++ b/net/9p/srv/Makefile
@@ -0,0 +1,7 @@
+obj-$(CONFIG_NET_9P_SRV) += 9psrv.o
+
+9psrv-objs := \
+	srv.o \
+	conn.o \
+	fid.o \
+	socksrv.o \
-- 
1.5.2.4


