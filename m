Return-Path: <linux-kernel-owner+w=401wt.eu-S1765171AbZAQVrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765171AbZAQVrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761366AbZAQVrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:47:06 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44644 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761192AbZAQVrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:47:03 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 17 Jan 2009 22:46:59 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/4] firewire: core: clean up includes
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ca8b7763ca31e24d@s5r6.in-berlin.de>
Message-ID: <tkrat.475e07779a983890@s5r6.in-berlin.de>
References: <tkrat.ca8b7763ca31e24d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |   20 +++++++++++---------
 drivers/firewire/fw-device.h |   13 +++++++++++--
 2 files changed, 22 insertions(+), 11 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -18,24 +18,26 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#include <linux/module.h>
-#include <linux/wait.h>
-#include <linux/errno.h>
-#include <linux/kthread.h>
-#include <linux/device.h>
+#include <linux/ctype.h>
 #include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/errno.h>
 #include <linux/idr.h>
 #include <linux/jiffies.h>
-#include <linux/string.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/semaphore.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/workqueue.h>
+
 #include <asm/system.h>
-#include <linux/ctype.h>
-#include "fw-transaction.h"
-#include "fw-topology.h"
+
 #include "fw-device.h"
+#include "fw-topology.h"
+#include "fw-transaction.h"
 
 void fw_csr_iterator_init(struct fw_csr_iterator *ci, u32 * p)
 {
Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -19,11 +19,17 @@
 #ifndef __fw_device_h
 #define __fw_device_h
 
+#include <linux/device.h>
 #include <linux/fs.h>
-#include <linux/cdev.h>
 #include <linux/idr.h>
-#include <linux/rwsem.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
 #include <asm/atomic.h>
 
 enum fw_device_state {
@@ -39,6 +45,9 @@ struct fw_attribute_group {
 	struct attribute *attrs[11];
 };
 
+struct fw_node;
+struct fw_card;
+
 /*
  * Note, fw_device.generation always has to be read before fw_device.node_id.
  * Use SMP memory barriers to ensure this.  Otherwise requests will be sent

-- 
Stefan Richter
-=====-==--= ---= =---=
http://arcgraph.de/sr/

