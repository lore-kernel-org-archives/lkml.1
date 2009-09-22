Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZIVFfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZIVFfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZIVFfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:35:52 -0400
Received: from dcent.unixwiz.net ([99.25.142.34]:34405 "EHLO dcent.unixwiz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbZIVFfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:35:52 -0400
From: Steve Friedl <steve@unixwiz.net>
To: linux-kernel@vger.kernel.org
Date: Mon, 21 Sep 2009 18:18:46 -0700
Subject: [PATCH 1/8] staging: hv: Fixed typo in Hyper-V struct name: VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER
Message-Id: <20090922053555.CA9007188F2@dcent.unixwiz.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER typedef/struct was
misspelled (...MULIT.. -> ...MULTI...) so I felt compelled to fix it. This
was the only change in this patch.

~~~ Steve

Signed-off-by: Steve Friedl <steve@unixwiz.net>

---
 drivers/staging/hv/BlkVsc.c  |    2 +-
 drivers/staging/hv/Channel.c |    6 +++---
 drivers/staging/hv/Channel.h |    2 +-
 drivers/staging/hv/StorVsc.c |    2 +-
 drivers/staging/hv/Vmbus.c   |    4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/BlkVsc.c b/drivers/staging/hv/BlkVsc.c
index 51aa861..7999f1c 100644
--- a/drivers/staging/hv/BlkVsc.c
+++ b/drivers/staging/hv/BlkVsc.c
@@ -88,7 +88,7 @@ int BlkVscInitialize(struct hv_driver *Driver)
 	 * Divide the ring buffer data size (which is 1 page less than the ring
 	 * buffer size since that page is reserved for the ring buffer indices)
 	 * by the max request size (which is
-	 * VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER + struct vstor_packet + u64)
+	 * VMBUS_CHANNEL_PACKET_MULTIPAGE_BUFFER + struct vstor_packet + u64)
 	 */
 	storDriver->MaxOutstandingRequestsPerChannel =
 		((storDriver->RingBufferSize - PAGE_SIZE) /
diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c
index d649ee1..1dbf62a 100644
--- a/drivers/staging/hv/Channel.c
+++ b/drivers/staging/hv/Channel.c
@@ -781,7 +781,7 @@ int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
 				void *Buffer, u32 BufferLen, u64 RequestId)
 {
 	int ret;
-	struct VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER desc;
+	struct VMBUS_CHANNEL_PACKET_MULTIPAGE_BUFFER desc;
 	u32 descSize;
 	u32 packetLen;
 	u32 packetLenAligned;
@@ -801,10 +801,10 @@ int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
 	ASSERT(PfnCount <= MAX_MULTIPAGE_BUFFER_COUNT);
 
 	/*
-	 * Adjust the size down since VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER is
+	 * Adjust the size down since VMBUS_CHANNEL_PACKET_MULTIPAGE_BUFFER is
 	 * the largest size we support
 	 */
-	descSize = sizeof(struct VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER) -
+	descSize = sizeof(struct VMBUS_CHANNEL_PACKET_MULTIPAGE_BUFFER) -
 			  ((MAX_MULTIPAGE_BUFFER_COUNT - PfnCount) *
 			  sizeof(u64));
 	packetLen = descSize + BufferLen;
diff --git a/drivers/staging/hv/Channel.h b/drivers/staging/hv/Channel.h
index 6b283ed..41736fe 100644
--- a/drivers/staging/hv/Channel.h
+++ b/drivers/staging/hv/Channel.h
@@ -40,7 +40,7 @@ struct VMBUS_CHANNEL_PACKET_PAGE_BUFFER {
 } __attribute__((packed));
 
 /* The format must be the same as struct vmdata_gpa_direct */
-struct VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER {
+struct VMBUS_CHANNEL_PACKET_MULTIPAGE_BUFFER {
 	u16 Type;
 	u16 DataOffset8;
 	u16 Length8;
diff --git a/drivers/staging/hv/StorVsc.c b/drivers/staging/hv/StorVsc.c
index 14015c9..05a58a9 100644
--- a/drivers/staging/hv/StorVsc.c
+++ b/drivers/staging/hv/StorVsc.c
@@ -824,7 +824,7 @@ int StorVscInitialize(struct hv_driver *Driver)
 	 * Divide the ring buffer data size (which is 1 page less
 	 * than the ring buffer size since that page is reserved for
 	 * the ring buffer indices) by the max request size (which is
-	 * VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER + struct vstor_packet + u64)
+	 * VMBUS_CHANNEL_PACKET_MULTIPAGE_BUFFER + struct vstor_packet + u64)
 	 */
 	storDriver->MaxOutstandingRequestsPerChannel =
 		((storDriver->RingBufferSize - PAGE_SIZE) /
diff --git a/drivers/staging/hv/Vmbus.c b/drivers/staging/hv/Vmbus.c
index a4dd06f..c65b843 100644
--- a/drivers/staging/hv/Vmbus.c
+++ b/drivers/staging/hv/Vmbus.c
@@ -280,9 +280,9 @@ int VmbusInitialize(struct hv_driver *drv)
 	DPRINT_INFO(VMBUS, "+++++++ Vmbus using SINT %d +++++++",
 			VMBUS_MESSAGE_SINT);
 	DPRINT_DBG(VMBUS, "sizeof(VMBUS_CHANNEL_PACKET_PAGE_BUFFER)=%zd, "
-			"sizeof(VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER)=%zd",
+			"sizeof(VMBUS_CHANNEL_PACKET_MULTIPAGE_BUFFER)=%zd",
 			sizeof(struct VMBUS_CHANNEL_PACKET_PAGE_BUFFER),
-			sizeof(struct VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER));
+			sizeof(struct VMBUS_CHANNEL_PACKET_MULTIPAGE_BUFFER));
 
 	drv->name = gDriverName;
 	memcpy(&drv->deviceType, &gVmbusDeviceType, sizeof(struct hv_guid));
-- 
1.6.5.rc1

