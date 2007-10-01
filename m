Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbXJAQBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbXJAQBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbXJAQBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:01:16 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:61294 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbXJAQBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:01:15 -0400
Date: Mon, 1 Oct 2007 12:01:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Change struct marker users
Message-ID: <20071001160112.GB15407@Krystal>
References: <20070928142845.795281397@polymtl.ca> <20070928143159.299956378@polymtl.ca> <1191116135.26950.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1191116135.26950.54.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:59:32 up 63 days, 16:18,  3 users,  load average: 0.32, 0.84, 0.67
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change struct marker users

Prior to use struct marker in the linux kernel markers, we need to clean
two drivers which use this structure name.

Change bonding driver types :
- struct marker to struct bond_marker.
- marker_t to bond_marker_t.
- marker_header to bond_marker_header.
- marker_header_t to bond_marker_header_t.

Change qla4xxx struct marker_entry usage :
- Change struct marker_entry for struct qla4_marker_entry.

This patch applies before the
linux-kernel-markers-coding-style-fix.patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 drivers/net/bonding/bond_3ad.c  |   32 +++++++++++++++++---------------
 drivers/net/bonding/bond_3ad.h  |   12 ++++++------
 drivers/scsi/qla4xxx/ql4_fw.h   |    2 +-
 drivers/scsi/qla4xxx/ql4_iocb.c |    2 +-
 4 files changed, 25 insertions(+), 23 deletions(-)

