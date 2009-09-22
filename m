Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZIVFnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZIVFnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbZIVFni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:43:38 -0400
Received: from dcent.unixwiz.net ([99.25.142.34]:56958 "EHLO dcent.unixwiz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867AbZIVFnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:43:37 -0400
Date: Mon, 21 Sep 2009 22:43:41 -0700
From: Steve Friedl <steve@unixwiz.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] staging: hv: Don't need a return; before a function's closing curly
Message-ID: <20090922054341.GA6026@dcent.unixwiz.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've always thought it's poor style to include a return; just before
the closing curly brace of a function, and I removed the dozen-ish
in this project.

~~~ Steve

Signed-off-by: Steve Friedl <steve@unixwiz.net>

---
 drivers/staging/hv/Connection.c  |    2 --
 drivers/staging/hv/NetVsc.c      |    1 -
 drivers/staging/hv/RndisFilter.c |    1 -
 drivers/staging/hv/StorVsc.c     |    1 -
 drivers/staging/hv/blkvsc_drv.c  |    2 --
 drivers/staging/hv/netvsc_drv.c  |    2 --
 drivers/staging/hv/storvsc_drv.c |    4 +---
 drivers/staging/hv/vmbus_drv.c   |    7 -------
 8 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/hv/Connection.c b/drivers/staging/hv/Connection.c
index 0496952..e249266 100644
--- a/drivers/staging/hv/Connection.c
+++ b/drivers/staging/hv/Connection.c
@@ -303,8 +303,6 @@ void VmbusOnEvents(void)
 		 }
 	}
 	DPRINT_EXIT(VMBUS);
-
-	return;
 }
 
 /**
diff --git a/drivers/staging/hv/NetVsc.c b/drivers/staging/hv/NetVsc.c
index ee94c03..fbceb05 100644
--- a/drivers/staging/hv/NetVsc.c
+++ b/drivers/staging/hv/NetVsc.c
@@ -1375,5 +1375,4 @@ void NetVscOnChannelCallback(void *Context)
 
 	PutNetDevice(device);
 	DPRINT_EXIT(NETVSC);
-	return;
 }
diff --git a/drivers/staging/hv/RndisFilter.c b/drivers/staging/hv/RndisFilter.c
index 17a6d65..05f3a54 100644
--- a/drivers/staging/hv/RndisFilter.c
+++ b/drivers/staging/hv/RndisFilter.c
@@ -742,7 +742,6 @@ Cleanup:
 	if (request)
 		PutRndisRequest(Device, request);
 	DPRINT_EXIT(NETVSC);
-	return;
 }
 
 static int RndisFilterOpenDevice(struct rndis_device *Device)
diff --git a/drivers/staging/hv/StorVsc.c b/drivers/staging/hv/StorVsc.c
index b8d5c23..6c5b2de 100644
--- a/drivers/staging/hv/StorVsc.c
+++ b/drivers/staging/hv/StorVsc.c
@@ -498,7 +498,6 @@ static void StorVscOnChannelCallback(void *context)
 	PutStorDevice(device);
 
 	DPRINT_EXIT(STORVSC);
-	return;
 }
 
 static int StorVscConnectToVsp(struct hv_device *Device)
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index e8f5ea4..8537456 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -238,8 +238,6 @@ static void blkvsc_drv_exit(void)
 	vmbus_child_driver_unregister(drv_ctx);
 
 	DPRINT_EXIT(BLKVSC_DRV);
-
-	return;
 }
 
 /**
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 774afbe..f90f303 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -555,8 +555,6 @@ static void netvsc_drv_exit(void)
 	vmbus_child_driver_unregister(drv_ctx);
 
 	DPRINT_EXIT(NETVSC_DRV);
-
-	return;
 }
 
 static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 55c4b35..ba787d1 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -224,8 +224,6 @@ static void storvsc_drv_exit(void)
 	vmbus_child_driver_unregister(drv_ctx);
 
 	DPRINT_EXIT(STORVSC_DRV);
-
-	return;
 }
 
 /**
@@ -1181,7 +1179,7 @@ static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
 	DPRINT_INFO(STORVSC_DRV, "CHS (%d, %d, %d)", cylinders, heads,
 		    sectors_per_track);
 
-    return 0;
+	return 0;
 }
 
 static int __init storvsc_init(void)
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 78d4b63..b1d5449 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -390,8 +390,6 @@ static void vmbus_bus_exit(void)
 	tasklet_kill(&vmbus_drv_ctx->event_dpc);
 
 	DPRINT_EXIT(VMBUS_DRV);
-
-	return;
 }
 
 /**
@@ -866,8 +864,6 @@ static void vmbus_shutdown(struct device *child_device)
 		driver_ctx->shutdown(child_device);
 
 	DPRINT_EXIT(VMBUS_DRV);
-
-	return;
 }
 
 /**
@@ -898,8 +894,6 @@ static void vmbus_device_release(struct device *device)
 
 	/* !!DO NOT REFERENCE device_ctx anymore at this point!! */
 	DPRINT_EXIT(VMBUS_DRV);
-
-	return;
 }
 
 /**
@@ -988,7 +982,6 @@ static void __exit vmbus_exit(void)
 	vmbus_bus_exit();
 	/* Todo: it is used for loglevel, to be ported to new kernel. */
 	DPRINT_EXIT(VMBUS_DRV);
-	return;
 }
 
 MODULE_LICENSE("GPL");
-- 
1.6.5.rc1
