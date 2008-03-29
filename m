Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbYC2DNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbYC2DNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759397AbYC2DKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:10:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50234 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760220AbYC2DKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:10:30 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] trivial endianness annotations: infiniband core
Cc: rolandd@cisco.com, linux-kernel@vger.kernel.org
Message-Id: <E1JfRSe-0002z3-LI@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:10:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/infiniband/core/addr.c |    8 ++++----
 drivers/infiniband/core/cm.c   |    2 +-
 drivers/infiniband/core/cma.c  |   24 ++++++++++++------------
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index a58ad8a..781ea59 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -154,7 +154,7 @@ static void addr_send_arp(struct sockaddr_in *dst_in)
 {
 	struct rtable *rt;
 	struct flowi fl;
-	u32 dst_ip = dst_in->sin_addr.s_addr;
+	__be32 dst_ip = dst_in->sin_addr.s_addr;
 
 	memset(&fl, 0, sizeof fl);
 	fl.nl_u.ip4_u.daddr = dst_ip;
@@ -169,8 +169,8 @@ static int addr_resolve_remote(struct sockaddr_in *src_in,
 			       struct sockaddr_in *dst_in,
 			       struct rdma_dev_addr *addr)
 {
-	u32 src_ip = src_in->sin_addr.s_addr;
-	u32 dst_ip = dst_in->sin_addr.s_addr;
+	__be32 src_ip = src_in->sin_addr.s_addr;
+	__be32 dst_ip = dst_in->sin_addr.s_addr;
 	struct flowi fl;
 	struct rtable *rt;
 	struct neighbour *neigh;
@@ -257,7 +257,7 @@ static int addr_resolve_local(struct sockaddr_in *src_in,
 			      struct rdma_dev_addr *addr)
 {
 	struct net_device *dev;
-	u32 src_ip = src_in->sin_addr.s_addr;
+	__be32 src_ip = src_in->sin_addr.s_addr;
 	__be32 dst_ip = dst_in->sin_addr.s_addr;
 	int ret;
 
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 4df4051..faa7ce3 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -393,7 +393,7 @@ static int cm_alloc_id(struct cm_id_private *cm_id_priv)
 		spin_unlock_irqrestore(&cm.lock, flags);
 	} while( (ret == -EAGAIN) && idr_pre_get(&cm.local_id_table, GFP_KERNEL) );
 
-	cm_id_priv->id.local_id = (__force __be32) (id ^ cm.random_id_operand);
+	cm_id_priv->id.local_id = (__force __be32)id ^ cm.random_id_operand;
 	return ret;
 }
 
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 34507da..d81c156 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -168,15 +168,15 @@ struct cma_work {
 union cma_ip_addr {
 	struct in6_addr ip6;
 	struct {
-		__u32 pad[3];
-		__u32 addr;
+		__be32 pad[3];
+		__be32 addr;
 	} ip4;
 };
 
 struct cma_hdr {
 	u8 cma_version;
 	u8 ip_version;	/* IP version: 7:4 */
-	__u16 port;
+	__be16 port;
 	union cma_ip_addr src_addr;
 	union cma_ip_addr dst_addr;
 };
@@ -186,8 +186,8 @@ struct sdp_hh {
 	u8 sdp_version; /* Major version: 7:4 */
 	u8 ip_version;	/* IP version: 7:4 */
 	u8 sdp_specific1[10];
-	__u16 port;
-	__u16 sdp_specific2;
+	__be16 port;
+	__be16 sdp_specific2;
 	union cma_ip_addr src_addr;
 	union cma_ip_addr dst_addr;
 };
@@ -663,7 +663,7 @@ static inline int cma_any_port(struct sockaddr *addr)
 }
 
 static int cma_get_net_info(void *hdr, enum rdma_port_space ps,
-			    u8 *ip_ver, __u16 *port,
+			    u8 *ip_ver, __be16 *port,
 			    union cma_ip_addr **src, union cma_ip_addr **dst)
 {
 	switch (ps) {
@@ -695,7 +695,7 @@ static int cma_get_net_info(void *hdr, enum rdma_port_space ps,
 
 static void cma_save_net_info(struct rdma_addr *addr,
 			      struct rdma_addr *listen_addr,
-			      u8 ip_ver, __u16 port,
+			      u8 ip_ver, __be16 port,
 			      union cma_ip_addr *src, union cma_ip_addr *dst)
 {
 	struct sockaddr_in *listen4, *ip4;
@@ -996,7 +996,7 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 	struct rdma_cm_id *id;
 	struct rdma_route *rt;
 	union cma_ip_addr *src, *dst;
-	__u16 port;
+	__be16 port;
 	u8 ip_ver;
 
 	if (cma_get_net_info(ib_event->private_data, listen_id->ps,
@@ -1043,7 +1043,7 @@ static struct rdma_id_private *cma_new_udp_id(struct rdma_cm_id *listen_id,
 	struct rdma_id_private *id_priv;
 	struct rdma_cm_id *id;
 	union cma_ip_addr *src, *dst;
-	__u16 port;
+	__be16 port;
 	u8 ip_ver;
 	int ret;
 
@@ -1165,7 +1165,7 @@ static void cma_set_compare_data(enum rdma_port_space ps, struct sockaddr *addr,
 {
 	struct cma_hdr *cma_data, *cma_mask;
 	struct sdp_hh *sdp_data, *sdp_mask;
-	__u32 ip4_addr;
+	__be32 ip4_addr;
 	struct in6_addr ip6_addr;
 
 	memset(compare, 0, sizeof *compare);
@@ -1181,12 +1181,12 @@ static void cma_set_compare_data(enum rdma_port_space ps, struct sockaddr *addr,
 			sdp_set_ip_ver(sdp_data, 4);
 			sdp_set_ip_ver(sdp_mask, 0xF);
 			sdp_data->dst_addr.ip4.addr = ip4_addr;
-			sdp_mask->dst_addr.ip4.addr = ~0;
+			sdp_mask->dst_addr.ip4.addr = htonl(~0);
 		} else {
 			cma_set_ip_ver(cma_data, 4);
 			cma_set_ip_ver(cma_mask, 0xF);
 			cma_data->dst_addr.ip4.addr = ip4_addr;
-			cma_mask->dst_addr.ip4.addr = ~0;
+			cma_mask->dst_addr.ip4.addr = htonl(~0);
 		}
 		break;
 	case AF_INET6:
-- 
1.5.3.GIT


