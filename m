Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbZFKPrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbZFKPrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZFKPrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:47:40 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52366 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZFKPrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:47:39 -0400
Date: Thu, 11 Jun 2009 18:47:40 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
cc: cl@linux-foundation.org, mingo@elte.hu, torvalds@linux-foundation.org
Subject: [PATCH] init: introduce mm_init()
Message-ID: <Pine.LNX.4.64.0906111846590.16970@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As suggested by Christoph Lameter, introduce mm_init() now that we initialize
all the kernel memory allocations together.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 init/main.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/init/main.c b/init/main.c
index 6d38f96..9e4bc82 100644
--- a/init/main.c
+++ b/init/main.c
@@ -533,6 +533,16 @@ void __init __weak thread_info_cache_init(void)
 {
 }
 
+static void __init mm_init(void)
+{
+	/*
+	 * Set up kernel memory allocators
+	 */
+	mem_init();
+	kmem_cache_init();
+	vmalloc_init();
+}
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
@@ -590,12 +600,7 @@ asmlinkage void __init start_kernel(void)
 	vfs_caches_init_early();
 	sort_main_extable();
 	trap_init();
-	/*
-	 * Set up kernel memory allocators
-	 */
-	mem_init();
-	kmem_cache_init();
-	vmalloc_init();
+	mm_init();
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
 	 * timer interrupt). Full topology setup happens at smp_init()
-- 
1.6.0.4

