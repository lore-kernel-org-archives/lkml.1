Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0BCPei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:34:38 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:59959 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab0BCPee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:34:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=AoMGCR+EeV58dCPp01aVuL7f4MSpl5GWy3yykVqdawXQRy68ZwOEqErBWXzauuGAEj
         u/Ip4UR9KkNN66xuR6zF22GNi1mg/4ZC+MEaMOHCYNkabuy7Yrquotz2qJkC8RL/pVDc
         GMyJ/hwCFrThrDMcqOVUdz2+MhFgIimDIWbYc=
Subject: [PATCH] Staging: hv: fix various coding style issues in
 RingBuffer.c
From: CB <c.bartlett.crb@googlemail.com>
To: gregkh@suse.de
Cc: wfp5p@virginia.edu, npalix@diku.dk, hjanssen@microsoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 15:34:27 +0000
Message-ID: <1265211267.24459.11.camel@pcgfx805-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a545464b8c98ca1f2b35b6b701842bca16a6cccf Mon Sep 17 00:00:00 2001
From: C. Bartlett <c-bartlett@hotmail.co.uk>
Date: Wed, 3 Feb 2010 15:08:17 +0000
Subject: [PATCH] Staging: hv: fix various coding style issues in RingBuffer.c
 This is a patch to the RingBuffer.c file that corrects various coding style  warnings and errors found by checkpatch.pl
 Signed-off-by: Craig Bartlett <c-bartlett@hotmail.co.uk>

---
 drivers/staging/hv/RingBuffer.c |  153 ++++++++++++++++++++++-----------------
 1 files changed, 86 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/hv/RingBuffer.c b/drivers/staging/hv/RingBuffer.c
