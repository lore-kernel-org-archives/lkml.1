Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbYLMXUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbYLMXUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYLMXUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:20:42 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:51868 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbYLMXUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:20:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FYHUJWfRpqIF79h7fQKM1UTq++VyNzUXE3O53s5r5rtiPPa1IImmiQ5tV5uNiOEKG9
         keSsvcSXkI+YQRD9OM+/w4h9F7Db6SJbF7sfHmgVRefzUjg5RMHp17xsZceZB/OH7d52
         wamSp0Sk2M6kGQ5fwU8/4POhL/eEWV0i/rADw=
Subject: [PATCH 1/2] ieee1394: dv1394 annotate frame input/output structs
 as little endian
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 15:20:39 -0800
Message-Id: <1229210439.11257.15.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No Functional changes.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ieee1394/dv1394-private.h |   44 ++++++++++++++++++------------------
 drivers/ieee1394/dv1394.c         |    4 +-
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/ieee1394/dv1394-private.h b/drivers/ieee1394/dv1394-private.h
index 7d1d284..18b92cb 100644
--- a/drivers/ieee1394/dv1394-private.h
+++ b/drivers/ieee1394/dv1394-private.h
@@ -77,11 +77,11 @@ static inline void fill_cip_header(struct CIP_header *cip,
    See the Texas Instruments OHCI 1394 chipset documentation.
 */
 
-struct output_more_immediate { u32 q[8]; };
-struct output_more { u32 q[4]; };
-struct output_last { u32 q[4]; };
-struct input_more { u32 q[4]; };
-struct input_last { u32 q[4]; };
+struct output_more_immediate { __le32 q[8]; };
+struct output_more { __le32 q[4]; };
+struct output_last { __le32 q[4]; };
+struct input_more { __le32 q[4]; };
+struct input_last { __le32 q[4]; };
 
 /* outputs */
 
@@ -92,9 +92,9 @@ static inline void fill_output_more_immediate(struct output_more_immediate *omi,
 					      unsigned int  payload_size)
 {
 	omi->q[0] = cpu_to_le32(0x02000000 | 8); /* OUTPUT_MORE_IMMEDIATE; 8 is the size of the IT header */
-	omi->q[1] = 0;
-	omi->q[2] = 0;
-	omi->q[3] = 0;
+	omi->q[1] = cpu_to_le32(0);
+	omi->q[2] = cpu_to_le32(0);
+	omi->q[3] = cpu_to_le32(0);
 
 	/* IT packet header */
 	omi->q[4] = cpu_to_le32(  (0x0 << 16)  /* IEEE1394_SPEED_100 */
@@ -106,8 +106,8 @@ static inline void fill_output_more_immediate(struct output_more_immediate *omi,
 	/* reserved field; mimic behavior of my Sony DSR-40 */
 	omi->q[5] = cpu_to_le32((payload_size << 16) | (0x7F << 8) | 0xA0);
 
-	omi->q[6] = 0;
-	omi->q[7] = 0;
+	omi->q[6] = cpu_to_le32(0);
+	omi->q[7] = cpu_to_le32(0);
 }
 
 static inline void fill_output_more(struct output_more *om,
@@ -116,8 +116,8 @@ static inline void fill_output_more(struct output_more *om,
 {
 	om->q[0] = cpu_to_le32(data_size);
 	om->q[1] = cpu_to_le32(data_phys_addr);
-	om->q[2] = 0;
-	om->q[3] = 0;
+	om->q[2] = cpu_to_le32(0);
+	om->q[3] = cpu_to_le32(0);
 }
 
 static inline void fill_output_last(struct output_last *ol,
@@ -140,8 +140,8 @@ static inline void fill_output_last(struct output_last *ol,
 
 	ol->q[0] = cpu_to_le32(temp);
 	ol->q[1] = cpu_to_le32(data_phys_addr);
-	ol->q[2] = 0;
-	ol->q[3] = 0;
+	ol->q[2] = cpu_to_le32(0);
+	ol->q[3] = cpu_to_le32(0);
 }
 
 /* inputs */
@@ -161,8 +161,8 @@ static inline void fill_input_more(struct input_more *im,
 
 	im->q[0] = cpu_to_le32(temp);
 	im->q[1] = cpu_to_le32(data_phys_addr);
-	im->q[2] = 0; /* branchAddress and Z not use in packet-per-buffer mode */
-	im->q[3] = 0; /* xferStatus & resCount, resCount must be initialize to data_size */
+	im->q[2] = cpu_to_le32(0); /* branchAddress and Z not use in packet-per-buffer mode */
+	im->q[3] = cpu_to_le32(0); /* xferStatus & resCount, resCount must be initialize to data_size */
 }
  
 static inline void fill_input_last(struct input_last *il,
@@ -331,7 +331,7 @@ struct frame {
 
 	/* points to status/timestamp field of first DMA packet */
 	/* (we'll check it later to monitor timestamp accuracy) */
-	u32 *frame_begin_timestamp;
+	__le32 *frame_begin_timestamp;
 
 	/* the timestamp we assigned to the first packet in the frame */
 	u32 assigned_timestamp;
@@ -348,15 +348,15 @@ struct frame {
 	   that can cause interrupts. We'll check these from the
 	   interrupt handler.
 	*/
-	u32 *mid_frame_timestamp;
-	u32 *frame_end_timestamp;
+	__le32 *mid_frame_timestamp;
+	__le32 *frame_end_timestamp;
 
 	/* branch address field of final packet. This is effectively
 	   the "tail" in the chain of DMA descriptor blocks.
 	   We will fill it with the address of the first DMA descriptor
 	   block in the subsequent frame, once it is ready.
 	*/
-	u32 *frame_end_branch;
+	__le32 *frame_end_branch;
 
 	/* the number of descriptors in the first descriptor block
 	   of the frame. Needed to start DMA */
@@ -365,10 +365,10 @@ struct frame {
 

 struct packet {
-	u16	timestamp;
+	__le16	timestamp;
 	u16	invalid;
 	u16	iso_header;
-	u16	data_length;
+	__le16	data_length;
 	u32	cip_h1;
 	u32	cip_h2;
 	unsigned char data[480];
diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index c19f232..f258e61 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -265,7 +265,7 @@ static void frame_prepare(struct video_card *video, unsigned int this_frame)
 	/* these flags denote packets that need special attention */
 	int empty_packet, first_packet, last_packet, mid_packet;
 
-	u32 *branch_address, *last_branch_address = NULL;
+	__le32 *branch_address, *last_branch_address = NULL;
 	unsigned long data_p;
 	int first_packet_empty = 0;
 	u32 cycleTimer, ct_sec, ct_cyc, ct_off;
@@ -848,7 +848,7 @@ static void receive_packets(struct video_card *video)
 	dma_addr_t block_dma = 0;
 	struct packet *data = NULL;
 	dma_addr_t data_dma = 0;
-	u32 *last_branch_address = NULL;
+	__le32 *last_branch_address = NULL;
 	unsigned long irq_flags;
 	int want_interrupt = 0;
 	struct frame *f = NULL;
-- 
1.6.1.rc2.306.ge5d5e


