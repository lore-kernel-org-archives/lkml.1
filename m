Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbZKKV5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbZKKV5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759108AbZKKV5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:57:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758868AbZKKV5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:57:05 -0500
Date: Wed, 11 Nov 2009 16:57:03 -0500
From: Dave Jones <davej@redhat.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Fix argument order in incorrect memset invocations in hyperv driver.
Message-ID: <20091111215703.GA24390@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hank Janssen <hjanssen@microsoft.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nearly every invocation of memset in drivers/staging/hv/StorVsc.c
has it's arguments the wrong way around.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/staging/hv/StorVsc.c b/drivers/staging/hv/StorVsc.c
index 14015c9..2f7c425 100644
--- a/drivers/staging/hv/StorVsc.c
+++ b/drivers/staging/hv/StorVsc.c
@@ -196,7 +196,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 	 * Now, initiate the vsc/vsp initialization protocol on the open
 	 * channel
 	 */
-	memset(request, sizeof(struct storvsc_request_extension), 0);
+	memset(request, 0, sizeof(struct storvsc_request_extension));
 	request->WaitEvent = osd_WaitEventCreate();
 
 	vstorPacket->Operation = VStorOperationBeginInitialization;
@@ -233,7 +233,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 	DPRINT_INFO(STORVSC, "QUERY_PROTOCOL_VERSION_OPERATION...");
 
 	/* reuse the packet for version range supported */
-	memset(vstorPacket, sizeof(struct vstor_packet), 0);
+	memset(vstorPacket, 0, sizeof(struct vstor_packet));
 	vstorPacket->Operation = VStorOperationQueryProtocolVersion;
 	vstorPacket->Flags = REQUEST_COMPLETION_FLAG;
 
@@ -266,7 +266,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 	/* Query channel properties */
 	DPRINT_INFO(STORVSC, "QUERY_PROPERTIES_OPERATION...");
 
-	memset(vstorPacket, sizeof(struct vstor_packet), 0);
+	memset(vstorPacket, 0, sizeof(struct vstor_packet));
 	vstorPacket->Operation = VStorOperationQueryProperties;
 	vstorPacket->Flags = REQUEST_COMPLETION_FLAG;
 	vstorPacket->StorageChannelProperties.PortNumber =
@@ -305,7 +305,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 
 	DPRINT_INFO(STORVSC, "END_INITIALIZATION_OPERATION...");
 
-	memset(vstorPacket, sizeof(struct vstor_packet), 0);
+	memset(vstorPacket, 0, sizeof(struct vstor_packet));
 	vstorPacket->Operation = VStorOperationEndInitialization;
 	vstorPacket->Flags = REQUEST_COMPLETION_FLAG;
 
@@ -508,7 +508,7 @@ static int StorVscConnectToVsp(struct hv_device *Device)
 	int ret;
 
 	storDriver = (struct storvsc_driver_object *)Device->Driver;
-	memset(&props, sizeof(struct vmstorage_channel_properties), 0);
+	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
 	/* Open the channel */
 	ret = Device->Driver->VmbusChannelInterface.Open(Device,
