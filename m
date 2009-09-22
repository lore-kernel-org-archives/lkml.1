Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZIVFkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZIVFkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbZIVFkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:40:22 -0400
Received: from dcent.unixwiz.net ([99.25.142.34]:48761 "EHLO dcent.unixwiz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbZIVFkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:40:22 -0400
Date: Mon, 21 Sep 2009 22:40:26 -0700
From: Steve Friedl <steve@unixwiz.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] staging: hv: Changed |typedef RING_BUFFER| to |struct hv_ring_buffer| throughout.
Message-ID: <20090922054026.GA5959@dcent.unixwiz.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The style guide (and Greg's prior work) have suggested that the typedef
UPPERCASENAME style is not appropriate in the Linux kernel (even though
it's been de rigueur in Win32 development for 20 years), so I'm fixing
a couple more of them that remain... one at a time.

~~~ Steve

Signed-off-by: Steve Friedl <steve@unixwiz.net>

---
 drivers/staging/hv/RingBuffer.c |    6 +++---
 drivers/staging/hv/RingBuffer.h |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/RingBuffer.c b/drivers/staging/hv/RingBuffer.c
index f69ae33..ffd64ac 100644
--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -295,15 +295,15 @@ Description:
 --*/
 int RingBufferInit(RING_BUFFER_INFO *RingInfo, void *Buffer, u32 BufferLen)
 {
-	ASSERT(sizeof(RING_BUFFER) == PAGE_SIZE);
+	ASSERT(sizeof(struct hv_ring_buffer) == PAGE_SIZE);
 
 	memset(RingInfo, 0, sizeof(RING_BUFFER_INFO));
 
-	RingInfo->RingBuffer = (RING_BUFFER*)Buffer;
+	RingInfo->RingBuffer = (struct hv_ring_buffer*)Buffer;
 	RingInfo->RingBuffer->ReadIndex = RingInfo->RingBuffer->WriteIndex = 0;
 
 	RingInfo->RingSize = BufferLen;
-	RingInfo->RingDataSize = BufferLen - sizeof(RING_BUFFER);
+	RingInfo->RingDataSize = BufferLen - sizeof(struct hv_ring_buffer);
 
 	spin_lock_init(&RingInfo->ring_lock);
 
diff --git a/drivers/staging/hv/RingBuffer.h b/drivers/staging/hv/RingBuffer.h
index 6202157..1ea2ced 100644
--- a/drivers/staging/hv/RingBuffer.h
+++ b/drivers/staging/hv/RingBuffer.h
@@ -27,7 +27,7 @@
 
 #include <linux/scatterlist.h>
 
-typedef struct _RING_BUFFER {
+struct hv_ring_buffer {
 	/* Offset in bytes from the start of ring data below */
 	volatile u32 WriteIndex;
 
@@ -51,10 +51,10 @@ typedef struct _RING_BUFFER {
 	 * !!! DO NOT place any fields below this !!!
 	 */
 	u8 Buffer[0];
-} __attribute__((packed)) RING_BUFFER;
+} __attribute__((packed));
 
 typedef struct _RING_BUFFER_INFO {
-	RING_BUFFER *RingBuffer;
+	struct hv_ring_buffer *RingBuffer;
 	u32 RingSize;			/* Include the shared header */
 	spinlock_t ring_lock;
 
-- 
1.6.5.rc1
