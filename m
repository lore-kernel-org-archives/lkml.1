Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbXIYXsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbXIYXsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbXIYXnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:43:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57667 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752882AbXIYXmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:53 -0400
Message-Id: <20070925234252.445908000@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:18 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [14/17] Allow bit_waitqueue to wait on a bit in a vmalloc area
Content-Disposition: inline; filename=vcompound_wait_on_virtually_mapped_object
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If bit waitqueue is passed a virtual address then it must use
vmalloc_to_page instead of virt_to_page to get to the page struct.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 kernel/wait.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/wait.c
===================================================================
--- linux-2.6.orig/kernel/wait.c	2007-09-20 19:03:42.000000000 -0700
+++ linux-2.6/kernel/wait.c	2007-09-20 19:07:42.000000000 -0700
@@ -245,7 +245,7 @@ EXPORT_SYMBOL(wake_up_bit);
 fastcall wait_queue_head_t *bit_waitqueue(void *word, int bit)
 {
 	const int shift = BITS_PER_LONG == 32 ? 5 : 6;
-	const struct zone *zone = page_zone(virt_to_page(word));
+	const struct zone *zone = page_zone(addr_to_page(word));
 	unsigned long val = (unsigned long)word << shift | bit;
 
 	return &zone->wait_table[hash_long(val, zone->wait_table_bits)];

-- 
