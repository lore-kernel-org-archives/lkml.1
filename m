Return-Path: <linux-kernel-owner+w=401wt.eu-S1759900AbYCUGXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbYCUGXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 02:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbYCUGTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 02:19:30 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53284 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753509AbYCUGSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 02:18:55 -0400
Message-Id: <20080321061726.192070985@sgi.com>
References: <20080321061703.921169367@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Mar 2008 23:17:12 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: [09/14] vcompound: crypto: Fallback for temporary order 2 allocation
Content-Disposition: inline; filename=0012-vcompound-crypto-Fallback-for-temporary-order-2-al.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The crypto subsystem needs an order 2 allocation. This is a temporary buffer
for xoring data so we can safely allow fallback.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 crypto/xor.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.25-rc5-mm1/crypto/xor.c
===================================================================
--- linux-2.6.25-rc5-mm1.orig/crypto/xor.c	2008-03-20 18:04:44.649120096 -0700
+++ linux-2.6.25-rc5-mm1/crypto/xor.c	2008-03-20 19:41:35.383789613 -0700
@@ -101,7 +101,7 @@ calibrate_xor_blocks(void)
 	void *b1, *b2;
 	struct xor_block_template *f, *fastest;
 
-	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
+	b1 = __alloc_vcompound(GFP_KERNEL, 2);
 	if (!b1) {
 		printk(KERN_WARNING "xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -140,7 +140,7 @@ calibrate_xor_blocks(void)
 
 #undef xor_speed
 
-	free_pages((unsigned long)b1, 2);
+	__free_vcompound(b1);
 
 	active_template = fastest;
 	return 0;

-- 
