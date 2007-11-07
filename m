Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbXKGOVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbXKGOVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbXKGOUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:20:42 -0500
Received: from il.qumranet.com ([82.166.9.18]:50640 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757710AbXKGOUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:20:40 -0500
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 4/8] KVM: PVDMA: Introduce is_pv_device() dma operation
Date: Wed,  7 Nov 2007 16:21:05 +0200
Message-Id: <1194445269859-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11944452694052-git-send-email-amit.shah@qumranet.com>
References: <1194445269752-git-send-email-amit.shah@qumranet.com>
 <11944452691714-git-send-email-amit.shah@qumranet.com>
 <11944452692774-git-send-email-amit.shah@qumranet.com>
 <11944452694052-git-send-email-amit.shah@qumranet.com>
Message-Id: <218cf425feff1d4daf23d3f25df1eb224108a1a3.1194445109.git.amit.shah@qumranet.com>
In-Reply-To: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A guest can call dma_ops->is_pv_device() to find out
if a device is a passthrough'ed device (device passed
on to a guest by the host). If this is true, a hypercall
will be made to translate DMA mapping operations.

This function can be done away with and just a
kvm_is_pv_device() call can be added, which can be no-op
on a non-pv guest (or on the host).

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 include/asm-x86/dma-mapping_64.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index ecd0f61..3943edd 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -48,6 +48,8 @@ struct dma_mapping_ops {
 				int direction);
 	int             (*dma_supported)(struct device *hwdev, u64 mask);
 	int		is_phys;
+	/* Is this a physical device in a paravirtualized guest? */
+	int		(*is_pv_device)(struct device *hwdev, const char *name);
 };
 
 extern dma_addr_t bad_dma_address;
-- 
1.5.3

