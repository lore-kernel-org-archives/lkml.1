Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbYB1Gr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbYB1Gr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbYB1Gpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:45:49 -0500
Received: from host106.paramount.wayport.net ([65.249.24.106]:52724 "EHLO
	honeydew.int.wil.cx" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755219AbYB1Gpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:44 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 04/12] net: Remove unnecessary inclusions of asm/semaphore.h
Date: Thu, 28 Feb 2008 01:33:53 -0500
Message-Id: <1204180441-8540-4-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204180441-8540-3-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
 <1204180441-8540-1-git-send-email-matthew@wil.cx>
 <1204180441-8540-2-git-send-email-matthew@wil.cx>
 <1204180441-8540-3-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files use any of the functionality promised by
asm/semaphore.h.  It's possible that they rely on it dragging in some
unrelated header file, but I can't build all these files, so we'll have
fix any build failures as they come up.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/net/cxgb3/adapter.h                    |    1 -
 drivers/net/cxgb3/t3cdev.h                     |    1 -
 drivers/net/ibmveth.c                          |    1 -
 drivers/net/netxen/netxen_nic_hdr.h            |    1 -
 drivers/net/usb/kaweth.c                       |    1 -
 drivers/net/wireless/bcm43xx/bcm43xx_debugfs.h |    1 -
 net/core/flow.c                                |    1 -
 net/dccp/proto.c                               |    1 -
 net/ipv4/ipcomp.c                              |    1 -
 net/ipv6/ipcomp6.c                             |    1 -
 10 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/cxgb3/adapter.h b/drivers/net/cxgb3/adapter.h
index eb305a0..4fdb13f 100644
--- a/drivers/net/cxgb3/adapter.h
+++ b/drivers/net/cxgb3/adapter.h
@@ -43,7 +43,6 @@
 #include <linux/mutex.h>
 #include <linux/bitops.h>
 #include "t3cdev.h"
-#include <asm/semaphore.h>
 #include <asm/io.h>
 
 struct vlan_group;
diff --git a/drivers/net/cxgb3/t3cdev.h b/drivers/net/cxgb3/t3cdev.h
index 77fcc1a..a18c8a1 100644
--- a/drivers/net/cxgb3/t3cdev.h
+++ b/drivers/net/cxgb3/t3cdev.h
@@ -34,7 +34,6 @@
 
 #include <linux/list.h>
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 #include <linux/netdevice.h>
 #include <linux/proc_fs.h>
 #include <linux/skbuff.h>
diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index 57772be..e2d7b66 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -49,7 +49,6 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <net/net_namespace.h>
-#include <asm/semaphore.h>
 #include <asm/hvcall.h>
 #include <asm/atomic.h>
 #include <asm/vio.h>
diff --git a/drivers/net/netxen/netxen_nic_hdr.h b/drivers/net/netxen/netxen_nic_hdr.h
index d72f8f8..5bc3cbf 100644
--- a/drivers/net/netxen/netxen_nic_hdr.h
+++ b/drivers/net/netxen/netxen_nic_hdr.h
@@ -34,7 +34,6 @@
 #include <linux/kernel.h>
 #include <linux/version.h>
 
-#include <asm/semaphore.h>
 #include <linux/spinlock.h>
 #include <asm/irq.h>
 #include <linux/init.h>
diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index 569ad8b..0dcfc03 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -58,7 +58,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/wait.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 #include <asm/byteorder.h>
 
 #undef DEBUG
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.h b/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.h
index a40d1af..b46f43d 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.h
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.h
@@ -7,7 +7,6 @@ struct bcm43xx_xmitstatus;
 #ifdef CONFIG_BCM43XX_DEBUG
 
 #include <linux/list.h>
-#include <asm/semaphore.h>
 
 struct dentry;
 
diff --git a/net/core/flow.c b/net/core/flow.c
index a77531c..1999117 100644
--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -23,7 +23,6 @@
 #include <linux/mutex.h>
 #include <net/flow.h>
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 #include <linux/security.h>
 
 struct flow_cache_entry {
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index e3f5d37..c12af3d 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -27,7 +27,6 @@
 #include <net/xfrm.h>
 
 #include <asm/ioctls.h>
-#include <asm/semaphore.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/delay.h>
diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index ae1f45f..fc9de7c 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -14,7 +14,6 @@
  *   - Adaptive compression.
  */
 #include <linux/module.h>
-#include <asm/semaphore.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/pfkeyv2.h>
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index b900395..eebc218 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -34,7 +34,6 @@
 #include <net/ip.h>
 #include <net/xfrm.h>
 #include <net/ipcomp.h>
-#include <asm/semaphore.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/pfkeyv2.h>
-- 
1.5.4.1

