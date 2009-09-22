Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbZIVFlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbZIVFlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbZIVFlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:41:11 -0400
Received: from dcent.unixwiz.net ([99.25.142.34]:48762 "EHLO dcent.unixwiz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564AbZIVFlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:41:11 -0400
Date: Mon, 21 Sep 2009 22:41:14 -0700
From: Steve Friedl <steve@unixwiz.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] staging: hv: Replaced |typedef RING_BUFFER_INFO| with |struct hv_ring_buffer_info|
Message-ID: <20090922054114.GA5976@dcent.unixwiz.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... second in a series of typedef fixes

~~~ Steve

Signed-off-by: Steve Friedl <steve@unixwiz.net>

---
 drivers/staging/hv/ChannelMgmt.h |    4 +-
 drivers/staging/hv/RingBuffer.c  |   44 +++++++++++++++++++-------------------
 drivers/staging/hv/RingBuffer.h  |   20 ++++++++--------
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/hv/ChannelMgmt.h b/drivers/staging/hv/ChannelMgmt.h
index a839d8f..407a2ee 100644
--- a/drivers/staging/hv/ChannelMgmt.h
+++ b/drivers/staging/hv/ChannelMgmt.h
@@ -246,8 +246,8 @@ struct vmbus_channel {
 	/* Allocated memory for ring buffer */
 	void *RingBufferPages;
 	u32 RingBufferPageCount;
-	RING_BUFFER_INFO Outbound;	/* send to parent */
-	RING_BUFFER_INFO Inbound;	/* receive from parent */
+	struct hv_ring_buffer_info Outbound;	/* send to parent */
+	struct hv_ring_buffer_info Inbound;	/* receive from parent */
 	spinlock_t inbound_lock;
 	struct workqueue_struct *ControlWQ;
 
diff --git a/drivers/staging/hv/RingBuffer.c b/drivers/staging/hv/RingBuffer.c
index ffd64ac..0a4076c 100644
--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -46,7 +46,7 @@ Description:
 
 --*/
 static inline void
-GetRingBufferAvailBytes(RING_BUFFER_INFO *rbi, u32 *read, u32 *write)
+GetRingBufferAvailBytes(struct hv_ring_buffer_info *rbi, u32 *read, u32 *write)
 {
 	u32 read_loc,write_loc;
 
@@ -68,7 +68,7 @@ Description:
 
 --*/
 static inline u32
-GetNextWriteLocation(RING_BUFFER_INFO* RingInfo)
+GetNextWriteLocation(struct hv_ring_buffer_info* RingInfo)
 {
 	u32 next = RingInfo->RingBuffer->WriteIndex;
 
@@ -87,7 +87,7 @@ Description:
 
 --*/
 static inline void
-SetNextWriteLocation(RING_BUFFER_INFO* RingInfo, u32 NextWriteLocation)
+SetNextWriteLocation(struct hv_ring_buffer_info* RingInfo, u32 NextWriteLocation)
 {
 	RingInfo->RingBuffer->WriteIndex = NextWriteLocation;
 }
@@ -102,7 +102,7 @@ Description:
 
 --*/
 static inline u32
-GetNextReadLocation(RING_BUFFER_INFO* RingInfo)
+GetNextReadLocation(struct hv_ring_buffer_info* RingInfo)
 {
 	u32 next = RingInfo->RingBuffer->ReadIndex;
 
@@ -122,7 +122,7 @@ Description:
 
 --*/
 static inline u32
-GetNextReadLocationWithOffset(RING_BUFFER_INFO* RingInfo, u32 Offset)
+GetNextReadLocationWithOffset(struct hv_ring_buffer_info* RingInfo, u32 Offset)
 {
 	u32 next = RingInfo->RingBuffer->ReadIndex;
 
@@ -143,7 +143,7 @@ Description:
 
 --*/
 static inline void
-SetNextReadLocation(RING_BUFFER_INFO* RingInfo, u32 NextReadLocation)
+SetNextReadLocation(struct hv_ring_buffer_info* RingInfo, u32 NextReadLocation)
 {
 	RingInfo->RingBuffer->ReadIndex = NextReadLocation;
 }
@@ -159,7 +159,7 @@ Description:
 
 --*/
 static inline void *
-GetRingBuffer(RING_BUFFER_INFO* RingInfo)
+GetRingBuffer(struct hv_ring_buffer_info* RingInfo)
 {
 	return (void *)RingInfo->RingBuffer->Buffer;
 }
@@ -175,7 +175,7 @@ Description:
 
 --*/
 static inline u32
-GetRingBufferSize(RING_BUFFER_INFO* RingInfo)
+GetRingBufferSize(struct hv_ring_buffer_info* RingInfo)
 {
 	return RingInfo->RingDataSize;
 }
@@ -190,7 +190,7 @@ Description:
 
 --*/
 static inline u64
-GetRingBufferIndices(RING_BUFFER_INFO* RingInfo)
+GetRingBufferIndices(struct hv_ring_buffer_info* RingInfo)
 {
 	return ((u64)RingInfo->RingBuffer->WriteIndex << 32) || RingInfo->RingBuffer->ReadIndex;
 }
@@ -205,7 +205,7 @@ Description:
 	Dump out to console the ring buffer info
 
 --*/
-void DumpRingInfo(RING_BUFFER_INFO *RingInfo, char *Prefix)
+void DumpRingInfo(struct hv_ring_buffer_info *RingInfo, char *Prefix)
 {
 	u32 bytesAvailToWrite;
 	u32 bytesAvailToRead;
@@ -227,14 +227,14 @@ void DumpRingInfo(RING_BUFFER_INFO *RingInfo, char *Prefix)
 
 static u32
 CopyToRingBuffer(
-	RING_BUFFER_INFO	*RingInfo,
+	struct hv_ring_buffer_info	*RingInfo,
 	u32				StartWriteOffset,
 	void *				Src,
 	u32				SrcLen);
 
 static u32
 CopyFromRingBuffer(
-	RING_BUFFER_INFO	*RingInfo,
+	struct hv_ring_buffer_info	*RingInfo,
 	void *				Dest,
 	u32				DestLen,
 	u32				StartReadOffset);
@@ -250,7 +250,7 @@ Description:
 	Get various debug metrics for the specified ring buffer
 
 --*/
-void RingBufferGetDebugInfo(RING_BUFFER_INFO *RingInfo,
+void RingBufferGetDebugInfo(struct hv_ring_buffer_info *RingInfo,
 			    RING_BUFFER_DEBUG_INFO *DebugInfo)
 {
 	u32 bytesAvailToWrite;
@@ -279,7 +279,7 @@ Description:
 	Get the interrupt mask for the specified ring buffer
 
 --*/
-u32 GetRingBufferInterruptMask(RING_BUFFER_INFO *rbi)
+u32 GetRingBufferInterruptMask(struct hv_ring_buffer_info *rbi)
 {
 	return rbi->RingBuffer->InterruptMask;
 }
@@ -293,11 +293,11 @@ Description:
 	Initialize the ring buffer
 
 --*/
-int RingBufferInit(RING_BUFFER_INFO *RingInfo, void *Buffer, u32 BufferLen)
+int RingBufferInit(struct hv_ring_buffer_info *RingInfo, void *Buffer, u32 BufferLen)
 {
 	ASSERT(sizeof(struct hv_ring_buffer) == PAGE_SIZE);
 
-	memset(RingInfo, 0, sizeof(RING_BUFFER_INFO));
+	memset(RingInfo, 0, sizeof(struct hv_ring_buffer_info));
 
 	RingInfo->RingBuffer = (struct hv_ring_buffer*)Buffer;
 	RingInfo->RingBuffer->ReadIndex = RingInfo->RingBuffer->WriteIndex = 0;
@@ -319,7 +319,7 @@ Description:
 	Cleanup the ring buffer
 
 --*/
-void RingBufferCleanup(RING_BUFFER_INFO* RingInfo)
+void RingBufferCleanup(struct hv_ring_buffer_info* RingInfo)
 {
 }
 
@@ -332,7 +332,7 @@ Description:
 	Write to the ring buffer
 
 --*/
-int RingBufferWrite(RING_BUFFER_INFO *OutRingInfo,
+int RingBufferWrite(struct hv_ring_buffer_info *OutRingInfo,
 		    struct scatterlist *sglist, u32 sgcount)
 {
 	int i=0;
@@ -419,7 +419,7 @@ Description:
 	Read without advancing the read index
 
 --*/
-int RingBufferPeek(RING_BUFFER_INFO *InRingInfo, void *Buffer, u32 BufferLen)
+int RingBufferPeek(struct hv_ring_buffer_info *InRingInfo, void *Buffer, u32 BufferLen)
 {
 	u32 bytesAvailToWrite;
 	u32 bytesAvailToRead;
@@ -463,7 +463,7 @@ Description:
 	Read and advance the read index
 
 --*/
-int RingBufferRead(RING_BUFFER_INFO *InRingInfo, void *Buffer,
+int RingBufferRead(struct hv_ring_buffer_info *InRingInfo, void *Buffer,
 		   u32 BufferLen, u32 Offset)
 {
 	u32 bytesAvailToWrite;
@@ -531,7 +531,7 @@ Description:
 --*/
 static u32
 CopyToRingBuffer(
-	RING_BUFFER_INFO	*RingInfo,
+	struct hv_ring_buffer_info	*RingInfo,
 	u32				StartWriteOffset,
 	void *				Src,
 	u32				SrcLen)
@@ -572,7 +572,7 @@ Description:
 --*/
 static u32
 CopyFromRingBuffer(
-	RING_BUFFER_INFO	*RingInfo,
+	struct hv_ring_buffer_info	*RingInfo,
 	void *				Dest,
 	u32				DestLen,
 	u32				StartReadOffset)
diff --git a/drivers/staging/hv/RingBuffer.h b/drivers/staging/hv/RingBuffer.h
index 1ea2ced..6580156 100644
--- a/drivers/staging/hv/RingBuffer.h
+++ b/drivers/staging/hv/RingBuffer.h
@@ -53,7 +53,7 @@ struct hv_ring_buffer {
 	u8 Buffer[0];
 } __attribute__((packed));
 
-typedef struct _RING_BUFFER_INFO {
+struct hv_ring_buffer_info {
 	struct hv_ring_buffer *RingBuffer;
 	u32 RingSize;			/* Include the shared header */
 	spinlock_t ring_lock;
@@ -61,7 +61,7 @@ typedef struct _RING_BUFFER_INFO {
 	u32 RingDataSize;		/* < ringSize */
 	u32 RingDataStartOffset;
 
-} RING_BUFFER_INFO;
+};
 
 typedef struct _RING_BUFFER_DEBUG_INFO {
 	u32 CurrentInterruptMask;
@@ -76,26 +76,26 @@ typedef struct _RING_BUFFER_DEBUG_INFO {
 /* Interface */
 
 
-int RingBufferInit(RING_BUFFER_INFO *RingInfo, void *Buffer, u32 BufferLen);
+int RingBufferInit(struct hv_ring_buffer_info *RingInfo, void *Buffer, u32 BufferLen);
 
-void RingBufferCleanup(RING_BUFFER_INFO *RingInfo);
+void RingBufferCleanup(struct hv_ring_buffer_info *RingInfo);
 
-int RingBufferWrite(RING_BUFFER_INFO *RingInfo,
+int RingBufferWrite(struct hv_ring_buffer_info *RingInfo,
 		    struct scatterlist *sglist,
 		    u32 sgcount);
 
-int RingBufferPeek(RING_BUFFER_INFO *RingInfo, void *Buffer, u32 BufferLen);
+int RingBufferPeek(struct hv_ring_buffer_info *RingInfo, void *Buffer, u32 BufferLen);
 
-int RingBufferRead(RING_BUFFER_INFO *RingInfo,
+int RingBufferRead(struct hv_ring_buffer_info *RingInfo,
 		   void *Buffer,
 		   u32 BufferLen,
 		   u32 Offset);
 
-u32 GetRingBufferInterruptMask(RING_BUFFER_INFO *RingInfo);
+u32 GetRingBufferInterruptMask(struct hv_ring_buffer_info *RingInfo);
 
-void DumpRingInfo(RING_BUFFER_INFO *RingInfo, char *Prefix);
+void DumpRingInfo(struct hv_ring_buffer_info *RingInfo, char *Prefix);
 
-void RingBufferGetDebugInfo(RING_BUFFER_INFO *RingInfo,
+void RingBufferGetDebugInfo(struct hv_ring_buffer_info *RingInfo,
 			    RING_BUFFER_DEBUG_INFO *DebugInfo);
 
 #endif /* _RING_BUFFER_H_ */
-- 
1.6.5.rc1
