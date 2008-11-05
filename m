Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbYKEQbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbYKEQbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYKEQbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:31:04 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:57839 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbYKEQbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:31:00 -0500
Date: Wed, 5 Nov 2008 19:30:58 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [resend take 1] [3/3] Distributed storage release: Makefile and Kconfig
Message-ID: <20081105163058.GC11096@ioremap.net>
References: <20081105162704.GA10787@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105162704.GA10787@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 61ad8d6..2a92cd8 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -445,4 +445,6 @@ config BLK_DEV_HD
 
 	  If unsure, say N.
 
+source "drivers/block/dst/Kconfig"
+
 endif # BLK_DEV
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 204332b..6400de0 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -32,3 +32,5 @@ obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
 obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
 
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
+
+obj-$(CONFIG_DST)	+= dst/
diff --git a/drivers/block/dst/Kconfig b/drivers/block/dst/Kconfig
new file mode 100644
index 0000000..507dba8
--- /dev/null
+++ b/drivers/block/dst/Kconfig
@@ -0,0 +1,14 @@
+config DST
+	tristate "Distributed storage"
+	depends on NET && CRYPTO && SYSFS
+	select CONNECTOR
+	select LIBCRC32C
+	---help---
+	This driver allows to create a distributed storage block device.
+
+config DST_DEBUG
+	bool "DST debug"
+	depends on DST
+	---help---
+	This option will turn HEAVY debugging of the DST.
+	Turn it on ONLY if you have to debug some really obscure problem.
diff --git a/drivers/block/dst/Makefile b/drivers/block/dst/Makefile
new file mode 100644
index 0000000..3a8b0cf
--- /dev/null
+++ b/drivers/block/dst/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_DST) += nst.o
+
+nst-y := dcore.o state.o export.o thread_pool.o crypto.o trans.o

-- 
	Evgeniy Polyakov
