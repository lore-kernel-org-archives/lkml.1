Return-Path: <linux-kernel-owner+w=401wt.eu-S948180AbXHMPRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948180AbXHMPRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935052AbXHMNDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:03:51 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:59215 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030914AbXHMNDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:03:49 -0400
Subject: [kj] is_power_of_2 in mm/slub.c
From: vignesh babu <vignesh.babu@wipro.com>
Reply-To: vigneshbabu@gmail.com
To: clameter@sgi.com
Cc: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: WIPRO Technologies
Date: Mon, 13 Aug 2007 18:33:13 +0530
Message-Id: <1187010193.7273.15.camel@merlin.linuxcoe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
X-OriginalArrivalTime: 13 Aug 2007 13:04:08.0110 (UTC) FILETIME=[6F13DCE0:01C7DDAA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing n & (n - 1) for power of 2 check by is_power_of_2(n)

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
---
diff --git a/mm/slub.c b/mm/slub.c
index 69d02e3..1241d14 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -20,6 +20,7 @@
 #include <linux/mempolicy.h>
 #include <linux/ctype.h>
 #include <linux/kallsyms.h>
+#include <linux/log2.h>
 
 /*
  * Lock order:
@@ -2606,7 +2607,7 @@ void __init kmem_cache_init(void)
 	 * around with ARCH_KMALLOC_MINALIGN
 	 */
 	BUILD_BUG_ON(KMALLOC_MIN_SIZE > 256 ||
-		(KMALLOC_MIN_SIZE & (KMALLOC_MIN_SIZE - 1)));
+		!is_power_of_2(KMALLOC_MIN_SIZE));
 
 	for (i = 8; i < KMALLOC_MIN_SIZE; i += 8)
 		size_index[(i - 1) / 8] = KMALLOC_SHIFT_LOW;

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"

