Return-Path: <linux-kernel-owner+w=401wt.eu-S933314AbZKXPKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbZKXPKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933272AbZKXPHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:07:51 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45499 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933248AbZKXPHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:47 -0500
Message-Id: <20091124150752.776353000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:07 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 10/29] GRU - Support 64-bit GRU addresses
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_vaddr_msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Increase the maximum address supported by the SGI GRU
driver to a full 64 bits. Note that GRU addresses are not
always the same as socket virtual addresses. Sockets may not
necessarily support the full 64 bits.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grutables.h |    6 ------
 1 file changed, 6 deletions(-)

Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-11-20 09:32:29.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-11-20 09:32:31.000000000 -0600
@@ -293,13 +293,7 @@ extern struct mcs_op_statistic mcs_op_st
 #define ASID_INC	8	/* number of regions */
 
 /* Generate a GRU asid value from a GRU base asid & a virtual address. */
-#if defined CONFIG_IA64
 #define VADDR_HI_BIT		64
-#elif defined CONFIG_X86_64
-#define VADDR_HI_BIT		48
-#else
-#error "Unsupported architecture"
-#endif
 #define GRUREGION(addr)		((addr) >> (VADDR_HI_BIT - 3) & 3)
 #define GRUASID(asid, addr)	((asid) + GRUREGION(addr))
 

