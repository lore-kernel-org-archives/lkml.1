Return-Path: <linux-kernel-owner+w=401wt.eu-S964845AbYD1RlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845AbYD1RlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935739AbYD1Rkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:40:43 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42201 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935709AbYD1Rkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:40:42 -0400
Date: Mon, 28 Apr 2008 20:40:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] mm/memory_hotplug.c must #include "internal.h"
Message-ID: <20080428174008.GX2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit 04753278769f3b6c3b79a080edb52f21d83bf6e2
(memory hotplug: register section/node id to free):

<--  snip  -->

...
  CC      mm/memory_hotplug.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/memory_hotplug.c: In function ‘put_page_bootmem’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/memory_hotplug.c:82: error: implicit declaration of function ‘__free_pages_bootmem’
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/memory_hotplug.c: At top level:
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/memory_hotplug.c:87: warning: no previous prototype for ‘register_page_bootmem_info_section’
make[2]: *** [mm/memory_hotplug.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
17f56d2d66ee41f504fcf0394687953c41afb8a4 diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c4ba85c..b17dca7 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -29,6 +29,8 @@
 
 #include <asm/tlbflush.h>
 
+#include "internal.h"
+
 /* add this memory to iomem resource */
 static struct resource *register_memory_resource(u64 start, u64 size)
 {

