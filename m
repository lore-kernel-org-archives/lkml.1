Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbZFQPht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbZFQPht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZFQPhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:37:40 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:39638 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905AbZFQPhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:37:39 -0400
Subject: [PATCH] kmemleak: Rename kmemleak_panic to kmemleak_stop
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1245245448.5604.31.camel@penberg-laptop>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org>
	 <20090616223649.719ea378.akpm@linux-foundation.org>
	 <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu>
	 <1245240677.11889.17.camel@pc1117.cambridge.arm.com>
	 <20090617122803.GD28529@csn.ul.ie>
	 <1245242160.11889.23.camel@pc1117.cambridge.arm.com>
	 <20090617124034.GE28529@csn.ul.ie>
	 <1245243130.11889.27.camel@pc1117.cambridge.arm.com>
	 <84144f020906170601l254d3b29udc688d02426ea247@mail.gmail.com>
	 <1245245007.11889.42.camel@pc1117.cambridge.arm.com>
	 <1245245448.5604.31.camel@penberg-laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 17 Jun 2009 16:36:59 +0100
Message-Id: <1245253019.11889.55.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2009 15:37:00.0734 (UTC) FILETIME=[74CEB5E0:01C9EF61]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to avoid the confusion created by the "panic" word.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---

(following Pekka's suggestion)

 mm/kmemleak.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 25e2034..c1f538e 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -251,7 +251,7 @@ static void kmemleak_disable(void);
  * recovered from. Kkmemleak will be disabled and further allocation/freeing
  * tracing no longer available.
  */
-#define kmemleak_panic(x...)	do {	\
+#define kmemleak_stop(x...)	do {	\
 	kmemleak_warn(x);		\
 	kmemleak_disable();		\
 } while (0)
@@ -467,8 +467,8 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
 
 	object = kmem_cache_alloc(object_cache, gfp & GFP_KMEMLEAK_MASK);
 	if (!object) {
-		kmemleak_panic("kmemleak: Cannot allocate a kmemleak_object "
-			       "structure\n");
+		kmemleak_stop("kmemleak: Cannot allocate a kmemleak_object "
+			      "structure\n");
 		return;
 	}
 
@@ -527,8 +527,8 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
 	if (node != &object->tree_node) {
 		unsigned long flags;
 
-		kmemleak_panic("kmemleak: Cannot insert 0x%lx into the object "
-			       "search tree (already existing)\n", ptr);
+		kmemleak_stop("kmemleak: Cannot insert 0x%lx into the object "
+			      "search tree (already existing)\n", ptr);
 		object = lookup_object(ptr, 1);
 		spin_lock_irqsave(&object->lock, flags);
 		dump_object_info(object);
@@ -699,7 +699,7 @@ static void log_early(int op_type, const void *ptr, size_t size,
 	struct early_log *log;
 
 	if (crt_early_log >= ARRAY_SIZE(early_log)) {
-		kmemleak_panic("kmemleak: Early log buffer exceeded\n");
+		kmemleak_stop("kmemleak: Early log buffer exceeded\n");
 		return;
 	}
 


