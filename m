Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZIVFnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZIVFnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZIVFnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:43:05 -0400
Received: from dcent.unixwiz.net ([99.25.142.34]:56957 "EHLO dcent.unixwiz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbZIVFnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:43:03 -0400
Date: Mon, 21 Sep 2009 22:43:06 -0700
From: Steve Friedl <steve@unixwiz.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] staging: hv: Fixed all kinds of comments (no code changes)
Message-ID: <20090922054306.GA6013@dcent.unixwiz.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made a pass through the code and fixed wording in *comments*: typos,
unclear wording, etc. Nothing in this patch affects actual code.

~~~ Steve

Signed-off-by: Steve Friedl <steve@unixwiz.net>

---
 drivers/staging/hv/Channel.c     |    8 +++++---
 drivers/staging/hv/ChannelMgmt.c |   15 ++++++++-------
 drivers/staging/hv/Connection.c  |    2 +-
 drivers/staging/hv/Hv.c          |   12 ++++++------
 drivers/staging/hv/NetVsc.c      |   12 ++++++------
 drivers/staging/hv/RingBuffer.c  |   11 +++++------
 drivers/staging/hv/RndisFilter.c |    4 ++--
 drivers/staging/hv/StorVsc.c     |   10 +++++-----
 drivers/staging/hv/Vmbus.c       |   10 +++++-----
 drivers/staging/hv/blkvsc_drv.c  |   18 +++++++++---------
 drivers/staging/hv/hv_api.h      |    2 +-
 drivers/staging/hv/netvsc_drv.c  |    2 +-
 drivers/staging/hv/storvsc_drv.c |    8 ++++----
 drivers/staging/hv/vmbus_drv.c   |    8 ++++----
 14 files changed, 62 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c
index 1dbf62a..8395643 100644
--- a/drivers/staging/hv/Channel.c
+++ b/drivers/staging/hv/Channel.c
@@ -441,7 +441,7 @@ static int VmbusChannelCreateGpadlHeader(void *Kbuffer, u32 Size,
 }
 
 /**
- * VmbusChannelEstablishGpadl - Estabish a GPADL for the specified buffer
+ * VmbusChannelEstablishGpadl - Establish a GPADL for the specified buffer
  *
  * @Channel: a channel
  * @Kbuffer: from kmalloc
@@ -709,7 +709,8 @@ int VmbusChannelSendPacket(struct vmbus_channel *Channel, const void *Buffer,
 }
 
 /**
- * VmbusChannelSendPacketPageBuffer - Send a range of single-page buffer packets using a GPADL Direct packet type.
+ * VmbusChannelSendPacketPageBuffer - Send a range of single-page buffer
+ * packets using a GPADL Direct packet type.
  */
 int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *Channel,
 				     struct hv_page_buffer PageBuffers[],
@@ -774,7 +775,8 @@ int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *Channel,
 }
 
 /**
- * VmbusChannelSendPacketMultiPageBuffer - Send a multi-page buffer packet using a GPADL Direct packet type.
+ * VmbusChannelSendPacketMultiPageBuffer - Send a multi-page buffer
+ * packet using a GPADL Direct packet type.
  */
 int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
 				struct hv_multipage_buffer *MultiPageBuffer,
diff --git a/drivers/staging/hv/ChannelMgmt.c b/drivers/staging/hv/ChannelMgmt.c
index 3db62ca..9aca75d 100644
--- a/drivers/staging/hv/ChannelMgmt.c
+++ b/drivers/staging/hv/ChannelMgmt.c
@@ -124,7 +124,7 @@ void FreeVmbusChannel(struct vmbus_channel *Channel)
 	/*
 	 * We have to release the channel's workqueue/thread in the vmbus's
 	 * workqueue/thread context
-	 * ie we can't destroy ourselves.
+	 * i.e. we can't destroy ourselves.
 	 */
 	osd_schedule_callback(gVmbusConnection.WorkQueue, ReleaseVmbusChannel,
 			      Channel);
@@ -173,7 +173,7 @@ static void VmbusChannelProcessOffer(void *context)
 	}
 
 	/*
-	 * Start the process of binding this offer to the driver
+	 * Start the process of binding this offer to the driver.
 	 * We need to set the DeviceObject field before calling
 	 * VmbusChildDeviceAdd()
 	 */
