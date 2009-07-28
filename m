Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbZG1Ie7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbZG1Ie7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 04:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZG1Ie7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 04:34:59 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:46423 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZG1Iey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 04:34:54 -0400
From: Nicolas Palix <npalix@diku.dk>
To: gregkh@suse.de, hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: hv: Transform PDEVICE_OBJECT and DEVICE_OBJECT typedefs into their corresponding structs
Date: Tue, 28 Jul 2009 10:30:44 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907281030.45317.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove typedef DEVICE_OBJECT and use a struct with the same name
instead. The new struct name uses lower case (struct device_object).

Remove typedef PDEVICE_OBJECT which aliases a pointer and use the
corresponding renamed struct pointer (struct device_object *).

Here is the semantic patch generated to perform this transformation:
(http://www.emn.fr/x-info/coccinelle/)

//<smpl>
@rm_PDEVICE_OBJECT@
@@
-typedef struct _DEVICE_OBJECT *PDEVICE_OBJECT;

@rm_DEVICE_OBJECT@
@@
-typedef struct _DEVICE_OBJECT
+struct device_object
{...}
-DEVICE_OBJECT
;

@fixtypedef_PDEVICE_OBJECT@
typedef PDEVICE_OBJECT;
@@
-PDEVICE_OBJECT
+struct device_object*

@fixtypedef_DEVICE_OBJECT@
typedef DEVICE_OBJECT;
@@
-DEVICE_OBJECT
+struct device_object

@fixstruct__DEVICE_OBJECT@
@@
struct
-_DEVICE_OBJECT
+device_object
//</smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
---
 drivers/staging/hv/BlkVsc.c             |    4 +-
 drivers/staging/hv/ChannelInterface.c   |   20 ++++++------
 drivers/staging/hv/ChannelInterface.h   |    2 +-
 drivers/staging/hv/ChannelMgmt.h        |    2 +-
 drivers/staging/hv/NetVsc.c             |   52 +++++++++++++++---------------
 drivers/staging/hv/NetVsc.h             |    2 +-
 drivers/staging/hv/RndisFilter.c        |   24 +++++++-------
 drivers/staging/hv/StorVsc.c            |   50 +++++++++++++++---------------
 drivers/staging/hv/Vmbus.c              |   22 ++++++------
 drivers/staging/hv/VmbusPrivate.h       |    8 ++--
 drivers/staging/hv/blkvsc_drv.c         |    4 +-
 drivers/staging/hv/include/NetVscApi.h  |   14 ++++----
 drivers/staging/hv/include/StorVscApi.h |    6 ++--
 drivers/staging/hv/include/VmbusApi.h   |   41 ++++++++++++------------
 drivers/staging/hv/include/vmbus.h      |    4 +-
 drivers/staging/hv/netvsc_drv.c         |   16 +++++-----
 drivers/staging/hv/storvsc_drv.c        |   10 +++---
 drivers/staging/hv/vmbus_drv.c          |   22 ++++++------
 18 files changed, 151 insertions(+), 152 deletions(-)

diff --git a/drivers/staging/hv/BlkVsc.c b/drivers/staging/hv/BlkVsc.c
index dc91aae..1ab2fe9 100644
--- a/drivers/staging/hv/BlkVsc.c
+++ b/drivers/staging/hv/BlkVsc.c
@@ -34,7 +34,7 @@ static const GUID gBlkVscDeviceType={
 // Static routines
 static int
 BlkVscOnDeviceAdd(
-	DEVICE_OBJECT	*Device,
+	struct device_object	*Device,
 	void			*AdditionalInfo
 	);
 
@@ -77,7 +77,7 @@ BlkVscInitialize(
 
 int
 BlkVscOnDeviceAdd(
-	DEVICE_OBJECT	*Device,
+	struct device_object	*Device,
 	void			*AdditionalInfo
 	)
 {
diff --git a/drivers/staging/hv/ChannelInterface.c b/drivers/staging/hv/ChannelInterface.c
index d3b4c14..a7b57d8 100644
--- a/drivers/staging/hv/ChannelInterface.c
+++ b/drivers/staging/hv/ChannelInterface.c
@@ -25,7 +25,7 @@
 
 static int
 IVmbusChannelOpen(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	u32				SendBufferSize,
 	u32				RecvRingBufferSize,
 	void *				UserData,
@@ -46,7 +46,7 @@ IVmbusChannelOpen(
 
 static void
 IVmbusChannelClose(
-	PDEVICE_OBJECT		Device
+	struct device_object 		*Device
 	)
 {
 	VmbusChannelClose((VMBUS_CHANNEL*)Device->context);
@@ -55,7 +55,7 @@ IVmbusChannelClose(
 
 static int
 IVmbusChannelSendPacket(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	const void *			Buffer,
 	u32				BufferLen,
 	u64				RequestId,
@@ -73,7 +73,7 @@ IVmbusChannelSendPacket(
 
 static int
 IVmbusChannelSendPacketPageBuffer(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	PAGE_BUFFER			PageBuffers[],
 	u32				PageCount,
 	void *				Buffer,
@@ -91,7 +91,7 @@ IVmbusChannelSendPacketPageBuffer(
 
 static int
 IVmbusChannelSendPacketMultiPageBuffer(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	MULTIPAGE_BUFFER	*MultiPageBuffer,
 	void *				Buffer,
 	u32				BufferLen,
@@ -107,7 +107,7 @@ IVmbusChannelSendPacketMultiPageBuffer(
 
 static int
 IVmbusChannelRecvPacket (
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	void *				Buffer,
 	u32				BufferLen,
 	u32*				BufferActualLen,
@@ -123,7 +123,7 @@ IVmbusChannelRecvPacket (
 
 static int
 IVmbusChannelRecvPacketRaw(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	void *				Buffer,
 	u32				BufferLen,
 	u32*				BufferActualLen,
@@ -139,7 +139,7 @@ IVmbusChannelRecvPacketRaw(
 
 static int
 IVmbusChannelEstablishGpadl(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	void *				Buffer,
 	u32				BufferLen,
 	u32*				GpadlHandle
@@ -153,7 +153,7 @@ IVmbusChannelEstablishGpadl(
 
 static int
 IVmbusChannelTeardownGpadl(
-   PDEVICE_OBJECT		Device,
+   struct device_object 		*Device,
    u32				GpadlHandle
 	)
 {
@@ -182,7 +182,7 @@ GetChannelInterface(
 
 static void
 GetChannelInfo(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	DEVICE_INFO			*DeviceInfo
 			   )
 {
diff --git a/drivers/staging/hv/ChannelInterface.h b/drivers/staging/hv/ChannelInterface.h
index c459e0e..184cff5 100644
--- a/drivers/staging/hv/ChannelInterface.h
+++ b/drivers/staging/hv/ChannelInterface.h
@@ -34,7 +34,7 @@ GetChannelInterface(
 
 static void
 GetChannelInfo(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	DEVICE_INFO			*DeviceInfo
 	);
 
diff --git a/drivers/staging/hv/ChannelMgmt.h b/drivers/staging/hv/ChannelMgmt.h
index b7afeca..972f878 100644
--- a/drivers/staging/hv/ChannelMgmt.h
+++ b/drivers/staging/hv/ChannelMgmt.h
@@ -45,7 +45,7 @@ typedef enum {
 typedef struct _VMBUS_CHANNEL {
 	LIST_ENTRY					ListEntry;
 
-	DEVICE_OBJECT*				DeviceObject;
+	struct device_object				*DeviceObject;
 
 	HANDLE						PollTimer; // SA-111 workaround
 
diff --git a/drivers/staging/hv/NetVsc.c b/drivers/staging/hv/NetVsc.c
index b4b7010..6ae7b31 100644
--- a/drivers/staging/hv/NetVsc.c
+++ b/drivers/staging/hv/NetVsc.c
@@ -44,13 +44,13 @@ static const GUID gNetVscDeviceType={
 //
 static int
 NetVscOnDeviceAdd(
-	DEVICE_OBJECT	*Device,
+	struct device_object	*Device,
 	void			*AdditionalInfo
 	);
 
 static int
 NetVscOnDeviceRemove(
-	DEVICE_OBJECT *Device
+	struct device_object *Device
 	);
 
 static void
@@ -65,12 +65,12 @@ NetVscOnChannelCallback(
 
 static int
 NetVscInitializeSendBufferWithNetVsp(
-	DEVICE_OBJECT			*Device
+	struct device_object *Device
 	);
 
 static int
 NetVscInitializeReceiveBufferWithNetVsp(
-	DEVICE_OBJECT			*Device
+	struct device_object *Device
 	);
 
 static int
@@ -85,24 +85,24 @@ NetVscDestroyReceiveBuffer(
 
 static int
 NetVscConnectToVsp(
-	DEVICE_OBJECT		*Device
+	struct device_object *Device
 	);
 
 static void
 NetVscOnSendCompletion(
-	DEVICE_OBJECT		*Device,
+	struct device_object *Device,
 	VMPACKET_DESCRIPTOR *Packet
 	);
 
 static int
 NetVscOnSend(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	NETVSC_PACKET	*Packet
 	);
 
 static void
 NetVscOnReceive(
-	DEVICE_OBJECT		*Device,
+	struct device_object *Device,
 	VMPACKET_DESCRIPTOR *Packet
 	);
 
@@ -113,11 +113,11 @@ NetVscOnReceiveCompletion(
 
 static void
 NetVscSendReceiveCompletion(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	u64			TransactionId
 	);
 
-static inline NETVSC_DEVICE* AllocNetDevice(DEVICE_OBJECT *Device)
+static inline NETVSC_DEVICE* AllocNetDevice(struct device_object *Device)
 {
 	NETVSC_DEVICE *netDevice;
 
@@ -143,7 +143,7 @@ static inline void FreeNetDevice(NETVSC_DEVICE *Device)
 
 
 // Get the net device object iff exists and its refcount > 1
-static inline NETVSC_DEVICE* GetOutboundNetDevice(DEVICE_OBJECT	*Device)
+static inline NETVSC_DEVICE* GetOutboundNetDevice(struct device_object	*Device)
 {
 	NETVSC_DEVICE *netDevice;
 
@@ -161,7 +161,7 @@ static inline NETVSC_DEVICE* GetOutboundNetDevice(DEVICE_OBJECT	*Device)
 }
 
 // Get the net device object iff exists and its refcount > 0
-static inline NETVSC_DEVICE* GetInboundNetDevice(DEVICE_OBJECT	*Device)
+static inline NETVSC_DEVICE* GetInboundNetDevice(struct device_object	*Device)
 {
 	NETVSC_DEVICE *netDevice;
 
@@ -178,7 +178,7 @@ static inline NETVSC_DEVICE* GetInboundNetDevice(DEVICE_OBJECT	*Device)
 	return netDevice;
 }
 
-static inline void PutNetDevice(DEVICE_OBJECT *Device)
+static inline void PutNetDevice(struct device_object *Device)
 {
 	NETVSC_DEVICE *netDevice;
 
@@ -188,7 +188,7 @@ static inline void PutNetDevice(DEVICE_OBJECT *Device)
 	InterlockedDecrement(&netDevice->RefCount);
 }
 
-static inline NETVSC_DEVICE* ReleaseOutboundNetDevice(DEVICE_OBJECT *Device)
+static inline NETVSC_DEVICE* ReleaseOutboundNetDevice(struct device_object *Device)
 {
 	NETVSC_DEVICE *netDevice;
 
@@ -205,7 +205,7 @@ static inline NETVSC_DEVICE* ReleaseOutboundNetDevice(DEVICE_OBJECT *Device)
 	return netDevice;
 }
 
-static inline NETVSC_DEVICE* ReleaseInboundNetDevice(DEVICE_OBJECT *Device)
+static inline NETVSC_DEVICE* ReleaseInboundNetDevice(struct device_object *Device)
 {
 	NETVSC_DEVICE *netDevice;
 
@@ -272,7 +272,7 @@ NetVscInitialize(
 
 static int
 NetVscInitializeReceiveBufferWithNetVsp(
-	DEVICE_OBJECT	*Device
+	struct device_object *Device
 	)
 {
 	int ret=0;
@@ -399,7 +399,7 @@ Exit:
 
 static int
 NetVscInitializeSendBufferWithNetVsp(
-	DEVICE_OBJECT	*Device
+	struct device_object *Device
 	)
 {
 	int ret=0;
@@ -650,7 +650,7 @@ NetVscDestroySendBuffer(
 
 static int
 NetVscConnectToVsp(
-	DEVICE_OBJECT	*Device
+	struct device_object *Device
 	)
 {
 	int ret=0;
@@ -780,7 +780,7 @@ Description:
 --*/
 int
 NetVscOnDeviceAdd(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	void			*AdditionalInfo
 	)
 {
@@ -897,7 +897,7 @@ Description:
 --*/
 int
 NetVscOnDeviceRemove(
-	DEVICE_OBJECT *Device
+	struct device_object *Device
 	)
 {
 	NETVSC_DEVICE *netDevice;
@@ -979,7 +979,7 @@ NetVscOnCleanup(
 
 static void
 NetVscOnSendCompletion(
-	DEVICE_OBJECT		*Device,
+	struct device_object *Device,
 	VMPACKET_DESCRIPTOR *Packet
 	)
 {
@@ -1033,7 +1033,7 @@ NetVscOnSendCompletion(
 
 static int
 NetVscOnSend(
-	DEVICE_OBJECT *Device,
+	struct device_object *Device,
 	NETVSC_PACKET *Packet
 	)
 {
@@ -1097,7 +1097,7 @@ NetVscOnSend(
 
 static void
 NetVscOnReceive(
-	DEVICE_OBJECT		*Device,
+	struct device_object *Device,
 	VMPACKET_DESCRIPTOR *Packet
 	)
 {
@@ -1283,7 +1283,7 @@ NetVscOnReceive(
 
 static void
 NetVscSendReceiveCompletion(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	u64			TransactionId
 	)
 {
@@ -1339,7 +1339,7 @@ NetVscOnReceiveCompletion(
 	void * Context)
 {
 	NETVSC_PACKET *packet = (NETVSC_PACKET*)Context;
-	DEVICE_OBJECT *device = (DEVICE_OBJECT*)packet->Device;
+	struct device_object *device = (struct device_object*)packet->Device;
 	NETVSC_DEVICE* netDevice;
 	u64	transactionId=0;
 	bool fSendReceiveComp = false;
@@ -1398,7 +1398,7 @@ NetVscOnChannelCallback(
 {
 	const int netPacketSize=2048;
 	int ret=0;
-	DEVICE_OBJECT *device=(DEVICE_OBJECT*)Context;
+	struct device_object *device = (struct device_object*)Context;
 	NETVSC_DEVICE *netDevice;
 
 	u32 bytesRecvd;
diff --git a/drivers/staging/hv/NetVsc.h b/drivers/staging/hv/NetVsc.h
index d6b0d67..c30472a 100644
--- a/drivers/staging/hv/NetVsc.h
+++ b/drivers/staging/hv/NetVsc.h
@@ -55,7 +55,7 @@
 
 // Per netvsc channel-specific
 typedef struct _NETVSC_DEVICE {
-	DEVICE_OBJECT					*Device;
+	struct device_object *Device;
 
 	int								RefCount;
 
diff --git a/drivers/staging/hv/RndisFilter.c b/drivers/staging/hv/RndisFilter.c
index 714f23e..9597ab4 100644
--- a/drivers/staging/hv/RndisFilter.c
+++ b/drivers/staging/hv/RndisFilter.c
@@ -112,7 +112,7 @@ RndisFilterReceiveData(
 
 static int
 RndisFilterOnReceive(
-	DEVICE_OBJECT		*Device,
+	struct device_object *Device,
 	NETVSC_PACKET		*Packet
 	);
 
@@ -157,13 +157,13 @@ RndisFilterCloseDevice(
 
 static int
 RndisFilterOnDeviceAdd(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	void			*AdditionalInfo
 	);
 
 static int
 RndisFilterOnDeviceRemove(
-	DEVICE_OBJECT *Device
+	struct device_object *Device
 	);
 
 static void
@@ -173,17 +173,17 @@ RndisFilterOnCleanup(
 
 static int
 RndisFilterOnOpen(
-	DEVICE_OBJECT		*Device
+	struct device_object *Device
 	);
 
 static int
 RndisFilterOnClose(
-	DEVICE_OBJECT		*Device
+	struct device_object *Device
 	);
 
 static int
 RndisFilterOnSend(
-	DEVICE_OBJECT		*Device,
+	struct device_object *Device,
 	NETVSC_PACKET		*Packet
 	);
 
@@ -490,7 +490,7 @@ RndisFilterReceiveData(
 
 static int
 RndisFilterOnReceive(
-	DEVICE_OBJECT		*Device,
+	struct device_object *Device,
 	NETVSC_PACKET		*Packet
 	)
 {
@@ -928,7 +928,7 @@ RndisFilterCloseDevice(
 
 int
 RndisFilterOnDeviceAdd(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	void			*AdditionalInfo
 	)
 {
@@ -1007,7 +1007,7 @@ RndisFilterOnDeviceAdd(
 
 static int
 RndisFilterOnDeviceRemove(
-	DEVICE_OBJECT *Device
+	struct device_object *Device
 	)
 {
 	NETVSC_DEVICE *netDevice = (NETVSC_DEVICE*)Device->Extension;
@@ -1042,7 +1042,7 @@ RndisFilterOnCleanup(
 
 static int
 RndisFilterOnOpen(
-	DEVICE_OBJECT		*Device
+	struct device_object *Device
 	)
 {
 	int ret;
@@ -1060,7 +1060,7 @@ RndisFilterOnOpen(
 
 static int
 RndisFilterOnClose(
-	DEVICE_OBJECT		*Device
+	struct device_object *Device
 	)
 {
 	int ret;
@@ -1079,7 +1079,7 @@ RndisFilterOnClose(
 
 static int
 RndisFilterOnSend(
-	DEVICE_OBJECT		*Device,
+	struct device_object *Device,
 	NETVSC_PACKET		*Packet
 	)
 {
diff --git a/drivers/staging/hv/StorVsc.c b/drivers/staging/hv/StorVsc.c
index 439c447..842b6db 100644
--- a/drivers/staging/hv/StorVsc.c
+++ b/drivers/staging/hv/StorVsc.c
@@ -44,7 +44,7 @@ typedef struct _STORVSC_REQUEST_EXTENSION {
 	//LIST_ENTRY						ListEntry;
 
 	STORVSC_REQUEST					*Request;
-	DEVICE_OBJECT					*Device;
+	struct device_object				*Device;
 
 	// Synchronize the request/response if needed
 	HANDLE							WaitEvent;
@@ -55,7 +55,7 @@ typedef struct _STORVSC_REQUEST_EXTENSION {
 
 // A storvsc device is a device object that contains a vmbus channel
 typedef struct _STORVSC_DEVICE{
-	DEVICE_OBJECT				*Device;
+	struct device_object *Device;
 
 	int							RefCount; // 0 indicates the device is being destroyed
 
@@ -93,24 +93,24 @@ static const GUID gStorVscDeviceType={
 //
 static int
 StorVscOnDeviceAdd(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	void			*AdditionalInfo
 	);
 
 static int
 StorVscOnDeviceRemove(
-	DEVICE_OBJECT	*Device
+	struct device_object *Device
 	);
 
 static int
 StorVscOnIORequest(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	STORVSC_REQUEST	*Request
 	);
 
 static int
 StorVscOnHostReset(
-	DEVICE_OBJECT	*Device
+	struct device_object *Device
 	);
 
 static void
@@ -125,24 +125,24 @@ StorVscOnChannelCallback(
 
 static void
 StorVscOnIOCompletion(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	VSTOR_PACKET	*VStorPacket,
 	STORVSC_REQUEST_EXTENSION *RequestExt
 	);
 
 static void
 StorVscOnReceive(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	VSTOR_PACKET	*VStorPacket,
 	STORVSC_REQUEST_EXTENSION *RequestExt
 	);
 
 static int
 StorVscConnectToVsp(
-	DEVICE_OBJECT	*Device
+	struct device_object *Device
 	);
 
-static inline STORVSC_DEVICE* AllocStorDevice(DEVICE_OBJECT *Device)
+static inline STORVSC_DEVICE* AllocStorDevice(struct device_object *Device)
 {
 	STORVSC_DEVICE *storDevice;
 
@@ -167,7 +167,7 @@ static inline void FreeStorDevice(STORVSC_DEVICE *Device)
 }
 
 // Get the stordevice object iff exists and its refcount > 1
-static inline STORVSC_DEVICE* GetStorDevice(DEVICE_OBJECT *Device)
+static inline STORVSC_DEVICE* GetStorDevice(struct device_object *Device)
 {
 	STORVSC_DEVICE *storDevice;
 
@@ -185,7 +185,7 @@ static inline STORVSC_DEVICE* GetStorDevice(DEVICE_OBJECT *Device)
 }
 
 // Get the stordevice object iff exists and its refcount > 0
-static inline STORVSC_DEVICE* MustGetStorDevice(DEVICE_OBJECT *Device)
+static inline STORVSC_DEVICE* MustGetStorDevice(struct device_object *Device)
 {
 	STORVSC_DEVICE *storDevice;
 
@@ -202,7 +202,7 @@ static inline STORVSC_DEVICE* MustGetStorDevice(DEVICE_OBJECT *Device)
 	return storDevice;
 }
 
-static inline void PutStorDevice(DEVICE_OBJECT *Device)
+static inline void PutStorDevice(struct device_object *Device)
 {
 	STORVSC_DEVICE *storDevice;
 
@@ -214,7 +214,7 @@ static inline void PutStorDevice(DEVICE_OBJECT *Device)
 }
 
 // Drop ref count to 1 to effectively disable GetStorDevice()
-static inline STORVSC_DEVICE* ReleaseStorDevice(DEVICE_OBJECT *Device)
+static inline STORVSC_DEVICE* ReleaseStorDevice(struct device_object *Device)
 {
 	STORVSC_DEVICE *storDevice;
 
@@ -231,7 +231,7 @@ static inline STORVSC_DEVICE* ReleaseStorDevice(DEVICE_OBJECT *Device)
 }
 
 // Drop ref count to 0. No one can use StorDevice object.
-static inline STORVSC_DEVICE* FinalReleaseStorDevice(DEVICE_OBJECT *Device)
+static inline STORVSC_DEVICE* FinalReleaseStorDevice(struct device_object *Device)
 {
 	STORVSC_DEVICE *storDevice;
 
@@ -310,7 +310,7 @@ Description:
 --*/
 int
 StorVscOnDeviceAdd(
-	DEVICE_OBJECT	*Device,
+	struct device_object	*Device,
 	void			*AdditionalInfo
 	)
 {
@@ -354,7 +354,7 @@ Cleanup:
 	return ret;
 }
 
-static int StorVscChannelInit(DEVICE_OBJECT *Device)
+static int StorVscChannelInit(struct device_object *Device)
 {
 	int ret=0;
 	STORVSC_DEVICE *storDevice;
@@ -518,7 +518,7 @@ Cleanup:
 
 int
 StorVscConnectToVsp(
-	DEVICE_OBJECT	*Device
+	struct device_object *Device
 	)
 {
 	int ret=0;
@@ -563,7 +563,7 @@ Description:
 --*/
 int
 StorVscOnDeviceRemove(
-	DEVICE_OBJECT *Device
+	struct device_object *Device
 	)
 {
 	STORVSC_DEVICE *storDevice;
@@ -605,7 +605,7 @@ StorVscOnDeviceRemove(
 //	void *Context
 //	)
 //{
-//	DEVICE_OBJECT *device=(DEVICE_OBJECT*)Context;
+//	struct device_object *device = (struct device_object *)Context;
 //	STORVSC_DRIVER_OBJECT *storDriver;
 //
 //	DPRINT_ENTER(STORVSC);
@@ -618,7 +618,7 @@ StorVscOnDeviceRemove(
 
 int
 StorVscOnHostReset(
-	DEVICE_OBJECT *Device
+	struct device_object *Device
 	)
 {
 	int ret=0;
@@ -685,7 +685,7 @@ Description:
 --*/
 int
 StorVscOnIORequest(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	STORVSC_REQUEST	*Request
 	)
 {
@@ -799,7 +799,7 @@ StorVscOnCleanup(
 
 static void
 StorVscOnIOCompletion(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	VSTOR_PACKET	*VStorPacket,
 	STORVSC_REQUEST_EXTENSION *RequestExt
 	)
@@ -869,7 +869,7 @@ StorVscOnIOCompletion(
 
 static void
 StorVscOnReceive(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	VSTOR_PACKET	*VStorPacket,
 	STORVSC_REQUEST_EXTENSION *RequestExt
 	)
@@ -907,7 +907,7 @@ StorVscOnChannelCallback(
 	)
 {
 	int ret=0;
-	DEVICE_OBJECT *device = (DEVICE_OBJECT*)Context;
+	struct device_object *device = (struct device_object*)Context;
 	STORVSC_DEVICE *storDevice;
 	u32 bytesRecvd;
 	u64 requestId;
diff --git a/drivers/staging/hv/Vmbus.c b/drivers/staging/hv/Vmbus.c
index 72bb08f..4df935e 100644
--- a/drivers/staging/hv/Vmbus.c
+++ b/drivers/staging/hv/Vmbus.c
@@ -44,7 +44,7 @@ static const GUID gVmbusDeviceId={
 };
 
 static DRIVER_OBJECT* gDriver; // vmbus driver object
-static DEVICE_OBJECT* gDevice; // vmbus root device
+static struct device_object *gDevice; // vmbus root device
 
 
 //
@@ -58,7 +58,7 @@ VmbusGetChannelInterface(
 
 static void
 VmbusGetChannelInfo(
-	DEVICE_OBJECT	*DeviceObject,
+	struct device_object *DeviceObject,
 	DEVICE_INFO		*DeviceInfo
 	);
 
@@ -69,13 +69,13 @@ VmbusGetChannelOffers(
 
 static int
 VmbusOnDeviceAdd(
-	DEVICE_OBJECT	*Device,
+	struct device_object *Device,
 	void			*AdditionalInfo
 	);
 
 static int
 VmbusOnDeviceRemove(
-	DEVICE_OBJECT* dev
+	struct device_object *dev
 	);
 
 static void
@@ -203,7 +203,7 @@ Description:
 --*/
 static void
 VmbusGetChannelInfo(
-	DEVICE_OBJECT	*DeviceObject,
+	struct device_object *DeviceObject,
 	DEVICE_INFO		*DeviceInfo
 	)
 {
@@ -222,7 +222,7 @@ Description:
 
 --*/
 
-DEVICE_OBJECT*
+struct device_object *
 VmbusChildDeviceCreate(
 	GUID DeviceType,
 	GUID DeviceInstance,
@@ -248,7 +248,7 @@ Description:
 --*/
 int
 VmbusChildDeviceAdd(
-   DEVICE_OBJECT* ChildDevice)
+   struct device_object *ChildDevice)
 {
 	VMBUS_DRIVER_OBJECT* vmbusDriver = (VMBUS_DRIVER_OBJECT*)gDriver;
 
@@ -267,7 +267,7 @@ Description:
 --*/
 void
 VmbusChildDeviceRemove(
-   DEVICE_OBJECT* ChildDevice)
+   struct device_object *ChildDevice)
 {
 	VMBUS_DRIVER_OBJECT* vmbusDriver = (VMBUS_DRIVER_OBJECT*)gDriver;
 
@@ -285,7 +285,7 @@ Description:
 --*/
 //void
 //VmbusChildDeviceDestroy(
-//	DEVICE_OBJECT* ChildDevice
+//	struct device_object *ChildDevice
 //	)
 //{
 //	VMBUS_DRIVER_OBJECT* vmbusDriver = (VMBUS_DRIVER_OBJECT*)gDriver;
@@ -304,7 +304,7 @@ Description:
 --*/
 static int
 VmbusOnDeviceAdd(
-	DEVICE_OBJECT	*dev,
+	struct device_object *dev,
 	void			*AdditionalInfo
 	)
 {
@@ -342,7 +342,7 @@ Description:
 
 --*/
 int VmbusOnDeviceRemove(
-	DEVICE_OBJECT* dev
+	struct device_object *dev
 	)
 {
 	int ret=0;
diff --git a/drivers/staging/hv/VmbusPrivate.h b/drivers/staging/hv/VmbusPrivate.h
index 686d05f..5dedaaf 100644
--- a/drivers/staging/hv/VmbusPrivate.h
+++ b/drivers/staging/hv/VmbusPrivate.h
@@ -110,7 +110,7 @@ extern VMBUS_CONNECTION gVmbusConnection;
 //
 // General vmbus interface
 //
-static DEVICE_OBJECT*
+static struct device_object *
 VmbusChildDeviceCreate(
 	GUID deviceType,
 	GUID deviceInstance,
@@ -118,15 +118,15 @@ VmbusChildDeviceCreate(
 
 static int
 VmbusChildDeviceAdd(
-	DEVICE_OBJECT* Device);
+	struct device_object *Device);
 
 static void
 VmbusChildDeviceRemove(
-   DEVICE_OBJECT* Device);
+   struct device_object *Device);
 
 //static void
 //VmbusChildDeviceDestroy(
-//	DEVICE_OBJECT*);
+//	struct device_object *);
 
 static VMBUS_CHANNEL*
 GetChannelFromRelId(
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index d902653..5cc9097 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -260,7 +260,7 @@ static int blkvsc_probe(struct device *device)
 	STORVSC_DRIVER_OBJECT* storvsc_drv_obj = &blkvsc_drv_ctx->drv_obj;
 
 	struct device_context *device_ctx = device_to_device_context(device);
-	DEVICE_OBJECT* device_obj = &device_ctx->device_obj;
+	struct device_object *device_obj = &device_ctx->device_obj;
 
 	struct block_device_context *blkdev=NULL;
 	STORVSC_DEVICE_INFO device_info;
@@ -763,7 +763,7 @@ static int blkvsc_remove(struct device *device)
 	STORVSC_DRIVER_OBJECT* storvsc_drv_obj = &blkvsc_drv_ctx->drv_obj;
 
 	struct device_context *device_ctx = device_to_device_context(device);
-	DEVICE_OBJECT* device_obj = &device_ctx->device_obj;
+	struct device_object *device_obj = &device_ctx->device_obj;
 	struct block_device_context *blkdev = dev_get_drvdata(device);
 	unsigned long flags;
 
diff --git a/drivers/staging/hv/include/NetVscApi.h b/drivers/staging/hv/include/NetVscApi.h
index 626054b..5b2782c 100644
--- a/drivers/staging/hv/include/NetVscApi.h
+++ b/drivers/staging/hv/include/NetVscApi.h
@@ -44,15 +44,15 @@ typedef struct _NETVSC_PACKET	*PNETVSC_PACKET;
 // Data types
 //
 
-typedef int (*PFN_ON_OPEN)(DEVICE_OBJECT *Device);
-typedef int (*PFN_ON_CLOSE)(DEVICE_OBJECT *Device);
+typedef int (*PFN_ON_OPEN)(struct device_object *Device);
+typedef int (*PFN_ON_CLOSE)(struct device_object *Device);
 
-typedef void (*PFN_QUERY_LINKSTATUS)(DEVICE_OBJECT *Device);
-typedef int (*PFN_ON_SEND)(DEVICE_OBJECT *dev, PNETVSC_PACKET packet);
+typedef void (*PFN_QUERY_LINKSTATUS)(struct device_object *Device);
+typedef int (*PFN_ON_SEND)(struct device_object *dev, PNETVSC_PACKET packet);
 typedef void (*PFN_ON_SENDRECVCOMPLETION)(void * Context);
 
-typedef int (*PFN_ON_RECVCALLBACK)(DEVICE_OBJECT *dev, PNETVSC_PACKET packet);
-typedef void (*PFN_ON_LINKSTATUS_CHANGED)(DEVICE_OBJECT *dev, u32 Status);
+typedef int (*PFN_ON_RECVCALLBACK)(struct device_object *dev, PNETVSC_PACKET packet);
+typedef void (*PFN_ON_LINKSTATUS_CHANGED)(struct device_object *dev, u32 Status);
 
 // Represent the xfer page packet which contains 1 or more netvsc packet
 typedef struct _XFERPAGE_PACKET {
@@ -71,7 +71,7 @@ typedef struct _NETVSC_PACKET {
 	// Bookkeeping stuff
 	DLIST_ENTRY				ListEntry;
 
-	DEVICE_OBJECT			*Device;
+	struct device_object			*Device;
 	bool					IsDataPacket;
 
 	// Valid only for receives when we break a xfer page packet into multiple netvsc packets
diff --git a/drivers/staging/hv/include/StorVscApi.h b/drivers/staging/hv/include/StorVscApi.h
index f50fee7..c98d18c 100644
--- a/drivers/staging/hv/include/StorVscApi.h
+++ b/drivers/staging/hv/include/StorVscApi.h
@@ -54,11 +54,11 @@ typedef struct _STORVSC_REQUEST* PSTORVSC_REQUEST;
 //
 // Data types
 //
-typedef int (*PFN_ON_IO_REQUEST)(PDEVICE_OBJECT Device, PSTORVSC_REQUEST Request);
+typedef int (*PFN_ON_IO_REQUEST)(struct device_object *Device, PSTORVSC_REQUEST Request);
 typedef void (*PFN_ON_IO_REQUEST_COMPLTN)(PSTORVSC_REQUEST Request);
 
-typedef int (*PFN_ON_HOST_RESET)(PDEVICE_OBJECT Device);
-typedef void (*PFN_ON_HOST_RESCAN)(PDEVICE_OBJECT Device);
+typedef int (*PFN_ON_HOST_RESET)(struct device_object *Device);
+typedef void (*PFN_ON_HOST_RESCAN)(struct device_object *Device);
 
 
 // Matches Windows-end
diff --git a/drivers/staging/hv/include/VmbusApi.h b/drivers/staging/hv/include/VmbusApi.h
index 40b8f1e..23f60b5 100644
--- a/drivers/staging/hv/include/VmbusApi.h
+++ b/drivers/staging/hv/include/VmbusApi.h
@@ -39,7 +39,6 @@
 // Fwd declarations
 //
 typedef struct _DRIVER_OBJECT *PDRIVER_OBJECT;
-typedef struct _DEVICE_OBJECT *PDEVICE_OBJECT;
 
 //
 // Data types
@@ -70,28 +69,28 @@ typedef struct _MULTIPAGE_BUFFER {
 #pragma pack(pop)
 
 // All drivers
-typedef int (*PFN_ON_DEVICEADD)(PDEVICE_OBJECT Device, void* AdditionalInfo);
-typedef int (*PFN_ON_DEVICEREMOVE)(PDEVICE_OBJECT Device);
+typedef int (*PFN_ON_DEVICEADD)(struct device_object *Device, void *AdditionalInfo);
+typedef int (*PFN_ON_DEVICEREMOVE)(struct device_objectx *Device);
 typedef char** (*PFN_ON_GETDEVICEIDS)(void);
 typedef void (*PFN_ON_CLEANUP)(PDRIVER_OBJECT Driver);
 
 // Vmbus extensions
-//typedef int (*PFN_ON_MATCH)(PDEVICE_OBJECT dev, PDRIVER_OBJECT drv);
-//typedef int (*PFN_ON_PROBE)(PDEVICE_OBJECT dev);
+//typedef int (*PFN_ON_MATCH)(struct device_object *dev, PDRIVER_OBJECT drv);
+//typedef int (*PFN_ON_PROBE)(struct device_object *dev);
 typedef int	(*PFN_ON_ISR)(PDRIVER_OBJECT drv);
 typedef void (*PFN_ON_DPC)(PDRIVER_OBJECT drv);
 typedef void (*PFN_GET_CHANNEL_OFFERS)(void);
 
-typedef PDEVICE_OBJECT (*PFN_ON_CHILDDEVICE_CREATE)(GUID DeviceType, GUID DeviceInstance, void *Context);
-typedef void (*PFN_ON_CHILDDEVICE_DESTROY)(PDEVICE_OBJECT Device);
-typedef int (*PFN_ON_CHILDDEVICE_ADD)(PDEVICE_OBJECT RootDevice, PDEVICE_OBJECT ChildDevice);
-typedef void (*PFN_ON_CHILDDEVICE_REMOVE)(PDEVICE_OBJECT Device);
+typedef struct device_object  *(*PFN_ON_CHILDDEVICE_CREATE)(GUID DeviceType, GUID DeviceInstance, void *Context);
+typedef void (*PFN_ON_CHILDDEVICE_DESTROY)(struct device_object *Device);
+typedef int (*PFN_ON_CHILDDEVICE_ADD)(struct device_object *RootDevice, struct device_object * ChildDevice);
+typedef void (*PFN_ON_CHILDDEVICE_REMOVE)(struct device_object *Device);
 
 // Vmbus channel interface
 typedef void (*VMBUS_CHANNEL_CALLBACK)(void * context);
 
 typedef int	(*VMBUS_CHANNEL_OPEN)(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	u32				SendBufferSize,
 	u32				RecvRingBufferSize,
 	void *				UserData,
@@ -101,11 +100,11 @@ typedef int	(*VMBUS_CHANNEL_OPEN)(
 	);
 
 typedef void (*VMBUS_CHANNEL_CLOSE)(
-	PDEVICE_OBJECT		Device
+	struct device_object 		*Device
 	);
 
 typedef int	(*VMBUS_CHANNEL_SEND_PACKET)(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	const void *			Buffer,
 	u32				BufferLen,
 	u64				RequestId,
@@ -114,7 +113,7 @@ typedef int	(*VMBUS_CHANNEL_SEND_PACKET)(
 );
 
 typedef int	(*VMBUS_CHANNEL_SEND_PACKET_PAGEBUFFER)(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	PAGE_BUFFER			PageBuffers[],
 	u32				PageCount,
 	void *				Buffer,
@@ -123,7 +122,7 @@ typedef int	(*VMBUS_CHANNEL_SEND_PACKET_PAGEBUFFER)(
 	);
 
 typedef int	(*VMBUS_CHANNEL_SEND_PACKET_MULTIPAGEBUFFER)(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	MULTIPAGE_BUFFER	*MultiPageBuffer,
 	void *				Buffer,
 	u32				BufferLen,
@@ -131,7 +130,7 @@ typedef int	(*VMBUS_CHANNEL_SEND_PACKET_MULTIPAGEBUFFER)(
 );
 
 typedef int	(*VMBUS_CHANNEL_RECV_PACKET)(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	void *				Buffer,
 	u32				BufferLen,
 	u32*				BufferActualLen,
@@ -139,7 +138,7 @@ typedef int	(*VMBUS_CHANNEL_RECV_PACKET)(
 	);
 
 typedef int	(*VMBUS_CHANNEL_RECV_PACKET_PAW)(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	void *				Buffer,
 	u32				BufferLen,
 	u32*				BufferActualLen,
@@ -147,14 +146,14 @@ typedef int	(*VMBUS_CHANNEL_RECV_PACKET_PAW)(
 	);
 
 typedef int	(*VMBUS_CHANNEL_ESTABLISH_GPADL)(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	void *				Buffer,	// from kmalloc()
 	u32				BufferLen,		// page-size multiple
 	u32*				GpadlHandle
 	);
 
 typedef int	(*VMBUS_CHANNEL_TEARDOWN_GPADL)(
-	PDEVICE_OBJECT		Device,
+	struct device_object 		*Device,
 	u32				GpadlHandle
 	);
 
@@ -186,7 +185,7 @@ typedef struct _DEVICE_INFO {
 	PORT_INFO	Outbound;
 } DEVICE_INFO;
 
-typedef void (*VMBUS_GET_CHANNEL_INFO)(PDEVICE_OBJECT Device, DEVICE_INFO* DeviceInfo);
+typedef void (*VMBUS_GET_CHANNEL_INFO)(struct device_object *Device, DEVICE_INFO *DeviceInfo);
 
 typedef struct _VMBUS_CHANNEL_INTERFACE {
 	VMBUS_CHANNEL_OPEN							Open;
@@ -218,14 +217,14 @@ typedef struct _DRIVER_OBJECT {
 
 
 // Base device object
-typedef struct _DEVICE_OBJECT {
+struct device_object {
 	DRIVER_OBJECT*		Driver;		// the driver for this device
 	char				name[64];
 	GUID				deviceType; // the device type id of this device
 	GUID				deviceInstance; // the device instance id of this device
 	void*				context;
 	void*				Extension;		// Device extension;
-} DEVICE_OBJECT;
+};
 
 
 // Vmbus driver object
diff --git a/drivers/staging/hv/include/vmbus.h b/drivers/staging/hv/include/vmbus.h
index 62ddc1d..e964d85 100644
--- a/drivers/staging/hv/include/vmbus.h
+++ b/drivers/staging/hv/include/vmbus.h
@@ -53,7 +53,7 @@ struct device_context {
 	GUID					device_id;
 	int						probe_error;
 	struct device			device;
-	DEVICE_OBJECT			device_obj;
+	struct device_object		device_obj;
 };
 
 
@@ -64,7 +64,7 @@ struct device_context {
 //
 // Inlines
 //
-static inline struct device_context *to_device_context(DEVICE_OBJECT *device_obj)
+static inline struct device_context *to_device_context(struct device_object *device_obj)
 {
 	return container_of(device_obj, struct device_context, device_obj);
 }
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 20adcc6..551be97 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -51,10 +51,10 @@ static int netvsc_remove(struct device *device);
 static int netvsc_open(struct net_device *net);
 static void netvsc_xmit_completion(void *context);
 static int netvsc_start_xmit (struct sk_buff *skb, struct net_device *net);
-static int netvsc_recv_callback(DEVICE_OBJECT *device_obj, NETVSC_PACKET* Packet);
+static int netvsc_recv_callback(struct device_object *device_obj, NETVSC_PACKET *Packet);
 static int netvsc_close(struct net_device *net);
 static struct net_device_stats *netvsc_get_stats(struct net_device *net);
-static void netvsc_linkstatus_callback(DEVICE_OBJECT *device_obj, unsigned int status);
+static void netvsc_linkstatus_callback(struct device_object *device_obj, unsigned int status);
 
 //
 // Data types
@@ -172,7 +172,7 @@ static int netvsc_probe(struct device *device)
 	NETVSC_DRIVER_OBJECT *net_drv_obj = &net_drv_ctx->drv_obj;
 
 	struct device_context *device_ctx = device_to_device_context(device);
-	DEVICE_OBJECT *device_obj = &device_ctx->device_obj;
+	struct device_object *device_obj = &device_ctx->device_obj;
 
 	struct net_device *net = NULL;
 	struct net_device_context *net_device_ctx;
@@ -249,7 +249,7 @@ static int netvsc_remove(struct device *device)
 
 	struct device_context *device_ctx = device_to_device_context(device);
 	struct net_device *net = dev_get_drvdata(&device_ctx->device);
-	DEVICE_OBJECT *device_obj = &device_ctx->device_obj;
+	struct device_object *device_obj = &device_ctx->device_obj;
 
 	DPRINT_ENTER(NETVSC_DRV);
 
@@ -302,7 +302,7 @@ static int netvsc_open(struct net_device *net)
 	struct netvsc_driver_context *net_drv_ctx = (struct netvsc_driver_context*)driver_ctx;
 	NETVSC_DRIVER_OBJECT *net_drv_obj = &net_drv_ctx->drv_obj;
 
-	DEVICE_OBJECT *device_obj = &net_device_ctx->device_ctx->device_obj;
+	struct device_object *device_obj = &net_device_ctx->device_ctx->device_obj;
 
 	DPRINT_ENTER(NETVSC_DRV);
 
@@ -344,7 +344,7 @@ static int netvsc_close(struct net_device *net)
 	struct netvsc_driver_context *net_drv_ctx = (struct netvsc_driver_context*)driver_ctx;
 	NETVSC_DRIVER_OBJECT *net_drv_obj = &net_drv_ctx->drv_obj;
 
-	DEVICE_OBJECT *device_obj = &net_device_ctx->device_ctx->device_obj;
+	struct device_object *device_obj = &net_device_ctx->device_ctx->device_obj;
 
 	DPRINT_ENTER(NETVSC_DRV);
 
@@ -515,7 +515,7 @@ Name:	netvsc_linkstatus_callback()
 Desc:	Link up/down notification
 
 --*/
-static void netvsc_linkstatus_callback(DEVICE_OBJECT *device_obj, unsigned int status)
+static void netvsc_linkstatus_callback(struct device_object *device_obj, unsigned int status)
 {
 	struct device_context* device_ctx = to_device_context(device_obj);
 	struct net_device* net = dev_get_drvdata(&device_ctx->device);
@@ -549,7 +549,7 @@ Name:	netvsc_recv_callback()
 Desc:	Callback when we receive a packet from the "wire" on the specify device
 
 --*/
-static int netvsc_recv_callback(DEVICE_OBJECT *device_obj, NETVSC_PACKET* packet)
+static int netvsc_recv_callback(struct device_object *device_obj, NETVSC_PACKET* packet)
 {
 	int ret=0;
 	struct device_context *device_ctx = to_device_context(device_obj);
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 62aeb27..cafc2a9 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -82,7 +82,7 @@ static int storvsc_device_alloc(struct scsi_device *);
 static int storvsc_device_configure(struct scsi_device *);
 static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd);
 static void storvsc_host_rescan_callback(struct work_struct *work);
-static void storvsc_host_rescan(DEVICE_OBJECT* device_obj);
+static void storvsc_host_rescan(struct device_object *device_obj);
 static int storvsc_remove(struct device *dev);
 
 static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl, unsigned int sg_count, unsigned int len);
@@ -233,7 +233,7 @@ static int storvsc_probe(struct device *device)
 	STORVSC_DRIVER_OBJECT* storvsc_drv_obj = &storvsc_drv_ctx->drv_obj;
 
 	struct device_context *device_ctx = device_to_device_context(device);
-	DEVICE_OBJECT* device_obj = &device_ctx->device_obj;
+	struct device_object *device_obj = &device_ctx->device_obj;
 
 	struct Scsi_Host *host;
 	struct host_device_context *host_device_ctx;
@@ -336,7 +336,7 @@ static int storvsc_remove(struct device *device)
 	STORVSC_DRIVER_OBJECT* storvsc_drv_obj = &storvsc_drv_ctx->drv_obj;
 
 	struct device_context *device_ctx = device_to_device_context(device);
-	DEVICE_OBJECT* device_obj = &device_ctx->device_obj;
+	struct device_object *device_obj = &device_ctx->device_obj;
 
 	struct Scsi_Host *host = dev_get_drvdata(device);
 	struct host_device_context *host_device_ctx=(struct host_device_context*)host->hostdata;
@@ -912,7 +912,7 @@ Desc:	Rescan the scsi HBA
 --*/
 static void storvsc_host_rescan_callback(struct work_struct *work)
 {
-	DEVICE_OBJECT* device_obj =
+	struct device_object *device_obj =
 	    &((struct host_device_context*)work)->device_ctx->device_obj;
 	struct device_context* device_ctx = to_device_context(device_obj);
 	struct Scsi_Host *host = dev_get_drvdata(&device_ctx->device);
@@ -1076,7 +1076,7 @@ static int storvsc_report_luns(struct scsi_device *sdev, unsigned int luns[], un
 	return 0;
 }
 
-static void storvsc_host_rescan(DEVICE_OBJECT* device_obj)
+static void storvsc_host_rescan(struct device_object *device_obj)
 {
 	struct device_context* device_ctx = to_device_context(device_obj);
 	struct Scsi_Host *host = dev_get_drvdata(&device_ctx->device);
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index e615610..8e4146f 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -75,11 +75,11 @@ static irqreturn_t vmbus_isr(int irq, void* dev_id);
 static void vmbus_device_release(struct device *device);
 static void vmbus_bus_release(struct device *device);
 
-static DEVICE_OBJECT* vmbus_child_device_create(GUID type, GUID instance, void* context);
-static void vmbus_child_device_destroy(DEVICE_OBJECT* device_obj);
-static int vmbus_child_device_register(DEVICE_OBJECT* root_device_obj, DEVICE_OBJECT* child_device_obj);
-static void vmbus_child_device_unregister(DEVICE_OBJECT* child_device_obj);
-static void vmbus_child_device_get_info(DEVICE_OBJECT *device_obj, DEVICE_INFO *device_info);
+static struct device_object *vmbus_child_device_create(GUID type, GUID instance, void *context);
+static void vmbus_child_device_destroy(struct device_object *device_obj);
+static int vmbus_child_device_register(struct device_object *root_device_obj, struct device_object *child_device_obj);
+static void vmbus_child_device_unregister(struct device_object *child_device_obj);
+static void vmbus_child_device_get_info(struct device_object *device_obj, DEVICE_INFO *device_info);
 
 //static ssize_t vmbus_show_class_id(struct device *dev, struct device_attribute *attr, char *buf);
 //static ssize_t vmbus_show_device_id(struct device *dev, struct device_attribute *attr, char *buf);
@@ -551,7 +551,7 @@ Name:	vmbus_child_device_get_info()
 
 Desc:	Get the vmbus child device info. This is invoked to display various device attributes in sysfs.
 --*/
-static void vmbus_child_device_get_info(DEVICE_OBJECT *device_obj, DEVICE_INFO *device_info)
+static void vmbus_child_device_get_info(struct device_object *device_obj, DEVICE_INFO *device_info)
 {
 	VMBUS_DRIVER_OBJECT *vmbus_drv_obj=&g_vmbus_drv.drv_obj;
 
@@ -566,10 +566,10 @@ Name:	vmbus_child_device_create()
 Desc:	Creates and registers a new child device on the vmbus.
 
 --*/
-static DEVICE_OBJECT* vmbus_child_device_create(GUID type, GUID instance, void* context)
+static struct device_object *vmbus_child_device_create(GUID type, GUID instance, void* context)
 {
 	struct device_context *child_device_ctx;
-	DEVICE_OBJECT* child_device_obj;
+	struct device_object *child_device_obj;
 
 	DPRINT_ENTER(VMBUS_DRV);
 
@@ -610,7 +610,7 @@ Name:	vmbus_child_device_register()
 Desc:	Register the child device on the specified bus
 
 --*/
-static int vmbus_child_device_register(DEVICE_OBJECT* root_device_obj, DEVICE_OBJECT* child_device_obj)
+static int vmbus_child_device_register(struct device_object *root_device_obj, struct device_object *child_device_obj)
 {
 	int ret=0;
 	struct device_context *root_device_ctx = to_device_context(root_device_obj);
@@ -664,7 +664,7 @@ Name:	vmbus_child_device_unregister()
 Desc:	Remove the specified child device from the vmbus.
 
 --*/
-static void vmbus_child_device_unregister(DEVICE_OBJECT* device_obj)
+static void vmbus_child_device_unregister(struct device_object *device_obj)
 {
 	struct device_context *device_ctx = to_device_context(device_obj);
 
@@ -689,7 +689,7 @@ Name:	vmbus_child_device_destroy()
 Desc:	Destroy the specified child device on the vmbus.
 
 --*/
-static void vmbus_child_device_destroy(DEVICE_OBJECT* device_obj)
+static void vmbus_child_device_destroy(struct device_object *device_obj)
 {
 	DPRINT_ENTER(VMBUS_DRV);
 
-- 
1.6.0.4

