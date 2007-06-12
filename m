Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbXFLLH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbXFLLH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 07:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbXFLLHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 07:07:41 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60568 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753155AbXFLLHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 07:07:40 -0400
Date: Tue, 12 Jun 2007 13:07:52 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make mm/swap_prefetch.c:remove_from_swapped_list()
	static
Message-ID: <20070612110752.GW3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remove_from_swapped_list() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/linux/swap-prefetch.h |    5 -----
 mm/swap_prefetch.c            |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

--- linux-2.6.22-rc4-mm2/include/linux/swap-prefetch.h.old	2007-06-12 02:14:51.000000000 +0200
+++ linux-2.6.22-rc4-mm2/include/linux/swap-prefetch.h	2007-06-12 02:14:59.000000000 +0200
@@ -33,7 +33,6 @@
 }
 
 extern void add_to_swapped_list(struct page *page);
-extern void remove_from_swapped_list(const unsigned long index);
 extern void delay_swap_prefetch(void);
 extern void prepare_swap_prefetch(void);
 
@@ -46,10 +45,6 @@
 {
 }
 
-static inline void remove_from_swapped_list(const unsigned long __unused)
-{
-}
-
 static inline void delay_swap_prefetch(void)
 {
 }
--- linux-2.6.22-rc4-mm2/mm/swap_prefetch.c.old	2007-06-12 02:15:09.000000000 +0200
+++ linux-2.6.22-rc4-mm2/mm/swap_prefetch.c	2007-06-12 02:15:18.000000000 +0200
@@ -139,7 +139,7 @@
  * look up the entry from the index without having to iterate over the whole
  * list.
  */
-void remove_from_swapped_list(const unsigned long index)
+static void remove_from_swapped_list(const unsigned long index)
 {
 	struct swapped_entry *entry;
 	unsigned long flags;

