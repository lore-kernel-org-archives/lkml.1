Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0CKG1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 01:27:05 -0500
Received: from mga03.intel.com ([143.182.124.21]:22933 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab0CKG0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 01:26:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,618,1262592000"; 
   d="scan'208";a="253371500"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>
Cc: Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH][v8 3/7] xen: Make pv drivers only work with xen_pv_domain()
Date: Thu, 11 Mar 2010 14:28:10 +0800
Message-Id: <1268288894-30591-4-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268288894-30591-1-git-send-email-sheng@linux.intel.com>
References: <1268288894-30591-1-git-send-email-sheng@linux.intel.com>
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
index 05a31e5..32e28bd 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1068,7 +1068,7 @@ static struct xenbus_driver blkfront = {
 
 static int __init xlblk_init(void)
 {
-	if (!xen_domain())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	if (register_blkdev(XENVBD_MAJOR, DEV_NAME)) {
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index c721c0a..0c3f4ca 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -338,7 +338,7 @@ static struct xenbus_driver xenkbd_driver = {
 
 static int __init xenkbd_init(void)
 {
-	if (!xen_domain())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	/* Nothing to do if running in dom0. */
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index a869b45..e3ae126 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1804,7 +1804,7 @@ static struct xenbus_driver netfront_driver = {
 
 static int __init netif_init(void)
 {
-	if (!xen_domain())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	if (xen_initial_domain())
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 603598f..3360470 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -683,7 +683,7 @@ static struct xenbus_driver xenfb_driver = {
 
 static int __init xenfb_init(void)
 {
-	if (!xen_domain())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	/* Nothing to do if running in dom0. */
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 4c6c0bd..ade7f3d 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -510,7 +510,7 @@ static int __devinit gnttab_init(void)
 	unsigned int max_nr_glist_frames, nr_glist_frames;
 	unsigned int nr_init_grefs;
 
-	if (!xen_domain())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	nr_grant_frames = 1;
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 2f7aaa9..a5712cd 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -786,7 +786,7 @@ static int __init xenbus_probe_init(void)
 	DPRINTK("");
 
 	err = -ENODEV;
-	if (!xen_domain())
+	if (!xen_pv_domain())
 		goto out_error;
 
 	/* Register ourselves with the kernel bus subsystem */
@@ -922,7 +922,7 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
 	struct device_driver *drv = xendrv ? &xendrv->driver : NULL;
 	unsigned int seconds_waited = 0;
 
-	if (!ready_to_wait_for_devices || !xen_domain())
+	if (!ready_to_wait_for_devices || !xen_pv_domain())
 		return;
 
 	while (exists_connecting_device(drv)) {
-- 
1.7.0.1

