Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbZG2MOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbZG2MOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZG2MOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:14:40 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45482 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbZG2MOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:14:39 -0400
From: Nicolas Palix <npalix@diku.dk>
To: gregkh@suse.de, hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Staging: hv: Remove typedef DRIVER_OBJECT and PDRIVER_OBJECT
Date: Wed, 29 Jul 2009 14:09:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907291409.46342.npalix@diku.dk>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


typedef DRIVER_OBJECT and PDRIVER_OBJECT are removed and their usages
are replace by the use of struct hv_driver and struct hv_driver *
respectively.

Here is the semantic patch generated to perform this transformation:
(http://coccinelle.lip6.fr/)

//<smpl>
@rm_DRIVER_OBJECT@
@@
-typedef struct _DRIVER_OBJECT
+struct hv_driver
{...}
-DRIVER_OBJECT
;

@rm_PDRIVER_OBJECT@
@@
-typedef struct _DRIVER_OBJECT *PDRIVER_OBJECT;
+struct hv_driver;

@fixtypedef_DRIVER_OBJECT@
typedef DRIVER_OBJECT;
@@
-DRIVER_OBJECT
+struct hv_driver

@fixstruct__DRIVER_OBJECT@
@@
struct
-_DRIVER_OBJECT
+hv_driver

@fixtypedef_PDRIVER_OBJECT@
typedef PDRIVER_OBJECT;
@@
-PDRIVER_OBJECT
+struct hv_driver*
//</smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
---
 drivers/staging/hv/BlkVsc.c             |    2 +-
 drivers/staging/hv/NetVsc.c             |    6 +++---
 drivers/staging/hv/RndisFilter.c        |    4 ++--
 drivers/staging/hv/StorVsc.c            |    6 +++---
 drivers/staging/hv/Vmbus.c              |   20 ++++++++++----------
 drivers/staging/hv/include/NetVscApi.h  |    4 ++--
 drivers/staging/hv/include/StorVscApi.h |    6 +++---
 drivers/staging/hv/include/VmbusApi.h   |   26 ++++++++++----------------
 drivers/staging/hv/include/vmbus.h      |    4 ++--
 drivers/staging/hv/vmbus_drv.c          |    2 +-
 10 files changed, 37 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/hv/BlkVsc.c b/drivers/staging/hv/BlkVsc.c
index 059b134..d2bde5d 100644
--- a/drivers/staging/hv/BlkVsc.c
+++ b/drivers/staging/hv/BlkVsc.c
@@ -41,7 +41,7 @@ BlkVscOnDeviceAdd(
 
 int
 BlkVscInitialize(
-	DRIVER_OBJECT *Driver
+	struct hv_driver *Driver
 	)
 {
 	STORVSC_DRIVER_OBJECT* storDriver = (STORVSC_DRIVER_OBJECT*)Driver;
diff --git a/drivers/staging/hv/NetVsc.c b/drivers/staging/hv/NetVsc.c
index e2a75ce..d653f95 100644
--- a/drivers/staging/hv/NetVsc.c
+++ b/drivers/staging/hv/NetVsc.c
@@ -51,7 +51,7 @@ NetVscOnDeviceRemove(
 
 static void
 NetVscOnCleanup(
-	DRIVER_OBJECT *Driver
+	struct hv_driver *Driver
 	);
 
 static void
@@ -231,7 +231,7 @@ Description:
 --*/
 int
 NetVscInitialize(
-	DRIVER_OBJECT *drv
+	struct hv_driver *drv
 	)
 {
 	NETVSC_DRIVER_OBJECT* driver = (NETVSC_DRIVER_OBJECT*)drv;
@@ -983,7 +983,7 @@ Description:
 --*/
 void
 NetVscOnCleanup(
-	DRIVER_OBJECT *drv
+	struct hv_driver *drv
 	)
 {
 	DPRINT_ENTER(NETVSC);
diff --git a/drivers/staging/hv/RndisFilter.c b/drivers/staging/hv/RndisFilter.c
index ddeede1..96133a4 100644
--- a/drivers/staging/hv/RndisFilter.c
+++ b/drivers/staging/hv/RndisFilter.c
@@ -168,7 +168,7 @@ RndisFilterOnDeviceRemove(
 
 static void
 RndisFilterOnCleanup(
-	DRIVER_OBJECT *Driver
+	struct hv_driver *Driver
 	);
 
 static int
@@ -1032,7 +1032,7 @@ RndisFilterOnDeviceRemove(
 
 static void
 RndisFilterOnCleanup(
-	DRIVER_OBJECT *Driver
+	struct hv_driver *Driver
 	)
 {
 	DPRINT_ENTER(NETVSC);
diff --git a/drivers/staging/hv/StorVsc.c b/drivers/staging/hv/StorVsc.c
index 4a406f0..bc313a6 100644
--- a/drivers/staging/hv/StorVsc.c
+++ b/drivers/staging/hv/StorVsc.c
@@ -118,7 +118,7 @@ StorVscOnHostReset(
 
 static void
 StorVscOnCleanup(
-	DRIVER_OBJECT	*Device
+	struct hv_driver *Device
 	);
 
 static void
@@ -263,7 +263,7 @@ Description:
 --*/
 int
 StorVscInitialize(
-	DRIVER_OBJECT *Driver
+	struct hv_driver *Driver
 	)
 {
 	STORVSC_DRIVER_OBJECT* storDriver = (STORVSC_DRIVER_OBJECT*)Driver;
@@ -807,7 +807,7 @@ Description:
 --*/
 void
 StorVscOnCleanup(
-	DRIVER_OBJECT *Driver
+	struct hv_driver *Driver
 	)
 {
 	DPRINT_ENTER(STORVSC);
diff --git a/drivers/staging/hv/Vmbus.c b/drivers/staging/hv/Vmbus.c
index f6be5b5..60f9afc 100644
--- a/drivers/staging/hv/Vmbus.c
+++ b/drivers/staging/hv/Vmbus.c
@@ -45,7 +45,7 @@ static const GUID gVmbusDeviceId={
 	.Data = {0xfc, 0x60, 0x37, 0xac, 0xdf, 0x9a, 0xaa, 0x40, 0x94, 0x27, 0xa7, 0x0e, 0xd6, 0xde, 0x95, 0xc5}
 };
 
-static DRIVER_OBJECT* gDriver; /* vmbus driver object */
+static struct hv_driver *gDriver; /* vmbus driver object */
 static struct hv_device* gDevice; /* vmbus root device */
 
 
@@ -82,22 +82,22 @@ VmbusOnDeviceRemove(
 
 static void
 VmbusOnCleanup(
-	DRIVER_OBJECT* drv
+	struct hv_driver *drv
 	);
 
 static int
 VmbusOnISR(
-	DRIVER_OBJECT* drv
+	struct hv_driver *drv
 	);
 
 static void
 VmbusOnMsgDPC(
-	DRIVER_OBJECT* drv
+	struct hv_driver *drv
 	);
 
 static void
 VmbusOnEventDPC(
-	DRIVER_OBJECT* drv
+	struct hv_driver *drv
 	);
 
 /*++;
@@ -111,7 +111,7 @@ Description:
 --*/
 int
 VmbusInitialize(
-	DRIVER_OBJECT* drv
+	struct hv_driver *drv
 	)
 {
 	VMBUS_DRIVER_OBJECT* driver = (VMBUS_DRIVER_OBJECT*)drv;
@@ -377,7 +377,7 @@ Description:
 --*/
 void
 VmbusOnCleanup(
-	DRIVER_OBJECT* drv
+	struct hv_driver *drv
 	)
 {
 	/* VMBUS_DRIVER_OBJECT* driver = (VMBUS_DRIVER_OBJECT*)drv; */
@@ -401,7 +401,7 @@ Description:
 --*/
 void
 VmbusOnMsgDPC(
-	DRIVER_OBJECT* drv
+	struct hv_driver *drv
 	)
 {
 	void *page_addr = gHvContext.synICMessagePage[0];
@@ -460,7 +460,7 @@ Description:
 --*/
 void
 VmbusOnEventDPC(
-	DRIVER_OBJECT* drv
+	struct hv_driver* drv
 	)
 {
 	/* TODO: Process any events */
@@ -479,7 +479,7 @@ Description:
 --*/
 int
 VmbusOnISR(
-	DRIVER_OBJECT* drv
+	struct hv_driver *drv
 	)
 {
 	/* VMBUS_DRIVER_OBJECT* driver = (VMBUS_DRIVER_OBJECT*)drv; */
diff --git a/drivers/staging/hv/include/NetVscApi.h b/drivers/staging/hv/include/NetVscApi.h
index 56ae23a..83e746d 100644
--- a/drivers/staging/hv/include/NetVscApi.h
+++ b/drivers/staging/hv/include/NetVscApi.h
@@ -109,7 +109,7 @@ typedef struct _NETVSC_PACKET {
 
 /* Represents the net vsc driver */
 typedef struct _NETVSC_DRIVER_OBJECT {
-	DRIVER_OBJECT				Base; /* Must be the first field */
+	struct hv_driver Base; /* Must be the first field */
 
 	u32						RingBufferSize;
 	u32						RequestExtSize;
@@ -147,7 +147,7 @@ typedef struct _NETVSC_DEVICE_INFO {
 
 int
 NetVscInitialize(
-	DRIVER_OBJECT* drv
+	struct hv_driver *drv
 	);
 
 #endif /* _NETVSC_API_H_ */
diff --git a/drivers/staging/hv/include/StorVscApi.h b/drivers/staging/hv/include/StorVscApi.h
index bd09409..f6c9742 100644
--- a/drivers/staging/hv/include/StorVscApi.h
+++ b/drivers/staging/hv/include/StorVscApi.h
@@ -98,7 +98,7 @@ typedef struct _STORVSC_REQUEST {
 
 /* Represents the block vsc driver */
 typedef struct _STORVSC_DRIVER_OBJECT {
-	DRIVER_OBJECT			Base; /* Must be the first field */
+	struct hv_driver Base; /* Must be the first field */
 
 	/* Set by caller (in bytes) */
 	u32					RingBufferSize;
@@ -129,11 +129,11 @@ typedef struct _STORVSC_DEVICE_INFO {
 
 int
 StorVscInitialize(
-	DRIVER_OBJECT	*Driver
+	struct hv_driver *Driver
 	);
 
 int
 BlkVscInitialize(
-	DRIVER_OBJECT	*Driver
+	struct hv_driver *Driver
 	);
 #endif /* _STORVSC_API_H_ */
diff --git a/drivers/staging/hv/include/VmbusApi.h b/drivers/staging/hv/include/VmbusApi.h
index c09f589..0a87085 100644
--- a/drivers/staging/hv/include/VmbusApi.h
+++ b/drivers/staging/hv/include/VmbusApi.h
@@ -34,13 +34,6 @@
 #define MAX_PAGE_BUFFER_COUNT				16
 #define MAX_MULTIPAGE_BUFFER_COUNT			32 /* 128K */
 
-
-
-/* Fwd declarations */
-
-typedef struct _DRIVER_OBJECT *PDRIVER_OBJECT;
-
-
 /* Data types */
 
 
@@ -68,19 +61,20 @@ typedef struct _MULTIPAGE_BUFFER {
 
 #pragma pack(pop)
 
+struct hv_driver;
 struct hv_device;
 
 /* All drivers */
 typedef int (*PFN_ON_DEVICEADD)(struct hv_device *Device, void* AdditionalInfo);
 typedef int (*PFN_ON_DEVICEREMOVE)(struct hv_device *Device);
 typedef char** (*PFN_ON_GETDEVICEIDS)(void);
-typedef void (*PFN_ON_CLEANUP)(PDRIVER_OBJECT Driver);
+typedef void (*PFN_ON_CLEANUP)(struct hv_driver *Driver);
 
 /* Vmbus extensions */
-/* typedef int (*PFN_ON_MATCH)(struct hv_device *dev, PDRIVER_OBJECT drv); */
+/* typedef int (*PFN_ON_MATCH)(struct hv_device *dev, struct hv_driver *drv); */
 /* typedef int (*PFN_ON_PROBE)(struct hv_device *dev); */
-typedef int	(*PFN_ON_ISR)(PDRIVER_OBJECT drv);
-typedef void (*PFN_ON_DPC)(PDRIVER_OBJECT drv);
+typedef int	(*PFN_ON_ISR)(struct hv_driver *drv);
+typedef void (*PFN_ON_DPC)(struct hv_driver *drv);
 typedef void (*PFN_GET_CHANNEL_OFFERS)(void);
 
 typedef struct hv_device *(*PFN_ON_CHILDDEVICE_CREATE)(GUID DeviceType, GUID DeviceInstance, void *Context);
@@ -205,7 +199,7 @@ typedef struct _VMBUS_CHANNEL_INTERFACE {
 typedef void (*VMBUS_GET_CHANNEL_INTERFACE)(VMBUS_CHANNEL_INTERFACE *Interface);
 
 /* Base driver object */
-typedef struct _DRIVER_OBJECT {
+struct hv_driver {
 	const char*				name;
 	GUID					deviceType; /* the device type supported by this driver */
 
@@ -215,12 +209,12 @@ typedef struct _DRIVER_OBJECT {
 	PFN_ON_CLEANUP			OnCleanup;
 
 	VMBUS_CHANNEL_INTERFACE VmbusChannelInterface;
-} DRIVER_OBJECT;
+};
 
 
 /* Base device object */
 struct hv_device {
-	DRIVER_OBJECT*		Driver;		/* the driver for this device */
+	struct hv_driver *Driver;		/* the driver for this device */
 	char				name[64];
 	GUID				deviceType; /* the device type id of this device */
 	GUID				deviceInstance; /* the device instance id of this device */
@@ -231,7 +225,7 @@ struct hv_device {
 
 /* Vmbus driver object */
 typedef struct _VMBUS_DRIVER_OBJECT {
-	DRIVER_OBJECT		Base; /* !! Must be the 1st field !! */
+	struct hv_driver Base; /* !! Must be the 1st field !! */
 
 	/* Set by the caller */
 	PFN_ON_CHILDDEVICE_CREATE	OnChildDeviceCreate;
@@ -257,7 +251,7 @@ typedef struct _VMBUS_DRIVER_OBJECT {
 
 int
 VmbusInitialize(
-	DRIVER_OBJECT* drv
+	struct hv_driver *drv
 	);
 
 #endif /* _VMBUS_API_H_ */
diff --git a/drivers/staging/hv/include/vmbus.h b/drivers/staging/hv/include/vmbus.h
index b99c4b5..6f7eecb 100644
--- a/drivers/staging/hv/include/vmbus.h
+++ b/drivers/staging/hv/include/vmbus.h
@@ -33,8 +33,8 @@
 /* Data types */
 
 
-typedef int (*PFN_DRIVERINITIALIZE)(DRIVER_OBJECT *drv);
-typedef int (*PFN_DRIVEREXIT)(DRIVER_OBJECT *drv);
+typedef int (*PFN_DRIVERINITIALIZE)(struct hv_driver *drv);
+typedef int (*PFN_DRIVEREXIT)(struct hv_driver *drv);
 
 struct driver_context {
 	GUID					class_id;
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 32ae68c..699baf5 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -765,7 +765,7 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 	if (memcmp(&device_ctx->class_id, &driver_ctx->class_id, sizeof(GUID)) == 0)
 	{
 		/* !! NOTE: The driver_ctx is not a vmbus_drv_ctx. We typecast it here to access the */
-		/* DRIVER_OBJECT field */
+		/* struct hv_driver field */
 		struct vmbus_driver_context *vmbus_drv_ctx = (struct vmbus_driver_context*)driver_ctx;
 		device_ctx->device_obj.Driver = &vmbus_drv_ctx->drv_obj.Base;
 		DPRINT_INFO(VMBUS_DRV, "device object (%p) set to driver object (%p)", &device_ctx->device_obj, device_ctx->device_obj.Driver);
-- 
1.6.0.4

	
-- 
Nicolas Palix
