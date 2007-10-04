Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbXJDEFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbXJDEFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbXJDEA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:00:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37869 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbXJDEAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:00:06 -0400
Message-Id: <20071004040004.482614498@sgi.com>
References: <20071004035935.042951211@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Oct 2007 20:59:47 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [12/18] Wait: Allow bit_waitqueue to wait on a bit in a virtual compound page
Content-Disposition: inline; filename=vcompound_wait_on_virtually_mapped_object
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If bit waitqueue is passed a virtual address then it must use
virt_to_head_page instead of virt_to_page.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 kernel/wait.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/wait.c
===================================================================
--- linux-2.6.orig/kernel/wait.c	2007-10-03 17:44:21.000000000 -0700
+++ linux-2.6/kernel/wait.c	2007-10-03 17:53:07.000000000 -0700
@@ -245,7 +245,7 @@ EXPORT_SYMBOL(wake_up_bit);
 fastcall wait_queue_head_t *bit_waitqueue(void *word, int bit)
 {
 	const int shift = BITS_PER_LONG == 32 ? 5 : 6;
-	const struct zone *zone = page_zone(virt_to_page(word));
+	const struct zone *zone = page_zone(virt_to_head_page(word));
 	unsigned long val = (unsigned long)word << shift | bit;
 
 	return &zone->wait_table[hash_long(val, zone->wait_table_bits)];

-- 
