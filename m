Return-Path: <linux-kernel-owner+w=401wt.eu-S933431AbZKXPNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431AbZKXPNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933225AbZKXPNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:13:16 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57688 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933224AbZKXPHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:44 -0500
Message-Id: <20091124150750.595104000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:01 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 04/29] GRU - handle blades without memory
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_table_alloc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Do not use alloc_pages_exact_node() to allocate GRU tables. If
a blade has no local memory, nid will be -1. Use alloc_pages_node()
instead.


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/grufile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2009-11-20 09:32:26.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufile.c	2009-11-20 09:32:28.000000000 -0600
@@ -266,8 +266,8 @@ static int gru_init_tables(unsigned long
 	max_user_dsr_bytes = GRU_NUM_DSR_BYTES;
 	for_each_possible_blade(bid) {
 		pnode = uv_blade_to_pnode(bid);
-		nid = uv_blade_to_memory_nid(bid);
-		page = alloc_pages_exact_node(nid, GFP_KERNEL, order);
+		nid = uv_blade_to_memory_nid(bid);/* -1 if no memory on blade */
+		page = alloc_pages_node(nid, GFP_KERNEL, order);
 		if (!page)
 			goto fail;
 		gru_base[bid] = page_address(page);

