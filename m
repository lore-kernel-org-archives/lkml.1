Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZJJXRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZJJXRL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 19:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbZJJXRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 19:17:10 -0400
Received: from maila.microsoft.com ([131.107.115.212]:5933 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbZJJXRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 19:17:09 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Hank Janssen <hjanssen@microsoft.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tom Hanrahan" <hanrahat@microsoft.com>,
       Hashir Abdi <habdi@microsoft.com>
Subject: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Thread-Topic: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Thread-Index: AcpJ/6FE0xhfIRwfRT+rZ9QOhF0ebw==
Date: Sat, 10 Oct 2009 23:16:00 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
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

From: Haiyang Zhang <haiyangz@microsoft.com>

Fix vmbus load hang caused by wrong data packing.

Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
diff --git a/drivers/staging/hv/ChannelMgmt.h b/drivers/staging/hv/ChannelMgmt.h
index a839d8f..3f18584 100644
--- a/drivers/staging/hv/ChannelMgmt.h
+++ b/drivers/staging/hv/ChannelMgmt.h
@@ -30,6 +30,8 @@
 #include "VmbusChannelInterface.h"
 #include "VmbusPacketFormat.h"
 
+#pragma pack(push,1)
+
 /* Version 1 messages */
 enum vmbus_channel_message_type {
 	ChannelMessageInvalid			=  0,
@@ -54,24 +56,24 @@ enum vmbus_channel_message_type {
 	ChannelMessageViewRangeRemove		= 18,
 #endif
 	ChannelMessageCount
-} __attribute__((packed));
+};
 
 struct vmbus_channel_message_header {
 	enum vmbus_channel_message_type MessageType;
 	u32 Padding;
-} __attribute__((packed));
+};
 
 /* Query VMBus Version parameters */
 struct vmbus_channel_query_vmbus_version {
 	struct vmbus_channel_message_header Header;
 	u32 Version;
-} __attribute__((packed));
+};
 
 /* VMBus Version Supported parameters */
 struct vmbus_channel_version_supported {
 	struct vmbus_channel_message_header Header;
 	bool VersionSupported;
-} __attribute__((packed));
+};
 
 /* Offer Channel parameters */
 struct vmbus_channel_offer_channel {
@@ -80,13 +82,13 @@ struct vmbus_channel_offer_channel {
 	u32 ChildRelId;
 	u8 MonitorId;
 	bool MonitorAllocated;
-} __attribute__((packed));
+};
 
 /* Rescind Offer parameters */
 struct vmbus_channel_rescind_offer {
 	struct vmbus_channel_message_header Header;
 	u32 ChildRelId;
-} __attribute__((packed));
+};
 
 /*
  * Request Offer -- no parameters, SynIC message contains the partition ID
@@ -122,7 +124,7 @@ struct vmbus_channel_open_channel {
 
 	/* User-specific data to be passed along to the server endpoint. */
 	unsigned char UserData[MAX_USER_DEFINED_BYTES];
-} __attribute__((packed));
+};
 
 /* Open Channel Result parameters */
 struct vmbus_channel_open_result {
@@ -130,13 +132,13 @@ struct vmbus_channel_open_result {
 	u32 ChildRelId;
 	u32 OpenId;
 	u32 Status;
-} __attribute__((packed));
+};
 
 /* Close channel parameters; */
 struct vmbus_channel_close_channel {
 	struct vmbus_channel_message_header Header;
 	u32 ChildRelId;
-} __attribute__((packed));
+};
 
 /* Channel Message GPADL */
 #define GPADL_TYPE_RING_BUFFER		1
@@ -156,7 +158,7 @@ struct vmbus_channel_gpadl_header {
 	u16 RangeBufLen;
 	u16 RangeCount;
 	struct gpa_range Range[0];
-} __attribute__((packed));
+};
 
 /* This is the followup packet that contains more PFNs. */
 struct vmbus_channel_gpadl_body {
@@ -164,25 +166,25 @@ struct vmbus_channel_gpadl_body {
 	u32 MessageNumber;
 	u32 Gpadl;
 	u64 Pfn[0];
-} __attribute__((packed));
+};
 
 struct vmbus_channel_gpadl_created {
 	struct vmbus_channel_message_header Header;
 	u32 ChildRelId;
 	u32 Gpadl;
 	u32 CreationStatus;
-} __attribute__((packed));
+};
 
 struct vmbus_channel_gpadl_teardown {
 	struct vmbus_channel_message_header Header;
 	u32 ChildRelId;
 	u32 Gpadl;
-} __attribute__((packed));
+};
 
 struct vmbus_channel_gpadl_torndown {
 	struct vmbus_channel_message_header Header;
 	u32 Gpadl;
-} __attribute__((packed));
+};
 
 #ifdef VMBUS_FEATURE_PARENT_OR_PEER_MEMORY_MAPPED_INTO_A_CHILD
 struct vmbus_channel_view_range_add {
@@ -190,19 +192,19 @@ struct vmbus_channel_view_range_add {
 	PHYSICAL_ADDRESS ViewRangeBase;
 	u64 ViewRangeLength;
 	u32 ChildRelId;
-} __attribute__((packed));
+};
 
 struct vmbus_channel_view_range_remove {
 	struct vmbus_channel_message_header Header;
 	PHYSICAL_ADDRESS ViewRangeBase;
 	u32 ChildRelId;
-} __attribute__((packed));
+};
 #endif
 
 struct vmbus_channel_relid_released {
 	struct vmbus_channel_message_header Header;
 	u32 ChildRelId;
-} __attribute__((packed));
+};
 
 struct vmbus_channel_initiate_contact {
 	struct vmbus_channel_message_header Header;
@@ -211,12 +213,12 @@ struct vmbus_channel_initiate_contact {
 	u64 InterruptPage;
 	u64 MonitorPage1;
 	u64 MonitorPage2;
-} __attribute__((packed));
+};
 
 struct vmbus_channel_version_response {
 	struct vmbus_channel_message_header Header;
 	bool VersionSupported;
-} __attribute__((packed));
+};
 
 enum vmbus_channel_state {
 	CHANNEL_OFFER_STATE,
@@ -305,6 +307,7 @@ struct vmbus_channel_msginfo {
 	unsigned char Msg[0];
 };
 
+#pragma pack(pop)
 
 struct vmbus_channel *AllocVmbusChannel(void);
 