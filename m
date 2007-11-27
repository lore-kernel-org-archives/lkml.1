Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbXK0ASn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbXK0ASn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbXK0AOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:14:42 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49160 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757601AbXK0AOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:14:35 -0500
Message-Id: <20071127001429.624026039@sgi.com>
References: <20071127001407.859743255@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Nov 2007 16:14:09 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>
Subject: [patch 02/14] Modules: Include sections.h to avoid defining linker variables explicitly
Content-Disposition: inline; filename=mod_sections
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Module.c should not define linker variables on its own. We have an include
file for that.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 kernel/module.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c	2007-11-21 13:11:28.495858392 -0800
+++ linux-2.6/kernel/module.c	2007-11-21 13:11:29.322858718 -0800
@@ -46,6 +46,7 @@
 #include <asm/semaphore.h>
 #include <asm/cacheflush.h>
 #include <linux/license.h>
+#include <asm/sections.h>
 
 extern int module_sysfs_initialized;
 
@@ -338,9 +339,6 @@ static inline unsigned int block_size(in
 	return val;
 }
 
-/* Created by linker magic */
-extern char __per_cpu_start[], __per_cpu_end[];
-
 static void *percpu_modalloc(unsigned long size, unsigned long align,
 			     const char *name)
 {

-- 
