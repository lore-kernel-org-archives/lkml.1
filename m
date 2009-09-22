Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZIVFly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZIVFly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbZIVFlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:41:44 -0400
Received: from dcent.unixwiz.net ([99.25.142.34]:48763 "EHLO dcent.unixwiz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbZIVFln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:41:43 -0400
Date: Mon, 21 Sep 2009 22:41:47 -0700
From: Steve Friedl <steve@unixwiz.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] staging: hv: Renamed |typedef RING_BUFFER_DEBUG_INFO| to |struct hv_ring_buffer_debug_info|
Message-ID: <20090922054147.GA5988@dcent.unixwiz.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... last of the RingBuffer.c typedef fixes

~~~ Steve

Signed-off-by: Steve Friedl <steve@unixwiz.net>

---
 drivers/staging/hv/ChannelMgmt.h |    4 ++--
 drivers/staging/hv/RingBuffer.c  |    2 +-
 drivers/staging/hv/RingBuffer.h  |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/ChannelMgmt.h b/drivers/staging/hv/ChannelMgmt.h
index 407a2ee..2f398d2 100644
--- a/drivers/staging/hv/ChannelMgmt.h
+++ b/drivers/staging/hv/ChannelMgmt.h
@@ -271,8 +271,8 @@ struct vmbus_channel_debug_info {
 	u32 ClientMonitorLatency;
 	u32 ClientMonitorConnectionId;
 
-	RING_BUFFER_DEBUG_INFO Inbound;
-	RING_BUFFER_DEBUG_INFO Outbound;
+	struct hv_ring_buffer_debug_info Inbound;
+	struct hv_ring_buffer_debug_info Outbound;
 };
 
 /*
diff --git a/drivers/staging/hv/RingBuffer.c b/drivers/staging/hv/RingBuffer.c
index 0a4076c..c50c447 100644
--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -251,7 +251,7 @@ Description:
 
 --*/
 void RingBufferGetDebugInfo(struct hv_ring_buffer_info *RingInfo,
-			    RING_BUFFER_DEBUG_INFO *DebugInfo)
+			    struct hv_ring_buffer_debug_info *DebugInfo)
 {
 	u32 bytesAvailToWrite;
 	u32 bytesAvailToRead;
diff --git a/drivers/staging/hv/RingBuffer.h b/drivers/staging/hv/RingBuffer.h
index 6580156..3268f80 100644
--- a/drivers/staging/hv/RingBuffer.h
+++ b/drivers/staging/hv/RingBuffer.h
@@ -63,13 +63,13 @@ struct hv_ring_buffer_info {
 
 };
 
-typedef struct _RING_BUFFER_DEBUG_INFO {
+struct hv_ring_buffer_debug_info {
 	u32 CurrentInterruptMask;
 	u32 CurrentReadIndex;
 	u32 CurrentWriteIndex;
 	u32 BytesAvailToRead;
 	u32 BytesAvailToWrite;
-} RING_BUFFER_DEBUG_INFO;
+};
 
 
 
@@ -96,6 +96,6 @@ u32 GetRingBufferInterruptMask(struct hv_ring_buffer_info *RingInfo);
 void DumpRingInfo(struct hv_ring_buffer_info *RingInfo, char *Prefix);
 
 void RingBufferGetDebugInfo(struct hv_ring_buffer_info *RingInfo,
-			    RING_BUFFER_DEBUG_INFO *DebugInfo);
+			    struct hv_ring_buffer_debug_info *DebugInfo);
 
 #endif /* _RING_BUFFER_H_ */
-- 
1.6.5.rc1
