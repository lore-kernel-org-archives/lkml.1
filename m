Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbYLMXDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYLMXDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYLMXDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:03:11 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:58302 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYLMXDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:03:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Ac7RXwBexi1D0iqMHMgFPOmIOEWHvuer30w8SPdbHWTYP75JtkAtbUD6nrNBTyt9wS
         nvfZKpL/vu9D93BlzUg2R9va5cF89ey+6sDxRatHCNgDlbKLx6gbwJsKup/2sshZuQFl
         djIXFmuboOvQ5s1TucmgHTFBeyxomookZjcKA=
Subject: [PATCH 4/4] ieee1394: eth1394 trivial sparse annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 15:03:06 -0800
Message-Id: <1229209386.11257.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly annotations of ether_type as a be16.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ieee1394/eth1394.c |   26 +++++++++++++-------------
 drivers/ieee1394/eth1394.h |   16 ++++++++--------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/ieee1394/eth1394.c b/drivers/ieee1394/eth1394.c
index 7ae8bce..a074bfd 100644
--- a/drivers/ieee1394/eth1394.c
+++ b/drivers/ieee1394/eth1394.c
@@ -92,7 +92,7 @@ struct partial_datagram {
 	struct list_head list;
 	u16 dgl;
 	u16 dg_size;
-	u16 ether_type;
+	__be16 ether_type;
 	struct sk_buff *skb;
 	char *pbuf;
 	struct list_head frag_info;
@@ -767,7 +767,7 @@ static int ether1394_header_parse(const struct sk_buff *skb,
 static int ether1394_header_cache(const struct neighbour *neigh,
 				  struct hh_cache *hh)
 {
-	unsigned short type = hh->hh_type;
+	__be16 type = hh->hh_type;
 	struct net_device *dev = neigh->dev;
 	struct eth1394hdr *eth =
 		(struct eth1394hdr *)((u8 *)hh->hh_data + 16 - ETH1394_HLEN);
@@ -795,7 +795,7 @@ static void ether1394_header_cache_update(struct hh_cache *hh,
  ******************************************/
 
 /* Copied from net/ethernet/eth.c */
-static u16 ether1394_type_trans(struct sk_buff *skb, struct net_device *dev)
+static __be16 ether1394_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
 	struct eth1394hdr *eth;
 	unsigned char *rawp;
@@ -829,17 +829,17 @@ static u16 ether1394_type_trans(struct sk_buff *skb, struct net_device *dev)
 
 /* Parse an encapsulated IP1394 header into an ethernet frame packet.
  * We also perform ARP translation here, if need be.  */
-static u16 ether1394_parse_encap(struct sk_buff *skb, struct net_device *dev,
+static __be16 ether1394_parse_encap(struct sk_buff *skb, struct net_device *dev,
 				 nodeid_t srcid, nodeid_t destid,
-				 u16 ether_type)
+				 __be16 ether_type)
 {
 	struct eth1394_priv *priv = netdev_priv(dev);
-	u64 dest_hw;
-	unsigned short ret = 0;
+	__be64 dest_hw;
+	__be16 ret = 0;
 
 	/* Setup our hw addresses. We use these to build the ethernet header. */
 	if (destid == (LOCAL_BUS | ALL_NODES))
-		dest_hw = ~0ULL;  /* broadcast */
+		dest_hw = ~cpu_to_be64(0);  /* broadcast */
 	else
 		dest_hw = cpu_to_be64((u64)priv->host->csr.guid_hi << 32 |
 				      priv->host->csr.guid_lo);
@@ -873,7 +873,7 @@ static u16 ether1394_parse_encap(struct sk_buff *skb, struct net_device *dev,
 		node = eth1394_find_node_guid(&priv->ip_node_list,
 					      be64_to_cpu(guid));
 		if (!node)
-			return 0;
+			return cpu_to_be16(0);
 
 		node_info =
 		    (struct eth1394_node_info *)node->ud->device.driver_data;
@@ -1063,7 +1063,7 @@ static int ether1394_data_handler(struct net_device *dev, int srcid, int destid,
 	unsigned long flags;
 	struct eth1394_priv *priv = netdev_priv(dev);
 	union eth1394_hdr *hdr = (union eth1394_hdr *)buf;
-	u16 ether_type = 0;  /* initialized to clear warning */
+	__be16 ether_type = cpu_to_be16(0);  /* initialized to clear warning */
 	int hdr_len;
 	struct unit_directory *ud = priv->ud_list[NODEID_TO_NODE(srcid)];
 	struct eth1394_node_info *node_info;
@@ -1259,7 +1259,7 @@ static int ether1394_write(struct hpsb_host *host, int srcid, int destid,
 
 static void ether1394_iso(struct hpsb_iso *iso)
 {
-	quadlet_t *data;
+	__be32 *data;
 	char *buf;
 	struct eth1394_host_info *hi;
 	struct net_device *dev;
@@ -1283,7 +1283,7 @@ static void ether1394_iso(struct hpsb_iso *iso)
 	for (i = 0; i < nready; i++) {
 		struct hpsb_iso_packet_info *info =
 			&iso->infos[(iso->first_packet + i) % iso->buf_packets];
-		data = (quadlet_t *)(iso->data_buf.kvirt + info->offset);
+		data = (__be32 *)(iso->data_buf.kvirt + info->offset);
 
 		/* skip over GASP header */
 		buf = (char *)data + 8;
@@ -1614,7 +1614,7 @@ static int ether1394_tx(struct sk_buff *skb, struct net_device *dev)
 		if (max_payload < dg_size + hdr_type_len[ETH1394_HDR_LF_UF])
 			priv->bc_dgl++;
 	} else {
-		__be64 guid = get_unaligned((u64 *)hdr_buf.h_dest);
+		__be64 guid = get_unaligned((__be64 *)hdr_buf.h_dest);
 
 		node = eth1394_find_node_guid(&priv->ip_node_list,
 					      be64_to_cpu(guid));
diff --git a/drivers/ieee1394/eth1394.h b/drivers/ieee1394/eth1394.h
index 4f3e2dd..e1b5ea8 100644
--- a/drivers/ieee1394/eth1394.h
+++ b/drivers/ieee1394/eth1394.h
@@ -82,7 +82,7 @@ struct eth1394_priv {
 
 struct eth1394hdr {
 	unsigned char	h_dest[ETH1394_ALEN];	/* destination eth1394 addr	*/
-	unsigned short	h_proto;		/* packet type ID field	*/
+	__be16		h_proto;		/* packet type ID field	*/
 }  __attribute__((packed));
 
 static inline struct eth1394hdr *eth1394_hdr(const struct sk_buff *skb)
@@ -99,13 +99,13 @@ typedef enum {ETH1394_GASP, ETH1394_WRREQ} eth1394_tx_type;
 struct eth1394_uf_hdr {
 	u16 lf:2;
 	u16 res:14;
-	u16 ether_type;		/* Ethernet packet type */
+	__be16 ether_type;		/* Ethernet packet type */
 } __attribute__((packed));
 #elif defined __LITTLE_ENDIAN_BITFIELD
 struct eth1394_uf_hdr {
 	u16 res:14;
 	u16 lf:2;
-	u16 ether_type;
+	__be16 ether_type;
 } __attribute__((packed));
 #else
 #error Unknown bit field type
@@ -117,7 +117,7 @@ struct eth1394_ff_hdr {
 	u16 lf:2;
 	u16 res1:2;
 	u16 dg_size:12;		/* Datagram size */
-	u16 ether_type;		/* Ethernet packet type */
+	__be16 ether_type;		/* Ethernet packet type */
 	u16 dgl;		/* Datagram label */
 	u16 res2;
 } __attribute__((packed));
@@ -126,7 +126,7 @@ struct eth1394_ff_hdr {
 	u16 dg_size:12;
 	u16 res1:2;
 	u16 lf:2;
-	u16 ether_type;
+	__be16 ether_type;
 	u16 dgl;
 	u16 res2;
 } __attribute__((packed));
@@ -207,11 +207,11 @@ struct eth1394_arp {
 	u16 opcode;		/* ARP Opcode	*/
 	/* Above is exactly the same format as struct arphdr */
 
-	u64 s_uniq_id;		/* Sender's 64bit EUI			*/
+	__be64 s_uniq_id;	/* Sender's 64bit EUI		*/
 	u8 max_rec;		/* Sender's max packet size		*/
 	u8 sspd;		/* Sender's max speed			*/
-	u16 fifo_hi;		/* hi 16bits of sender's FIFO addr	*/
-	u32 fifo_lo;		/* lo 32bits of sender's FIFO addr	*/
+	__be16 fifo_hi;		/* hi 16bits of sender's FIFO addr	*/
+	__be32 fifo_lo;		/* lo 32bits of sender's FIFO addr	*/
 	u32 sip;		/* Sender's IP Address			*/
 	u32 tip;		/* IP Address of requested hw addr	*/
 };
-- 
1.6.1.rc2.306.ge5d5e

