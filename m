Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0CLC5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 21:57:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:56432 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab0CLCz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 21:55:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,624,1262592000"; 
   d="scan'208";a="780148478"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH][v9 3/6] xen: Make pv drivers only work with xen_pv_domain()
Date: Fri, 12 Mar 2010 10:57:24 +0800
Message-Id: <1268362647-5317-4-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268362647-5317-1-git-send-email-sheng@linux.intel.com>
References: <1268362647-5317-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise they would still try to enable with HVM domain type.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 drivers/block/xen-blkfront.c      |    2 +-
 drivers/input/xen-kbdfront.c      |    2 +-
 drivers/net/xen-netfront.c        |    2 +-
 drivers/video/xen-fbfront.c       |    2 +-
 drivers/xen/grant-table.c         |    2 +-
 drivers/xen/xenbus/xenbus_probe.c |    4 ++--
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index b8578bb..f2f4d4e 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1067,7 +1067,7 @@ static struct xenbus_driver blkfront = {
 
 static int __init xlblk_init(void)
 {
-	if (!xen_domain())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	if (register_blkdev(XENVBD_MAJOR, DEV_NAME)) {
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index b115726..8ec2201 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -335,7 +335,7 @@ static struct xenbus_driver xenkbd_driver = {
 
 static int __init xenkbd_init(void)
 {
-	if (!xen_domain())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	/* Nothing to do if running in dom0. */
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index baa051d..6132286 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1803,7 +1803,7 @@ static struct xenbus_driver netfront_driver = {
 
 static int __init netif_init(void)
 {
-	if (!xen_domain())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	if (xen_initial_domain())
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 54cd916..450f958 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -680,7 +680,7 @@ static struct xenbus_driver xenfb_driver = {
 
 static int __init xenfb_init(void)
 {
-	if (!xen_domain())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	/* Nothing to do if running in dom0. */
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 7d8f531..f6d9b8c 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -509,7 +509,7 @@ static int __devinit gnttab_init(void)
 	unsigned int max_nr_glist_frames, nr_glist_frames;
 	unsigned int nr_init_grefs;
 
-	if (!xen_domain())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	nr_grant_frames = 1;
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index d42e25d..bce893e 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -784,7 +784,7 @@ static int __init xenbus_probe_init(void)
 	DPRINTK("");
 
 	err = -ENODEV;
-	if (!xen_domain())
+	if (!xen_pv_domain())
 		goto out_error;
 
 	/* Register ourselves with the kernel bus subsystem */
@@ -915,7 +915,7 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
 	unsigned long timeout = jiffies + 10*HZ;
 	struct device_driver *drv = xendrv ? &xendrv->driver : NULL;
 
-	if (!ready_to_wait_for_devices || !xen_domain())
+	if (!ready_to_wait_for_devices || !xen_pv_domain())
 		return;
 
 	while (exists_disconnected_device(drv)) {
-- 
1.7.0.1

