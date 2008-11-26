Return-Path: <linux-kernel-owner+w=401wt.eu-S1752408AbYKZAfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbYKZAfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYKZAfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:35:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39002 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYKZAf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:35:29 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 26 Nov 2008 01:35:21 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: mark all hpsb_address_ops instances as const
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.0159ca29740012a7@s5r6.in-berlin.de>
Message-ID: <tkrat.00c6f6e85b9aada1@s5r6.in-berlin.de>
References: <tkrat.f8f7746d95c4ceee@s5r6.in-berlin.de>
 <tkrat.0159ca29740012a7@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are never modified.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/csr.c       |    8 ++++----
 drivers/ieee1394/eth1394.c   |    2 +-
 drivers/ieee1394/highlevel.c |    7 ++++---
 drivers/ieee1394/highlevel.h |    7 ++++---
 drivers/ieee1394/raw1394.c   |    2 +-
 drivers/ieee1394/sbp2.c      |    4 ++--
 6 files changed, 16 insertions(+), 14 deletions(-)

Index: linux/drivers/ieee1394/csr.c
===================================================================
--- linux.orig/drivers/ieee1394/csr.c
+++ linux/drivers/ieee1394/csr.c
@@ -68,22 +68,22 @@ static struct hpsb_highlevel csr_highlev
 	.host_reset =	host_reset,
 };
 
-static struct hpsb_address_ops map_ops = {
+const static struct hpsb_address_ops map_ops = {
 	.read = read_maps,
 };
 
-static struct hpsb_address_ops fcp_ops = {
+const static struct hpsb_address_ops fcp_ops = {
 	.write = write_fcp,
 };
 
-static struct hpsb_address_ops reg_ops = {
+const static struct hpsb_address_ops reg_ops = {
 	.read = read_regs,
 	.write = write_regs,
 	.lock = lock_regs,
 	.lock64 = lock64_regs,
 };
 
-static struct hpsb_address_ops config_rom_ops = {
+const static struct hpsb_address_ops config_rom_ops = {
 	.read = read_config_rom,
 };
 
Index: linux/drivers/ieee1394/eth1394.c
===================================================================
--- linux.orig/drivers/ieee1394/eth1394.c
+++ linux/drivers/ieee1394/eth1394.c
@@ -181,7 +181,7 @@ static void ether1394_remove_host(struct
 static void ether1394_host_reset(struct hpsb_host *host);
 
 /* Function for incoming 1394 packets */
-static struct hpsb_address_ops addr_ops = {
+const static struct hpsb_address_ops addr_ops = {
 	.write =	ether1394_write,
 };
 
Index: linux/drivers/ieee1394/highlevel.c
===================================================================
--- linux.orig/drivers/ieee1394/highlevel.c
+++ linux/drivers/ieee1394/highlevel.c
@@ -320,7 +320,7 @@ void hpsb_unregister_highlevel(struct hp
  */
 u64 hpsb_allocate_and_register_addrspace(struct hpsb_highlevel *hl,
 					 struct hpsb_host *host,
-					 struct hpsb_address_ops *ops,
+					 const struct hpsb_address_ops *ops,
 					 u64 size, u64 alignment,
 					 u64 start, u64 end)
 {
@@ -407,7 +407,8 @@ u64 hpsb_allocate_and_register_addrspace
  * are automatically deallocated together with the hpsb_highlevel @hl.
  */
 int hpsb_register_addrspace(struct hpsb_highlevel *hl, struct hpsb_host *host,
-			    struct hpsb_address_ops *ops, u64 start, u64 end)
+			    const struct hpsb_address_ops *ops,
+			    u64 start, u64 end)
 {
 	struct hpsb_address_serve *as;
 	struct list_head *lh;
@@ -477,7 +478,7 @@ int hpsb_unregister_addrspace(struct hps
 	return retval;
 }
 
-static struct hpsb_address_ops dummy_ops;
+const static struct hpsb_address_ops dummy_ops;
 
 /* dummy address spaces as lower and upper bounds of the host's a.s. list */
 static void init_hpsb_highlevel(struct hpsb_host *host)
Index: linux/drivers/ieee1394/highlevel.h
===================================================================
--- linux.orig/drivers/ieee1394/highlevel.h
+++ linux/drivers/ieee1394/highlevel.h
@@ -15,7 +15,7 @@ struct hpsb_host;
 struct hpsb_address_serve {
 	struct list_head host_list;	/* per host list */
 	struct list_head hl_list;	/* hpsb_highlevel list */
-	struct hpsb_address_ops *op;
+	const struct hpsb_address_ops *op;
 	struct hpsb_host *host;
 	u64 start;	/* first address handled, quadlet aligned */
 	u64 end;	/* first address behind, quadlet aligned */
@@ -119,11 +119,12 @@ void hpsb_unregister_highlevel(struct hp
 
 u64 hpsb_allocate_and_register_addrspace(struct hpsb_highlevel *hl,
 					 struct hpsb_host *host,
-					 struct hpsb_address_ops *ops,
+					 const struct hpsb_address_ops *ops,
 					 u64 size, u64 alignment,
 					 u64 start, u64 end);
 int hpsb_register_addrspace(struct hpsb_highlevel *hl, struct hpsb_host *host,
-			    struct hpsb_address_ops *ops, u64 start, u64 end);
+			    const struct hpsb_address_ops *ops,
+			    u64 start, u64 end);
 int hpsb_unregister_addrspace(struct hpsb_highlevel *hl, struct hpsb_host *host,
 			      u64 start);
 
Index: linux/drivers/ieee1394/raw1394.c
===================================================================
--- linux.orig/drivers/ieee1394/raw1394.c
+++ linux/drivers/ieee1394/raw1394.c
@@ -90,7 +90,7 @@ static int arm_lock(struct hpsb_host *ho
 static int arm_lock64(struct hpsb_host *host, int nodeid, octlet_t * store,
 		      u64 addr, octlet_t data, octlet_t arg, int ext_tcode,
 		      u16 flags);
-static struct hpsb_address_ops arm_ops = {
+const static struct hpsb_address_ops arm_ops = {
 	.read = arm_read,
 	.write = arm_write,
 	.lock = arm_lock,
Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -265,7 +265,7 @@ static struct hpsb_highlevel sbp2_highle
 	.host_reset	= sbp2_host_reset,
 };
 
-static struct hpsb_address_ops sbp2_ops = {
+const static struct hpsb_address_ops sbp2_ops = {
 	.write		= sbp2_handle_status_write
 };
 
@@ -275,7 +275,7 @@ static int sbp2_handle_physdma_write(str
 static int sbp2_handle_physdma_read(struct hpsb_host *, int, quadlet_t *, u64,
 				    size_t, u16);
 
-static struct hpsb_address_ops sbp2_physdma_ops = {
+const static struct hpsb_address_ops sbp2_physdma_ops = {
 	.read		= sbp2_handle_physdma_read,
 	.write		= sbp2_handle_physdma_write,
 };

-- 
Stefan Richter
-=====-==--- =-== ==-=-
http://arcgraph.de/sr/