index f69ae33..80b8a2c 100644
--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -48,7 +48,7 @@ Description:
 static inline void
 GetRingBufferAvailBytes(RING_BUFFER_INFO *rbi, u32 *read, u32 *write)
 {
-	u32 read_loc,write_loc;
+	u32 read_loc, write_loc;
 
 	/* Capture the read/write indices before they changed */
 	read_loc = rbi->RingBuffer->ReadIndex;
@@ -68,7 +68,7 @@ Description:
 
 --*/
 static inline u32
-GetNextWriteLocation(RING_BUFFER_INFO* RingInfo)
+GetNextWriteLocation(RING_BUFFER_INFO *RingInfo)
 {
 	u32 next = RingInfo->RingBuffer->WriteIndex;
 
@@ -87,7 +87,7 @@ Description:
 
 --*/
 static inline void
-SetNextWriteLocation(RING_BUFFER_INFO* RingInfo, u32 NextWriteLocation)
+SetNextWriteLocation(RING_BUFFER_INFO *RingInfo, u32 NextWriteLocation)
 {
 	RingInfo->RingBuffer->WriteIndex = NextWriteLocation;
 }
@@ -102,7 +102,7 @@ Description:
 
 --*/
 static inline u32
-GetNextReadLocation(RING_BUFFER_INFO* RingInfo)
+GetNextReadLocation(RING_BUFFER_INFO *RingInfo)
 {
 	u32 next = RingInfo->RingBuffer->ReadIndex;
 
@@ -122,7 +122,7 @@ Description:
 
 --*/
 static inline u32
-GetNextReadLocationWithOffset(RING_BUFFER_INFO* RingInfo, u32 Offset)
+GetNextReadLocationWithOffset(RING_BUFFER_INFO *RingInfo, u32 Offset)
 {
 	u32 next = RingInfo->RingBuffer->ReadIndex;
 
@@ -143,7 +143,7 @@ Description:
 
 --*/
 static inline void
-SetNextReadLocation(RING_BUFFER_INFO* RingInfo, u32 NextReadLocation)
+SetNextReadLocation(RING_BUFFER_INFO *RingInfo, u32 NextReadLocation)
 {
 	RingInfo->RingBuffer->ReadIndex = NextReadLocation;
 }
@@ -159,7 +159,7 @@ Description:
 
 --*/
 static inline void *
-GetRingBuffer(RING_BUFFER_INFO* RingInfo)
+GetRingBuffer(RING_BUFFER_INFO *RingInfo)
 {
 	return (void *)RingInfo->RingBuffer->Buffer;
 }
@@ -175,7 +175,7 @@ Description:
 
 --*/
 static inline u32
-GetRingBufferSize(RING_BUFFER_INFO* RingInfo)
+GetRingBufferSize(RING_BUFFER_INFO *RingInfo)
 {
 	return RingInfo->RingDataSize;
 }
@@ -190,9 +190,10 @@ Description:
 
 --*/
 static inline u64
-GetRingBufferIndices(RING_BUFFER_INFO* RingInfo)
+GetRingBufferIndices(RING_BUFFER_INFO *RingInfo)
 {
-	return ((u64)RingInfo->RingBuffer->WriteIndex << 32) || RingInfo->RingBuffer->ReadIndex;
+	return ((u64)RingInfo->RingBuffer->WriteIndex << 32)
+	|| RingInfo->RingBuffer->ReadIndex;
 }
 
 
@@ -210,9 +211,14 @@ void DumpRingInfo(RING_BUFFER_INFO *RingInfo, char *Prefix)
 	u32 bytesAvailToWrite;
 	u32 bytesAvailToRead;
 
-	GetRingBufferAvailBytes(RingInfo, &bytesAvailToRead, &bytesAvailToWrite);
+	GetRingBufferAvailBytes(RingInfo,
+	&bytesAvailToRead,
+	&bytesAvailToWrite);
 
-	DPRINT(VMBUS, DEBUG_RING_LVL, "%s <<ringinfo %p buffer %p avail write %u avail read %u read idx %u write idx %u>>",
+	DPRINT(VMBUS,
+		DEBUG_RING_LVL,
+		"%s <<ringinfo %p buffer %p avail write %u "
+		"avail read %u read idx %u write idx %u>>",
 		Prefix,
 		RingInfo,
 		RingInfo->RingBuffer->Buffer,
@@ -229,13 +235,13 @@ static u32
 CopyToRingBuffer(
 	RING_BUFFER_INFO	*RingInfo,
 	u32				StartWriteOffset,
-	void *				Src,
+	void				*Src,
 	u32				SrcLen);
 
 static u32
 CopyFromRingBuffer(
 	RING_BUFFER_INFO	*RingInfo,
-	void *				Dest,
+	void				*Dest,
 	u32				DestLen,
 	u32				StartReadOffset);
 
@@ -256,15 +262,15 @@ void RingBufferGetDebugInfo(RING_BUFFER_INFO *RingInfo,
 	u32 bytesAvailToWrite;
 	u32 bytesAvailToRead;
 
-	if (RingInfo->RingBuffer)
-	{
-		GetRingBufferAvailBytes(RingInfo, &bytesAvailToRead, &bytesAvailToWrite);
+	if (RingInfo->RingBuffer) {
+		GetRingBufferAvailBytes(RingInfo,
+					&bytesAvailToRead,
+					&bytesAvailToWrite);
 
 		DebugInfo->BytesAvailToRead = bytesAvailToRead;
 		DebugInfo->BytesAvailToWrite = bytesAvailToWrite;
 		DebugInfo->CurrentReadIndex = RingInfo->RingBuffer->ReadIndex;
 		DebugInfo->CurrentWriteIndex = RingInfo->RingBuffer->WriteIndex;
-
 		DebugInfo->CurrentInterruptMask = RingInfo->RingBuffer->InterruptMask;
 	}
 }
@@ -299,7 +305,7 @@ int RingBufferInit(RING_BUFFER_INFO *RingInfo, void *Buffer, u32 BufferLen)
 
 	memset(RingInfo, 0, sizeof(RING_BUFFER_INFO));
 
-	RingInfo->RingBuffer = (RING_BUFFER*)Buffer;
+	RingInfo->RingBuffer = (RING_BUFFER *)Buffer;
 	RingInfo->RingBuffer->ReadIndex = RingInfo->RingBuffer->WriteIndex = 0;
 
 	RingInfo->RingSize = BufferLen;
@@ -319,7 +325,7 @@ Description:
 	Cleanup the ring buffer
 
 --*/
-void RingBufferCleanup(RING_BUFFER_INFO* RingInfo)
+void RingBufferCleanup(RING_BUFFER_INFO *RingInfo)
 {
 }
 
@@ -335,14 +341,14 @@ Description:
 int RingBufferWrite(RING_BUFFER_INFO *OutRingInfo,
 		    struct scatterlist *sglist, u32 sgcount)
 {
-	int i=0;
+	int i = 0;
 	u32 byteAvailToWrite;
 	u32 byteAvailToRead;
-	u32 totalBytesToWrite=0;
+	u32 totalBytesToWrite = 0;
 
 	struct scatterlist *sg;
 	volatile u32 nextWriteLocation;
-	u64 prevIndices=0;
+	u64 prevIndices = 0;
 	unsigned long flags;
 
 	DPRINT_ENTER(VMBUS);
@@ -356,17 +362,23 @@ int RingBufferWrite(RING_BUFFER_INFO *OutRingInfo,
 
 	spin_lock_irqsave(&OutRingInfo->ring_lock, flags);
 
-	GetRingBufferAvailBytes(OutRingInfo, &byteAvailToRead, &byteAvailToWrite);
+	GetRingBufferAvailBytes(OutRingInfo,
+				&byteAvailToRead,
+				&byteAvailToWrite);
 
 	DPRINT_DBG(VMBUS, "Writing %u bytes...", totalBytesToWrite);
 
 	/* DumpRingInfo(OutRingInfo, "BEFORE "); */
 
-	/* If there is only room for the packet, assume it is full. Otherwise, the next time around, we think the ring buffer */
+	/* If there is only room for the packet, assume it is full. */
+	/* Otherwise, the next time around, we think the ring buffer */
 	/* is empty since the read index == write index */
-	if (byteAvailToWrite <= totalBytesToWrite)
-	{
-		DPRINT_DBG(VMBUS, "No more space left on outbound ring buffer (needed %u, avail %u)", totalBytesToWrite, byteAvailToWrite);
+	if (byteAvailToWrite <= totalBytesToWrite) {
+		DPRINT_DBG(VMBUS,
+			"No more space left on outbound ring buffer "
+			"(needed %u, avail %u)",
+			totalBytesToWrite,
+			byteAvailToWrite);
 
 		spin_unlock_irqrestore(&OutRingInfo->ring_lock, flags);
 
@@ -423,17 +435,22 @@ int RingBufferPeek(RING_BUFFER_INFO *InRingInfo, void *Buffer, u32 BufferLen)
 {
 	u32 bytesAvailToWrite;
 	u32 bytesAvailToRead;
-	u32 nextReadLocation=0;
+	u32 nextReadLocation = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&InRingInfo->ring_lock, flags);
 
-	GetRingBufferAvailBytes(InRingInfo, &bytesAvailToRead, &bytesAvailToWrite);
+	GetRingBufferAvailBytes(InRingInfo,
+				&bytesAvailToRead,
+				&bytesAvailToWrite);
 
 	/* Make sure there is something to read */
-	if (bytesAvailToRead < BufferLen )
-	{
-		/* DPRINT_DBG(VMBUS, "got callback but not enough to read <avail to read %d read size %d>!!", bytesAvailToRead, BufferLen); */
+	if (bytesAvailToRead < BufferLen) {
+		/* DPRINT_DBG(VMBUS,
+			"got callback but not enough to read "
+			"<avail to read %d read size %d>!!",
+			bytesAvailToRead,
+			BufferLen); */
 
 		spin_unlock_irqrestore(&InRingInfo->ring_lock, flags);
 
@@ -444,9 +461,9 @@ int RingBufferPeek(RING_BUFFER_INFO *InRingInfo, void *Buffer, u32 BufferLen)
 	nextReadLocation = GetNextReadLocation(InRingInfo);
 
 	nextReadLocation = CopyFromRingBuffer(InRingInfo,
-											Buffer,
-											BufferLen,
-											nextReadLocation);
+						Buffer,
+						BufferLen,
+						nextReadLocation);
 
 	spin_unlock_irqrestore(&InRingInfo->ring_lock, flags);
 
@@ -468,24 +485,29 @@ int RingBufferRead(RING_BUFFER_INFO *InRingInfo, void *Buffer,
 {
 	u32 bytesAvailToWrite;
 	u32 bytesAvailToRead;
-	u32 nextReadLocation=0;
-	u64 prevIndices=0;
+	u32 nextReadLocation = 0;
+	u64 prevIndices = 0;
 	unsigned long flags;
 
 	ASSERT(BufferLen > 0);
 
 	spin_lock_irqsave(&InRingInfo->ring_lock, flags);
 
-	GetRingBufferAvailBytes(InRingInfo, &bytesAvailToRead, &bytesAvailToWrite);
+	GetRingBufferAvailBytes(InRingInfo,
+				&bytesAvailToRead,
+				&bytesAvailToWrite);
 
 	DPRINT_DBG(VMBUS, "Reading %u bytes...", BufferLen);
 
 	/* DumpRingInfo(InRingInfo, "BEFORE "); */
 
 	/* Make sure there is something to read */
-	if (bytesAvailToRead < BufferLen )
-	{
-		DPRINT_DBG(VMBUS, "got callback but not enough to read <avail to read %d read size %d>!!", bytesAvailToRead, BufferLen);
+	if (bytesAvailToRead < BufferLen) {
+		DPRINT_DBG(VMBUS,
+			"got callback but not enough to read "
+			"<avail to read %d read size %d>!!",
+			bytesAvailToRead,
+			BufferLen);
 
 		spin_unlock_irqrestore(&InRingInfo->ring_lock, flags);
 
@@ -495,17 +517,18 @@ int RingBufferRead(RING_BUFFER_INFO *InRingInfo, void *Buffer,
 	nextReadLocation = GetNextReadLocationWithOffset(InRingInfo, Offset);
 
 	nextReadLocation = CopyFromRingBuffer(InRingInfo,
-											Buffer,
-											BufferLen,
-											nextReadLocation);
+						Buffer,
+						BufferLen,
+						nextReadLocation);
 
 	nextReadLocation = CopyFromRingBuffer(InRingInfo,
-											&prevIndices,
-											sizeof(u64),
-											nextReadLocation);
+						&prevIndices,
+						sizeof(u64),
+						nextReadLocation);
 
 	/* Make sure all reads are done before we update the read index since */
-	/* the writer may start writing to the read area once the read index is updated */
+	/* the writer may start writing to the read area once the read index */
+	/*is updated */
 	mb();
 
 	/* Update the read index */
@@ -533,25 +556,22 @@ static u32
 CopyToRingBuffer(
 	RING_BUFFER_INFO	*RingInfo,
 	u32				StartWriteOffset,
-	void *				Src,
+	void				*Src,
 	u32				SrcLen)
 {
-	void * ringBuffer=GetRingBuffer(RingInfo);
-	u32 ringBufferSize=GetRingBufferSize(RingInfo);
+	void *ringBuffer = GetRingBuffer(RingInfo);
+	u32 ringBufferSize = GetRingBufferSize(RingInfo);
 	u32 fragLen;
 
-	if (SrcLen > ringBufferSize - StartWriteOffset) /* wrap-around detected! */
-	{
+	/* wrap-around detected! */
+	if (SrcLen > ringBufferSize - StartWriteOffset) {
 		DPRINT_DBG(VMBUS, "wrap-around detected!");
 
 		fragLen = ringBufferSize - StartWriteOffset;
 		memcpy(ringBuffer + StartWriteOffset, Src, fragLen);
 		memcpy(ringBuffer, Src + fragLen, SrcLen - fragLen);
-	}
-	else
-	{
+	} else
 		memcpy(ringBuffer + StartWriteOffset, Src, SrcLen);
-	}
 
 	StartWriteOffset += SrcLen;
 	StartWriteOffset %= ringBufferSize;
@@ -573,28 +593,27 @@ Description:
 static u32
 CopyFromRingBuffer(
 	RING_BUFFER_INFO	*RingInfo,
-	void *				Dest,
+	void				*Dest,
 	u32				DestLen,
 	u32				StartReadOffset)
 {
-	void * ringBuffer=GetRingBuffer(RingInfo);
-	u32 ringBufferSize=GetRingBufferSize(RingInfo);
+	void *ringBuffer = GetRingBuffer(RingInfo);
+	u32 ringBufferSize = GetRingBufferSize(RingInfo);
 
 	u32 fragLen;
 
-	if (DestLen > ringBufferSize - StartReadOffset) /* wrap-around detected at the src */
-	{
+	/* wrap-around detected at the src */
+	if (DestLen > ringBufferSize - StartReadOffset) {
 		DPRINT_DBG(VMBUS, "src wrap-around detected!");
 
 		fragLen = ringBufferSize - StartReadOffset;
 
 		memcpy(Dest, ringBuffer + StartReadOffset, fragLen);
 		memcpy(Dest + fragLen, ringBuffer, DestLen - fragLen);
-	}
-	else
-	{
+	} else
+
 		memcpy(Dest, ringBuffer + StartReadOffset, DestLen);
-	}
+
 
 	StartReadOffset += DestLen;
 	StartReadOffset %= ringBufferSize;
-- 
1.6.3.3



