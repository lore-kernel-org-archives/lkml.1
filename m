Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbXJDEG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbXJDEG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbXJDEAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:00:31 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53776 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750975AbXJDEAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:00:06 -0400
Message-Id: <20071004040005.171632278@sgi.com>
References: <20071004035935.042951211@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Oct 2007 20:59:50 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>
Subject: [15/18] Fallback for temporary order 2 allocation
Content-Disposition: inline; filename=vcompound_crypto
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The cryto subsystem needs an order 2 allocation. This is a temporary buffer
for xoring data so we can safely allow fallback.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 crypto/xor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/crypto/xor.c
===================================================================
--- linux-2.6.orig/crypto/xor.c	2007-10-03 18:11:20.000000000 -0700
+++ linux-2.6/crypto/xor.c	2007-10-03 18:12:14.000000000 -0700
@@ -101,7 +101,7 @@ calibrate_xor_blocks(void)
 	void *b1, *b2;
 	struct xor_block_template *f, *fastest;
 
-	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
+	b1 = (void *) __get_free_pages(GFP_VFALLBACK, 2);
 	if (!b1) {
 		printk(KERN_WARNING "xor: Yikes!  No memory available.\n");
 		return -ENOMEM;

-- 
