Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab0BKVc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:32:56 -0500
Received: from smtp.microsoft.com ([131.107.115.214]:21612 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab0BKVcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:32:55 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
       "'gregkh@suse.de'" <gregkh@suse.de>
Subject: [PATCH 1/2] Staging: hv: Add proper versioning to HV drivers
Thread-Topic: [PATCH 1/2] Staging: hv: Add proper versioning to HV drivers
Thread-Index: AQHKq2HENZ6t0wcb1kW/75fbKuFcgw==
Date: Thu, 11 Feb 2010 21:32:29 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56212E88287@TK5EX14MBXC118.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provide proper versioning information for all HV drivers.


Cc: Greg Kroah-Hartman         <gregkh@suse.de>
Signed-off-by: Hank Janssen    <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang   <haiyang@microsoft.com>


 drivers/staging/hv/VersionInfo.h |   11 ++++++++---
 drivers/staging/hv/Vmbus.c       |    8 ++++----
 drivers/staging/hv/blkvsc_drv.c  |    2 ++
 drivers/staging/hv/netvsc_drv.c  |    5 +++--
 drivers/staging/hv/storvsc_drv.c |    2 ++
 drivers/staging/hv/vmbus_drv.c   |    2 ++
 6 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/VersionInfo.h b/drivers/staging/hv/VersionInfo.h
index 9c3641d..e729b9e 100644
--- a/drivers/staging/hv/VersionInfo.h
+++ b/drivers/staging/hv/VersionInfo.h
@@ -24,8 +24,13 @@
 #ifndef __HV_VERSION_INFO
 #define __HV_VERSION_INFO
 
-static const char VersionDate[] = __DATE__;
-static const char VersionTime[] = __TIME__;
-static const char VersionDesc[] = "Version 2.0";
+static const char hv_build_date[] = __DATE__;
+static const char hv_build_time[] = __TIME__;
+
+/*
+ * We use the same version numbering for all Hyper-V modules.
+ */
+#define HV_DRV_VERSION           "3.0.0"
+
 
 #endif
diff --git a/drivers/staging/hv/Vmbus.c b/drivers/staging/hv/Vmbus.c
index 35a023e..20bc1cd 100644
--- a/drivers/staging/hv/Vmbus.c
+++ b/drivers/staging/hv/Vmbus.c
@@ -273,10 +273,10 @@ int VmbusInitialize(struct hv_driver *drv)
 
 	DPRINT_ENTER(VMBUS);
 
-	DPRINT_INFO(VMBUS, "+++++++ Build Date=%s %s +++++++",
-			VersionDate, VersionTime);
-	DPRINT_INFO(VMBUS, "+++++++ Build Description=%s +++++++",
-			VersionDesc);
+	DPRINT_INFO(VMBUS, "+++++++ Build Date = %s-%s +++++++",
+			hv_build_date, hv_build_time);
+	DPRINT_INFO(VMBUS, "+++++++ HV Driver version = %s +++++++",
+		    HV_DRV_VERSION);
 	DPRINT_INFO(VMBUS, "+++++++ Vmbus supported version = %d +++++++",
 			VMBUS_REVISION_NUMBER);
 	DPRINT_INFO(VMBUS, "+++++++ Vmbus using SINT %d +++++++",
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 62b2828..635692d 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -31,6 +31,7 @@
 #include <scsi/scsi_dbg.h>
 #include "osd.h"
 #include "logging.h"
+#include "VersionInfo.h"
 #include "vmbus.h"
 #include "StorVscApi.h"
 
@@ -1507,6 +1508,7 @@ static void __exit blkvsc_exit(void)
 }
 
 MODULE_LICENSE("GPL");
+MODULE_VERSION(HV_DRV_VERSION);
 module_param(blkvsc_ringbuffer_size, int, S_IRUGO);
 module_init(blkvsc_init);
 module_exit(blkvsc_exit);
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 3234a7c..0a78067 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -35,11 +35,10 @@
 #include <net/pkt_sched.h>
 #include "osd.h"
 #include "logging.h"
+#include "VersionInfo.h"
 #include "vmbus.h"
 #include "NetVscApi.h"
 
-MODULE_LICENSE("GPL");
-
 struct net_device_context {
 	/* point back to our device context */
 	struct device_context *device_ctx;
@@ -603,6 +602,8 @@ static void __exit netvsc_exit(void)
 	DPRINT_EXIT(NETVSC_DRV);
 }
 
+MODULE_LICENSE("GPL");
+MODULE_VERSION(HV_DRV_VERSION);
 module_param(netvsc_ringbuffer_size, int, S_IRUGO);
 
 module_init(netvsc_init);
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 12f8f3f..a10fa0e 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -32,6 +32,7 @@
 #include <scsi/scsi_dbg.h>
 #include "osd.h"
 #include "logging.h"
+#include "VersionInfo.h"
 #include "vmbus.h"
 #include "StorVscApi.h"
 
@@ -990,6 +991,7 @@ static void __exit storvsc_exit(void)
 }
 
 MODULE_LICENSE("GPL");
+MODULE_VERSION(HV_DRV_VERSION);
 module_param(storvsc_ringbuffer_size, int, S_IRUGO);
 module_init(storvsc_init);
 module_exit(storvsc_exit);
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 894eecf..92d70cd 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -24,6 +24,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/sysctl.h>
+#include "VersionInfo.h"
 #include "osd.h"
 #include "logging.h"
 #include "vmbus.h"
@@ -974,6 +975,7 @@ static void __exit vmbus_exit(void)
 }
 
 MODULE_LICENSE("GPL");
+MODULE_VERSION(HV_DRV_VERSION);
 module_param(vmbus_irq, int, S_IRUGO);
 module_param(vmbus_loglevel, int, S_IRUGO);