@@ -213,7 +213,8 @@ static void VmbusChannelProcessOffer(void *context)
 }
 
 /**
- * VmbusChannelProcessRescindOffer - Rescind the offer by initiating a device removal
+ * VmbusChannelProcessRescindOffer - Rescind the offer by initiating
+ *  a device removal
  */
 static void VmbusChannelProcessRescindOffer(void *context)
 {
@@ -225,7 +226,8 @@ static void VmbusChannelProcessRescindOffer(void *context)
 }
 
 /**
- * VmbusChannelOnOffer - Handler for channel offers from vmbus in parent partition.
+ * VmbusChannelOnOffer - Handler for channel offers from vmbus in
+ *  parent partition.
  *
  * We ignore all offers except network and storage offers. For each network and
  * storage offers, we create a channel object and queue a work item to the
@@ -651,7 +653,8 @@ Cleanup:
 }
 
 /**
- * VmbusChannelReleaseUnattachedChannels - Release channels that are unattached/unconnected ie (no drivers associated)
+ * VmbusChannelReleaseUnattachedChannels - Release channels that are
+ *   unattached/unconnected i.e. (no drivers associated)
  */
 void VmbusChannelReleaseUnattachedChannels(void)
 {
@@ -682,5 +685,3 @@ void VmbusChannelReleaseUnattachedChannels(void)
 
 	spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
 }
