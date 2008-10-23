Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYJWE7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYJWE7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 00:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYJWE6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 00:58:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:60939 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYJWE63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 00:58:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=aVqxM9uFnf8pXM9Hqi141+9AvHK/iqNTQMFjnnWwJ7x7JwItGusnt+XmuAD0mogs5X
         6uhL0tQAhWw54UmYUCNDO9ed9fYwavEeWauwXdWFTfJnAflHgtV3DXf+ARVRC6tW2Ssx
         Wuot3YZsQabChWFyV9zbpS/V/qV/Oxs6OahcY=
Subject: [PATCH 3/3] netxen: somewhat ugly endian annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dhananjay Phadke <dhananjay@netxen.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 21:58:24 -0700
Message-Id: <1224737904.6823.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets nearly through all of the endianness sparse warnings.
It would be a good idea to systematically go through the remaining
structs and annotate their endianness if needed.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/netxen/netxen_nic.h     |   36 +++++++++++++++++-----------------
 drivers/net/netxen/netxen_nic_ctx.c |   18 +++++++---------
 drivers/net/netxen/netxen_nic_hw.c  |   14 +++++++-----
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic.h b/drivers/net/netxen/netxen_nic.h
index 0947514..a55e929 100644
--- a/drivers/net/netxen/netxen_nic.h
+++ b/drivers/net/netxen/netxen_nic.h
@@ -1014,8 +1014,8 @@ typedef struct {
 	__le32 host_int_crb_mode;	/* Interrupt crb usage */
 	__le32 host_rds_crb_mode;	/* RDS crb usage */
 	/* These ring offsets are relative to data[0] below */
-	u32 rds_ring_offset;	/* Offset to RDS config */
-	u32 sds_ring_offset;	/* Offset to SDS config */
+	__le32 rds_ring_offset;	/* Offset to RDS config */
+	__le32 sds_ring_offset;	/* Offset to SDS config */
 	__le16 num_rds_rings;	/* Count of RDS rings */
 	__le16 num_sds_rings;	/* Count of SDS rings */
 	u16 rsvd1;		/* Padding */
@@ -1029,24 +1029,24 @@ typedef struct {
 } nx_hostrq_rx_ctx_t;
 
 typedef struct {
-	u32 host_producer_crb;	/* Crb to use */
+	__le32 host_producer_crb;	/* Crb to use */
 	u32 rsvd1;		/* Padding */
 } nx_cardrsp_rds_ring_t;
 
 typedef struct {
-	u32 host_consumer_crb;	/* Crb to use */
-	u32 interrupt_crb;	/* Crb to use */
+	__le32 host_consumer_crb;	/* Crb to use */
+	__le32 interrupt_crb;	/* Crb to use */
 } nx_cardrsp_sds_ring_t;
 
 typedef struct {
 	/* These ring offsets are relative to data[0] below */
 	u32 rds_ring_offset;	/* Offset to RDS config */
 	u32 sds_ring_offset;	/* Offset to SDS config */
-	u32 host_ctx_state;	/* Starting State */
+	__le32 host_ctx_state;	/* Starting State */
 	u32 num_fn_per_port;	/* How many PCI fn share the port */
-	u16 num_rds_rings;	/* Count of RDS rings */
+	__le16 num_rds_rings;	/* Count of RDS rings */
 	u16 num_sds_rings;	/* Count of SDS rings */
-	u16 context_id;		/* Handle for context */
+	__le16 context_id;		/* Handle for context */
 	u8  phys_port;		/* Physical id of port */
 	u8  virt_port;		/* Virtual/Logical id of port */
 	u8  reserved[128];	/* save space for future expansion */
@@ -1072,17 +1072,17 @@ typedef struct {
  */
 
 typedef struct {
-	u64 host_phys_addr;	/* Ring base addr */
-	u32 ring_size;		/* Ring entries */
+	__le64 host_phys_addr;	/* Ring base addr */
+	__le32 ring_size;		/* Ring entries */
 	u32 rsvd;		/* Padding */
 } nx_hostrq_cds_ring_t;
 
 typedef struct {
-	u64 host_rsp_dma_addr;	/* Response dma'd here */
-	u64 cmd_cons_dma_addr;	/*  */
-	u64 dummy_dma_addr;	/*  */
-	u32 capabilities[4];	/* Flag bit vector */
-	u32 host_int_crb_mode;	/* Interrupt crb usage */
+	__le64 host_rsp_dma_addr;	/* Response dma'd here */
+	__le64 cmd_cons_dma_addr;	/*  */
+	__le64 dummy_dma_addr;	/*  */
+	__le32 capabilities[4];	/* Flag bit vector */
+	__le32 host_int_crb_mode;	/* Interrupt crb usage */
 	u32 rsvd1;		/* Padding */
 	u16 rsvd2;		/* Padding */
 	u16 interrupt_ctl;
@@ -1093,13 +1093,13 @@ typedef struct {
 } nx_hostrq_tx_ctx_t;
 
 typedef struct {
-	u32 host_producer_crb;	/* Crb to use */
+	__le32 host_producer_crb;	/* Crb to use */
 	u32 interrupt_crb;	/* Crb to use */
 } nx_cardrsp_cds_ring_t;
 
 typedef struct {
 	u32 host_ctx_state;	/* Starting state */
-	u16 context_id;		/* Handle for context */
+	__le16 context_id;		/* Handle for context */
 	u8  phys_port;		/* Physical id of port */
 	u8  virt_port;		/* Virtual/Logical id of port */
 	nx_cardrsp_cds_ring_t cds_ring;	/* Card cds settings */
@@ -1204,7 +1204,7 @@ enum {
 typedef struct {
 	u64 qhdr;
 	u64 req_hdr;
-	u64 words[6];
+	__le64 words[6];
 } nx_nic_req_t;
 
 typedef struct {
diff --git a/drivers/net/netxen/netxen_nic_ctx.c b/drivers/net/netxen/netxen_nic_ctx.c
index dd1b653..e0aa957 100644
--- a/drivers/net/netxen/netxen_nic_ctx.c
+++ b/drivers/net/netxen/netxen_nic_ctx.c
@@ -186,6 +186,7 @@ nx_fw_cmd_create_rx_ctx(struct netxen_adapter *adapter)
 	int i, nrds_rings, nsds_rings;
 	size_t rq_size, rsp_size;
 	u32 cap, reg;
+	u32 rds_offset, sds_offset;
 
 	int err;
 
@@ -227,11 +228,12 @@ nx_fw_cmd_create_rx_ctx(struct netxen_adapter *adapter)
 
 	prq->num_rds_rings = cpu_to_le16(nrds_rings);
 	prq->num_sds_rings = cpu_to_le16(nsds_rings);
-	prq->rds_ring_offset = 0;
-	prq->sds_ring_offset = prq->rds_ring_offset +
-		(sizeof(nx_hostrq_rds_ring_t) * nrds_rings);
+	rds_offset = 0;
+	sds_offset = rds_offset + (sizeof(nx_hostrq_rds_ring_t) * nrds_rings);
+	prq->rds_ring_offset = cpu_to_le32(rds_offset);
+	prq->sds_ring_offset = cpu_to_le32(sds_offset);
 
-	prq_rds = (nx_hostrq_rds_ring_t *)(prq->data + prq->rds_ring_offset);
+	prq_rds = (nx_hostrq_rds_ring_t *)(prq->data + rds_offset);
 
 	for (i = 0; i < nrds_rings; i++) {
 
@@ -243,7 +245,7 @@ nx_fw_cmd_create_rx_ctx(struct netxen_adapter *adapter)
 		prq_rds[i].buff_size = cpu_to_le64(rds_ring->dma_size);
 	}
 
-	prq_sds = (nx_hostrq_sds_ring_t *)(prq->data + prq->sds_ring_offset);
+	prq_sds = (nx_hostrq_sds_ring_t *)(prq->data + sds_offset);
 
 	prq_sds[0].host_phys_addr =
 		cpu_to_le64(recv_ctx->rcv_status_desc_phys_addr);
@@ -251,10 +253,6 @@ nx_fw_cmd_create_rx_ctx(struct netxen_adapter *adapter)
 	/* only one msix vector for now */
 	prq_sds[0].msi_index = cpu_to_le16(0);
 
-	/* now byteswap offsets */
-	prq->rds_ring_offset = cpu_to_le32(prq->rds_ring_offset);
-	prq->sds_ring_offset = cpu_to_le32(prq->sds_ring_offset);
-
 	phys_addr = hostrq_phys_addr;
 	err = netxen_issue_cmd(adapter,
 			adapter->ahw.pci_func,
@@ -273,7 +271,7 @@ nx_fw_cmd_create_rx_ctx(struct netxen_adapter *adapter)
 	prsp_rds = ((nx_cardrsp_rds_ring_t *)
 			 &prsp->data[prsp->rds_ring_offset]);
 
-	for (i = 0; i < le32_to_cpu(prsp->num_rds_rings); i++) {
+	for (i = 0; i < le16_to_cpu(prsp->num_rds_rings); i++) {
 		rds_ring = &recv_ctx->rds_rings[i];
 
 		reg = le32_to_cpu(prsp_rds[i].host_producer_crb);
diff --git a/drivers/net/netxen/netxen_nic_hw.c b/drivers/net/netxen/netxen_nic_hw.c
index fcba06d..11c8b9e 100644
--- a/drivers/net/netxen/netxen_nic_hw.c
+++ b/drivers/net/netxen/netxen_nic_hw.c
@@ -763,17 +763,19 @@ int netxen_get_flash_mac_addr(struct netxen_adapter *adapter, __le64 *mac)
 
 int netxen_p3_get_mac_addr(struct netxen_adapter *adapter, __le64 *mac)
 {
-	uint32_t crbaddr, mac_hi, mac_lo;
+	u32 crbaddr;
+	__le32 raw_mac_hi, raw_mac_lo;
+	u32 mac_hi, mac_lo;
 	int pci_func = adapter->ahw.pci_func;
 
 	crbaddr = CRB_MAC_BLOCK_START +
 		(4 * ((pci_func/2) * 3)) + (4 * (pci_func & 1));
 
-	adapter->hw_read_wx(adapter, crbaddr, &mac_lo, 4);
-	adapter->hw_read_wx(adapter, crbaddr+4, &mac_hi, 4);
+	adapter->hw_read_wx(adapter, crbaddr, &raw_mac_lo, 4);
+	adapter->hw_read_wx(adapter, crbaddr+4, &raw_mac_hi, 4);
 
-	mac_hi = cpu_to_le32(mac_hi);
-	mac_lo = cpu_to_le32(mac_lo);
+	mac_hi = le32_to_cpu(raw_mac_hi);
+	mac_lo = le32_to_cpu(raw_mac_lo);
 
 	if (pci_func & 1)
 		*mac = ((mac_lo >> 16) | ((u64)mac_hi << 16));
@@ -1459,7 +1461,7 @@ static int netxen_nic_pci_mem_read_direct(struct netxen_adapter *adapter,
 			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE * 2);
 		else
 			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
-		if (mem_ptr == 0UL) {
+		if (!mem_ptr) {
 			*(uint8_t  *)data = 0;
 			return -1;
 		}
-- 
1.6.0.3.723.g757e

