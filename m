Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbYCUGWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbYCUGWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 02:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbYCUGTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 02:19:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48953 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753465AbYCUGSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 02:18:54 -0400
Message-Id: <20080321061725.701640800@sgi.com>
References: <20080321061703.921169367@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Mar 2008 23:17:10 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [07/14] vcompound: bit waitqueue support
Content-Disposition: inline; filename=0011-vcompound-bit-waitqueue-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If bit_waitqueue is passed a vmalloc address then it must use
vmalloc_head_page() instead of virt_to_page().

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 kernel/wait.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.25-rc5-mm1/kernel/wait.c
===================================================================
--- linux-2.6.25-rc5-mm1.orig/kernel/wait.c	2008-03-20 20:03:51.141901370 -0700
+++ linux-2.6.25-rc5-mm1/kernel/wait.c	2008-03-20 20:07:57.266856571 -0700
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/wait.h>
 #include <linux/hash.h>
+#include <linux/vmalloc.h>
 
 void init_waitqueue_head(wait_queue_head_t *q)
 {
@@ -245,7 +246,7 @@ EXPORT_SYMBOL(wake_up_bit);
 wait_queue_head_t *bit_waitqueue(void *word, int bit)
 {
 	const int shift = BITS_PER_LONG == 32 ? 5 : 6;
-	const struct zone *zone = page_zone(virt_to_page(word));
+	const struct zone *zone = page_zone(vcompound_head_page(word));
 	unsigned long val = (unsigned long)word << shift | bit;
 
 	return &zone->wait_table[hash_long(val, zone->wait_table_bits)];

-- 
