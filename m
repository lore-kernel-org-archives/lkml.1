Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbZHNS4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbZHNS4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 14:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZHNS4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 14:56:22 -0400
Received: from relay1.sgi.com ([192.48.179.29]:47548 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753213AbZHNS4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 14:56:22 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV BAU destination subnode id
Cc: mingo@elte.hu
Message-Id: <E1Mc1x7-0005Ce-6t@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Fri, 14 Aug 2009 13:56:37 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

The SGI UV Broadcast Assist Unit is used to send TLB shootdown messages
to remote nodes of the system.  The header of the message must contain
the subnode id of the block in the receiving hub that handles such
messages.  It should always be 0x10, the id of the "LB" block.

It had previously been documented as a "must be zero" field.

Diffed against 2.6.31-rc6

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |    2 +-
 arch/x86/kernel/tlb_uv.c         |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -744,6 +744,7 @@ uv_activation_descriptor_init(int node, 
 		 * note that base_dest_nodeid is actually a nasid.
 		 */
 		ad2->header.base_dest_nodeid = uv_partition_base_pnode << 1;
+		ad2->header.dest_subnodeid = 0x10; /* the LB */
 		ad2->header.command = UV_NET_ENDPOINT_INTD;
 		ad2->header.int_both = 1;
 		/*
Index: linux/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linux/arch/x86/include/asm/uv/uv_bau.h
@@ -133,7 +133,7 @@ struct bau_msg_payload {
  * see table 4.2.3.0.1 in broacast_assist spec.
  */
 struct bau_msg_header {
-	unsigned int dest_subnodeid:6;	/* must be zero */
+	unsigned int dest_subnodeid:6;	/* must be 0x10, for the LB */
 	/* bits 5:0 */
 	unsigned int base_dest_nodeid:15; /* nasid>>1 (pnode) of */
 	/* bits 20:6 */			  /* first bit in node_map */