-
-/* eof */
diff --git a/drivers/staging/hv/Connection.c b/drivers/staging/hv/Connection.c
index 43c2e68..0496952 100644
--- a/drivers/staging/hv/Connection.c
+++ b/drivers/staging/hv/Connection.c
@@ -218,7 +218,7 @@ Cleanup:
 }
 
 /**
- * GetChannelFromRelId - Get the channel object given its child relative id (ie channel id)
+ * GetChannelFromRelId - Get the channel object given its child relative id (i.e. channel id)
  */
 struct vmbus_channel *GetChannelFromRelId(u32 relId)
 {
diff --git a/drivers/staging/hv/Hv.c b/drivers/staging/hv/Hv.c
index c5b6613..26023c9 100644
--- a/drivers/staging/hv/Hv.c
+++ b/drivers/staging/hv/Hv.c
@@ -35,7 +35,7 @@ struct hv_context gHvContext = {
 };
 
 /**
- * HvQueryHypervisorPresence - Query the cpuid for presense of windows hypervisor
+ * HvQueryHypervisorPresence - Query the cpuid for presense of Windows hypervisor
  */
 static int HvQueryHypervisorPresence(void)
 {
@@ -56,7 +56,7 @@ static int HvQueryHypervisorPresence(void)
 }
 
 /**
- * HvQueryHypervisorInfo - Get version info of the windows hypervisor
+ * HvQueryHypervisorInfo - Get version info of the Windows hypervisor
  */
 static int HvQueryHypervisorInfo(void)
 {
@@ -68,7 +68,7 @@ static int HvQueryHypervisorInfo(void)
 	unsigned int op;
 
 	/*
-	* Its assumed that this is called after confirming that Viridian
+	* It's assumed that this is called after confirming that Hyper-V
 	* is present. Query id and revision.
 	*/
 	eax = 0;
@@ -208,7 +208,7 @@ int HvInit(void)
 	/* HvQueryHypervisorFeatures(maxLeaf); */
 
 	/*
-	 * Determine if we are running on xenlinux (ie x2v shim) or native
+	 * Determine if we are running on xenlinux (i.e. x2v shim) or native
 	 * linux
 	 */
 	rdmsrl(HV_X64_MSR_GUEST_OS_ID, gHvContext.GuestId);
@@ -382,7 +382,7 @@ u16 HvSignalEvent(void)
 /**
  * HvSynicInit - Initialize the Synthethic Interrupt Controller.
  *
- * If it is already initialized by another entity (ie x2v shim), we need to
+ * If it is already initialized by another entity (i.e. x2v shim), we need to
  * retrieve the initialized message and event pages.  Otherwise, we create and
  * initialize the message and event pages.
  */
@@ -420,7 +420,7 @@ int HvSynicInit(u32 irqVector)
 			   simp.AsUINT64, siefp.AsUINT64);
 
 		/*
-		 * Determine if we are running on xenlinux (ie x2v shim) or
+		 * Determine if we are running on xenlinux (i.e. x2v shim) or
 		 * native linux
 		 */
 		rdmsrl(HV_X64_MSR_GUEST_OS_ID, guestID);
diff --git a/drivers/staging/hv/NetVsc.c b/drivers/staging/hv/NetVsc.c
index 1610b84..ee94c03 100644
--- a/drivers/staging/hv/NetVsc.c
+++ b/drivers/staging/hv/NetVsc.c
@@ -440,7 +440,7 @@ static int NetVscDestroyReceiveBuffer(struct netvsc_device *NetDevice)
 
 	/*
 	 * If we got a section count, it means we received a
-	 * SendReceiveBufferComplete msg (ie sent
+	 * SendReceiveBufferComplete msg (i.e. sent
 	 * NvspMessage1TypeSendReceiveBuffer msg) therefore, we need
 	 * to send a revoke msg here
 	 */
@@ -520,7 +520,7 @@ static int NetVscDestroySendBuffer(struct netvsc_device *NetDevice)
 
 	/*
 	 * If we got a section count, it means we received a
-	 *  SendReceiveBufferComplete msg (ie sent
+	 *  SendReceiveBufferComplete msg (i.e. sent
 	 *  NvspMessage1TypeSendReceiveBuffer msg) therefore, we need
 	 *  to send a revoke msg here
 	 */
@@ -818,7 +818,7 @@ static int NetVscOnDeviceRemove(struct hv_device *Device)
 	DPRINT_INFO(NETVSC, "Disabling outbound traffic on net device (%p)...",
 		    Device->Extension);
 
-	/* Stop outbound traffic ie sends and receives completions */
+	/* Stop outbound traffic i.e. sends and receives completions */
 	netDevice = ReleaseOutboundNetDevice(Device);
 	if (!netDevice) {
 		DPRINT_ERR(NETVSC, "No net device present!!");
@@ -839,7 +839,7 @@ static int NetVscOnDeviceRemove(struct hv_device *Device)
 	DPRINT_INFO(NETVSC, "Disabling inbound traffic on net device (%p)...",
 		    Device->Extension);
 
-	/* Stop inbound traffic ie receives and sends completions */
+	/* Stop inbound traffic i.e. receives and sends completions */
 	netDevice = ReleaseInboundNetDevice(Device);
 
 	/* At this point, no one should be accessing netDevice except in here */
@@ -1060,7 +1060,7 @@ static void NetVscOnReceive(struct hv_device *Device,
 
 	/*
 	 * We need at least 2 netvsc pkts (1 to represent the xfer
-	 * page and at least 1 for the range) i.e. we can handled
+	 * page and at least 1 for the range) i.e. we can handle
 	 * some of the xfer page packet ranges...
 	 */
 	if (count < 2) {
@@ -1229,7 +1229,7 @@ retry_send_cmplt:
 	}
 }
 
-/* Send a receive completion packet to RNDIS device (ie NetVsp) */
+/* Send a receive completion packet to RNDIS device (i.e. NetVsp) */
 static void NetVscOnReceiveCompletion(void *Context)
 {
 	struct hv_netvsc_packet *packet = Context;
diff --git a/drivers/staging/hv/RingBuffer.c b/drivers/staging/hv/RingBuffer.c
index 3428372..501dee9 100644
--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -41,7 +41,7 @@ Name:
 	GetRingBufferAvailBytes()
 
 Description:
-	Get number of bytes available to read and to write to
+	Get number of bytes available to read and to write
 	for the specified ring buffer
 
 --*/
@@ -362,8 +362,10 @@ int RingBufferWrite(struct hv_ring_buffer_info *OutRingInfo,
 
 	/* DumpRingInfo(OutRingInfo, "BEFORE "); */
 
-	/* If there is only room for the packet, assume it is full. Otherwise, the next time around, we think the ring buffer */
-	/* is empty since the read index == write index */
+	/* If there is only room for the packet, assume it is full.
+	 * Otherwise, the next time around, we think the ring buffer
+	 * is empty since the read index == write index */
+
 	if (byteAvailToWrite <= totalBytesToWrite)
 	{
 		DPRINT_DBG(VMBUS, "No more space left on outbound ring buffer (needed %u, avail %u)", totalBytesToWrite, byteAvailToWrite);
@@ -601,6 +603,3 @@ CopyFromRingBuffer(
 
 	return StartReadOffset;
 }
-
-
-/* eof */
diff --git a/drivers/staging/hv/RndisFilter.c b/drivers/staging/hv/RndisFilter.c
index 26d7997..17a6d65 100644
--- a/drivers/staging/hv/RndisFilter.c
+++ b/drivers/staging/hv/RndisFilter.c
@@ -364,7 +364,7 @@ static void RndisFilterReceiveData(struct rndis_device *Device,
 
 	/*
 	 * FIXME: Handle multiple rndis pkt msgs that maybe enclosed in this
-	 * netvsc packet (ie TotalDataBufferLength != MessageLength)
+	 * netvsc packet (i.e. TotalDataBufferLength != MessageLength)
 	 */
 
 	/* Remove the rndis header and pass it back up the stack */
@@ -597,7 +597,7 @@ static int RndisFilterSetPacketFilter(struct rndis_device *Device,
 		ret = -1;
 		DPRINT_ERR(NETVSC, "timeout before we got a set response...");
 		/*
-		 * We cant deallocate the request since we may still receive a
+		 * We can't deallocate the request since we may still receive a
 		 * send completion for it.
 		 */
 		goto Exit;
diff --git a/drivers/staging/hv/StorVsc.c b/drivers/staging/hv/StorVsc.c
index 05a58a9..b8d5c23 100644
--- a/drivers/staging/hv/StorVsc.c
+++ b/drivers/staging/hv/StorVsc.c
@@ -51,7 +51,7 @@ struct storvsc_device {
 	atomic_t NumOutstandingRequests;
 
 	/*
-	 * Each unique Port/Path/Target represents 1 channel ie scsi
+	 * Each unique Port/Path/Target represents 1 channel i.e. scsi
 	 * controller. In reality, the pathid, targetid is always 0
 	 * and the port is set by us
 	 */
@@ -88,7 +88,7 @@ static inline struct storvsc_device *AllocStorDevice(struct hv_device *Device)
 		return NULL;
 
 	/* Set to 2 to allow both inbound and outbound traffics */
-	/* (ie GetStorDevice() and MustGetStorDevice()) to proceed. */
+	/* (i.e. GetStorDevice() and MustGetStorDevice()) to proceed. */
 	atomic_cmpxchg(&storDevice->RefCount, 0, 2);
 
 	storDevice->Device = Device;
@@ -559,7 +559,7 @@ static int StorVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 	/*
 	 * If we support more than 1 scsi channel, we need to set the
 	 * port number here to the scsi channel but how do we get the
-	 * scsi channel prior to the bus scan
+	 * scsi channel prior to the bus scan?
 	 */
 
 	/* storChannel->PortNumber = 0;
@@ -599,7 +599,7 @@ static int StorVscOnDeviceRemove(struct hv_device *Device)
 	storDevice = ReleaseStorDevice(Device);
 
 	/*
-	 * At this point, all outbound traffic should be disable. We
+	 * At this point, all outbound traffic should be disabled. We
 	 * only allow inbound traffic (responses) to proceed so that
 	 * outstanding requests can be completed.
 	 */
@@ -673,7 +673,7 @@ static int StorVscOnHostReset(struct hv_device *Device)
 
 	/*
 	 * At this point, all outstanding requests in the adapter
-	 * should have been flushed out and return to us
+	 * should have been flushed out and returned to us
 	 */
 
 Cleanup:
diff --git a/drivers/staging/hv/Vmbus.c b/drivers/staging/hv/Vmbus.c
index c65b843..91884a0 100644
--- a/drivers/staging/hv/Vmbus.c
+++ b/drivers/staging/hv/Vmbus.c
@@ -102,7 +102,7 @@ int VmbusChildDeviceAdd(struct hv_device *ChildDevice)
 }
 
 /**
- * VmbusChildDeviceRemove Unregisters the child device from the vmbus
+ * VmbusChildDeviceRemove - Unregisters the child device from the vmbus
  */
 void VmbusChildDeviceRemove(struct hv_device *ChildDevice)
 {
@@ -169,7 +169,7 @@ static void VmbusOnCleanup(struct hv_driver *drv)
 }
 
 /**
- * VmbusOnMsgDPC - DPC routine to handle messages from the hypervisior
+ * VmbusOnMsgDPC - DPC routine to handle messages from the hypervisor
  */
 static void VmbusOnMsgDPC(struct hv_driver *drv)
 {
@@ -196,7 +196,7 @@ static void VmbusOnMsgDPC(struct hv_driver *drv)
 		msg->Header.MessageType = HvMessageTypeNone;
 
 		/*
-		 * Make sure the write to MessageType (ie set to
+		 * Make sure the write to MessageType (i.e. set to
 		 * HvMessageTypeNone) happens before we read the
 		 * MessagePending and EOMing. Otherwise, the EOMing
 		 * will not deliver any more messages since there is
@@ -239,7 +239,7 @@ static int VmbusOnISR(struct hv_driver *drv)
 
 	DPRINT_ENTER(VMBUS);
 
-	/* Check if there are actual msgs to be process */
+	/* Check if there are actual msgs to be processed */
 	if (msg->Header.MessageType != HvMessageTypeNone) {
 		DPRINT_DBG(VMBUS, "received msg type %d size %d",
 				msg->Header.MessageType,
@@ -247,7 +247,7 @@ static int VmbusOnISR(struct hv_driver *drv)
 		ret |= 0x1;
 	}
 
-	/* TODO: Check if there are events to be process */
+	/* TODO: Check if there are events to be processed */
 	page_addr = gHvContext.synICEventPage[0];
 	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
 
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 99c4926..e8f5ea4 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -491,7 +491,7 @@ static int blkvsc_do_flush(struct block_device_context *blkdev)
 	return 0;
 }
 
-/* Do a scsi INQUIRY cmd here to get the device type (ie disk or dvd) */
+/* Do a scsi INQUIRY cmd here to get the device type (i.e. disk or dvd) */
 static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 {
 	struct blkvsc_request *blkvsc_req;
@@ -543,7 +543,7 @@ static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 	buf = kmap(page_buf);
 
 	/* print_hex_dump_bytes("", DUMP_PREFIX_NONE, buf, 64); */
-	/* be to le */
+	/* big-endian to little-endian */
 	device_type = buf[0] & 0x1F;
 
 	if (device_type == 0x0) {
@@ -637,7 +637,7 @@ static int blkvsc_do_read_capacity(struct block_device_context *blkdev)
 	}
 	buf = kmap(page_buf);
 
-	/* be to le */
+	/* big-endian to little-endian */
 	blkdev->capacity = ((buf[0] << 24) | (buf[1] << 16) |
 			    (buf[2] << 8) | buf[3]) + 1;
 	blkdev->sector_size = (buf[4] << 24) | (buf[5] << 16) |
@@ -713,7 +713,7 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 	}
 	buf = kmap(page_buf);
 
-	/* be to le */
+	/* big-endian to little-endian */
 	blkdev->capacity = be64_to_cpu(*(unsigned long long *) &buf[0]) + 1;
 	blkdev->sector_size = be32_to_cpu(*(unsigned int *)&buf[8]);
 
@@ -921,7 +921,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 
 /*
  * We break the request into 1 or more blkvsc_requests and submit
- * them.  If we cant submit them all, we put them on the
+ * them.  If we can't submit them all, we put them on the
  * pending_list. The blkvsc_request() will work on the pending_list.
  */
 static int blkvsc_do_request(struct block_device_context *blkdev,
@@ -971,7 +971,7 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 				    (databuf_idx >= MAX_MULTIPAGE_BUFFER_COUNT)
 				    /* hole at the begin of page */
 				    || (bvec->bv_offset != 0) ||
-				    /* hold at the end of page */
+				    /* hole at the end of page */
 				    (prev_bvec &&
 				     (prev_bvec->bv_len != PAGE_SIZE))) {
 					/* submit the prev one */
@@ -1155,8 +1155,8 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 				(!comp_req->request.Status ? 0 : -EIO),
 				comp_req->sector_count * blkdev->sector_size)) {
 				/*
-				 * All the sectors have been xferred ie the
-				 * request is done
+				 * All the sectors have been xferred (the
+				 * request is done)
 				 */
 				DPRINT_DBG(BLKVSC_DRV, "req %p COMPLETED\n",
 					   comp_req->req);
@@ -1231,7 +1231,7 @@ static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
 					       pend_req->sector_count *
 					       blkdev->sector_size)) {
 				/*
-				 * All the sectors have been xferred ie the
+				 * All the sectors have been xferred i.e. the
 				 * request is done
 				 */
 				DPRINT_DBG(BLKVSC_DRV,
diff --git a/drivers/staging/hv/hv_api.h b/drivers/staging/hv/hv_api.h
index 251e2d1..228b76b 100644
--- a/drivers/staging/hv/hv_api.h
+++ b/drivers/staging/hv/hv_api.h
@@ -854,7 +854,7 @@ struct hv_input_signal_event {
 
 /*
  * Versioning definitions used for guests reporting themselves to the
- * hypervisor, and visa versa.
+ * hypervisor, and vice versa.
  */
 
 /* Version info reported by guest OS's */
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 3192d50..774afbe 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -437,7 +437,7 @@ static int netvsc_probe(struct device *device)
 	}
 
 	/*
-	 * If carrier is still off ie we did not get a link status callback,
+	 * If carrier is still off i.e. we did not get a link status callback,
 	 * update it if necessary
 	 */
 	/*
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index d49dc21..55c4b35 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -127,7 +127,7 @@ static struct scsi_host_template scsi_driver = {
 	 * PAGE_SIZE, otherwise we may get 1 sg element that represents
 	 * multiple
 	 */
-	/* physically contig pfns (ie sg[x].length > PAGE_SIZE). */
+	/* physically contig pfns (i.e. sg[x].length > PAGE_SIZE). */
 	.use_clustering =	ENABLE_CLUSTERING,
 	/* Make sure we dont get a sg segment crosses a page boundary */
 	.dma_boundary =		PAGE_SIZE-1,
@@ -508,7 +508,7 @@ static void destroy_bounce_buffer(struct scatterlist *sgl,
 	kfree(sgl);
 }
 
-/* Assume the bounce_sgl has enough room ie using the create_bounce_buffer() */
+/* Assume the bounce_sgl has enough room i.e. using the create_bounce_buffer() */
 static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 					  struct scatterlist *bounce_sgl,
 					  unsigned int orig_sgl_count)
@@ -841,7 +841,7 @@ static int storvsc_device_alloc(struct scsi_device *sdevice)
 		   sdevice, BLIST_SPARSELUN);
 	/*
 	 * This enables luns to be located sparsely. Otherwise, we may not
-	 * discovered them.
+	 * discover them.
 	 */
 	sdevice->sdev_bflags |= BLIST_SPARSELUN | BLIST_LARGELUN;
 	return 0;
@@ -974,7 +974,7 @@ static void storvsc_host_rescan_callback(struct work_struct *work)
 
 	/* Rescan for devices that may have been removed.
 	 * We do not have to worry that new devices may have been added since
-	 * this callback is serialized by the workqueue ie add/remove are done
+	 * this callback is serialized by the workqueue i.e. add/remove are done
 	 * here.
 	 */
 	shost_for_each_device(sdev, host) {
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 582318f..78d4b63 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -421,7 +421,7 @@ int vmbus_child_driver_register(struct driver_context *driver_ctx)
 EXPORT_SYMBOL(vmbus_child_driver_register);
 
 /**
- * vmbus_child_driver_unregister Unregister a vmbus's child driver
+ * vmbus_child_driver_unregister - Unregister a vmbus's child driver
  */
 void vmbus_child_driver_unregister(struct driver_context *driver_ctx)
 {
@@ -548,7 +548,7 @@ static int vmbus_child_device_register(struct hv_device *root_device_obj,
 		goto Cleanup;
 	}
 
-	/* Set the device bus id. Otherwise, device_register()will fail. */
+	/* Set the device bus id. Otherwise, device_register() will fail. */
 	dev_set_name(&child_device_ctx->device, "vmbus_0_%d",
 		     atomic_inc_return(&device_num));
 
@@ -736,7 +736,7 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 /**
  * vmbus_probe_failed_cb - Callback when a driver probe failed in vmbus_probe()
  *
- * We need a callback because we cannot invoked device_unregister() inside
+ * We need a callback because we cannot invoke device_unregister() inside
  * vmbus_probe() since vmbus_probe() may be invoked inside device_register()
  * i.e. we cannot call device_unregister() inside device_register()
  */
@@ -948,7 +948,7 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	/* Call to bus driver to handle interrupt */
 	ret = vmbus_driver_obj->OnIsr(&vmbus_driver_obj->Base);
 
-	/* Schedules a dpc if necessary */
+	/* Schedules a DPC if necessary */
 	if (ret > 0) {
 		if (test_bit(0, (unsigned long *)&ret))
 			tasklet_schedule(&g_vmbus_drv.msg_dpc);
-- 
1.6.5.rc1