Index: linux-2.6-lttng/drivers/scsi/qla4xxx/ql4_fw.h
===================================================================
--- linux-2.6-lttng.orig/drivers/scsi/qla4xxx/ql4_fw.h	2007-10-01 11:23:57.000000000 -0400
+++ linux-2.6-lttng/drivers/scsi/qla4xxx/ql4_fw.h	2007-10-01 11:26:23.000000000 -0400
@@ -671,7 +671,7 @@ struct continuation_t1_entry {
 #define ET_CONTINUE	ET_CONT_T1
 
 /* Marker entry structure*/
-struct marker_entry {
+struct qla4_marker_entry {
 	struct qla4_header hdr;	/* 00-03 */
 
 	uint32_t system_defined; /* 04-07 */
Index: linux-2.6-lttng/drivers/scsi/qla4xxx/ql4_iocb.c
===================================================================
--- linux-2.6-lttng.orig/drivers/scsi/qla4xxx/ql4_iocb.c	2007-10-01 11:24:05.000000000 -0400
+++ linux-2.6-lttng/drivers/scsi/qla4xxx/ql4_iocb.c	2007-10-01 11:26:30.000000000 -0400
@@ -69,7 +69,7 @@ static int qla4xxx_get_req_pkt(struct sc
 static int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
 				    struct ddb_entry *ddb_entry, int lun)
 {
-	struct marker_entry *marker_entry;
+	struct qla4_marker_entry *marker_entry;
 	unsigned long flags = 0;
 	uint8_t status = QLA_SUCCESS;
 
Index: linux-2.6-lttng/drivers/net/bonding/bond_3ad.c
===================================================================
--- linux-2.6-lttng.orig/drivers/net/bonding/bond_3ad.c	2007-10-01 11:23:33.000000000 -0400
+++ linux-2.6-lttng/drivers/net/bonding/bond_3ad.c	2007-10-01 11:31:37.000000000 -0400
@@ -126,7 +126,7 @@ static struct aggregator *__get_active_a
 
 // ================= main 802.3ad protocol functions ==================
 static int ad_lacpdu_send(struct port *port);
-static int ad_marker_send(struct port *port, struct marker *marker);
+static int ad_marker_send(struct port *port, struct bond_marker *marker);
 static void ad_mux_machine(struct port *port);
 static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port);
 static void ad_tx_machine(struct port *port);
@@ -139,8 +139,8 @@ static void ad_initialize_port(struct po
 static void ad_initialize_lacpdu(struct lacpdu *Lacpdu);
 static void ad_enable_collecting_distributing(struct port *port);
 static void ad_disable_collecting_distributing(struct port *port);
-static void ad_marker_info_received(struct marker *marker_info, struct port *port);
-static void ad_marker_response_received(struct marker *marker, struct port *port);
+static void ad_marker_info_received(struct bond_marker *marker_info, struct port *port);
+static void ad_marker_response_received(struct bond_marker *marker, struct port *port);
 
 
 /////////////////////////////////////////////////////////////////////////////////
@@ -889,12 +889,12 @@ static int ad_lacpdu_send(struct port *p
  * Returns:   0 on success
  *          < 0 on error
  */
-static int ad_marker_send(struct port *port, struct marker *marker)
+static int ad_marker_send(struct port *port, struct bond_marker *marker)
 {
 	struct slave *slave = port->slave;
 	struct sk_buff *skb;
-	struct marker_header *marker_header;
-	int length = sizeof(struct marker_header);
+	struct bond_marker_header *marker_header;
+	int length = sizeof(struct bond_marker_header);
 	struct mac_addr lacpdu_multicast_address = AD_MULTICAST_LACPDU_ADDR;
 
 	skb = dev_alloc_skb(length + 16);
@@ -909,7 +909,7 @@ static int ad_marker_send(struct port *p
 	skb->network_header = skb->mac_header + ETH_HLEN;
 	skb->protocol = PKT_TYPE_LACPDU;
 
-	marker_header = (struct marker_header *)skb_put(skb, length);
+	marker_header = (struct bond_marker_header *)skb_put(skb, length);
 
 	marker_header->ad_header.destination_address = lacpdu_multicast_address;
 	/* Note: source addres is set to be the member's PERMANENT address, because we use it
@@ -1709,7 +1709,7 @@ static void ad_disable_collecting_distri
  */
 static void ad_marker_info_send(struct port *port)
 {
-	struct marker marker;
+	struct bond_marker marker;
 	u16 index;
 
 	// fill the marker PDU with the appropriate values
@@ -1742,13 +1742,14 @@ static void ad_marker_info_send(struct p
  * @port: the port we're looking at
  *
  */
-static void ad_marker_info_received(struct marker *marker_info,struct port *port)
+static void ad_marker_info_received(struct bond_marker *marker_info,
+	struct port *port)
 {
-	struct marker marker;
+	struct bond_marker marker;
 
 	// copy the received marker data to the response marker
 	//marker = *marker_info;
-	memcpy(&marker, marker_info, sizeof(struct marker));
+	memcpy(&marker, marker_info, sizeof(struct bond_marker));
 	// change the marker subtype to marker response
 	marker.tlv_type=AD_MARKER_RESPONSE_SUBTYPE;
 	// send the marker response
@@ -1767,7 +1768,8 @@ static void ad_marker_info_received(stru
  * response for marker PDU's, in this stage, but only to respond to marker
  * information.
  */
-static void ad_marker_response_received(struct marker *marker, struct port *port)
+static void ad_marker_response_received(struct bond_marker *marker,
+	struct port *port)
 {
 	marker=NULL; // just to satisfy the compiler
 	port=NULL;  // just to satisfy the compiler
@@ -2164,15 +2166,15 @@ static void bond_3ad_rx_indication(struc
 		case AD_TYPE_MARKER:
 			// No need to convert fields to Little Endian since we don't use the marker's fields.
 
-			switch (((struct marker *)lacpdu)->tlv_type) {
+			switch (((struct bond_marker *)lacpdu)->tlv_type) {
 			case AD_MARKER_INFORMATION_SUBTYPE:
 				dprintk("Received Marker Information on port %d\n", port->actor_port_number);
-				ad_marker_info_received((struct marker *)lacpdu, port);
+				ad_marker_info_received((struct bond_marker *)lacpdu, port);
 				break;
 
 			case AD_MARKER_RESPONSE_SUBTYPE:
 				dprintk("Received Marker Response on port %d\n", port->actor_port_number);
-				ad_marker_response_received((struct marker *)lacpdu, port);
+				ad_marker_response_received((struct bond_marker *)lacpdu, port);
 				break;
 
 			default:
Index: linux-2.6-lttng/drivers/net/bonding/bond_3ad.h
===================================================================
--- linux-2.6-lttng.orig/drivers/net/bonding/bond_3ad.h	2007-10-01 11:23:50.000000000 -0400
+++ linux-2.6-lttng/drivers/net/bonding/bond_3ad.h	2007-10-01 11:28:54.000000000 -0400
@@ -92,7 +92,7 @@ typedef enum {
 typedef enum {
 	AD_MARKER_INFORMATION_SUBTYPE = 1, // marker imformation subtype
 	AD_MARKER_RESPONSE_SUBTYPE     // marker response subtype
-} marker_subtype_t;
+} bond_marker_subtype_t;
 
 // timers types(43.4.9 in the 802.3ad standard)
 typedef enum {
@@ -148,7 +148,7 @@ typedef struct lacpdu_header {
 } lacpdu_header_t;
 
 // Marker Protocol Data Unit(PDU) structure(43.5.3.2 in the 802.3ad standard)
-typedef struct marker {
+typedef struct bond_marker {
 	u8 subtype;		 //  = 0x02  (marker PDU)
 	u8 version_number;	 //  = 0x01
 	u8 tlv_type;		 //  = 0x01  (marker information)
@@ -161,12 +161,12 @@ typedef struct marker {
 	u8 tlv_type_terminator;	     //  = 0x00
 	u8 terminator_length;	     //  = 0x00
 	u8 reserved_90[90];	     //  = 0
-} marker_t;
+} bond_marker_t;
 
-typedef struct marker_header {
+typedef struct bond_marker_header {
 	struct ad_header ad_header;
-	struct marker marker;
-} marker_header_t;
+	struct bond_marker marker;
+} bond_marker_header_t;
 
 #pragma pack()

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
