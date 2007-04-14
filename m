Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXDNVVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXDNVVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXDNVUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:20:16 -0400
Received: from gw.goop.org ([64.81.55.164]:59524 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbXDNVUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:13 -0400
Message-Id: <20070414204923.594579484@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:41:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/28] fix allow-percpu-variables-to-be-page-aligned.patch
Content-Disposition: inline; filename=fix-ff-allow-percpu-variables-to-be-page-aligned.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure allocation is page-aligned.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/init/main.c
+++ b/init/main.c
@@ -370,7 +370,7 @@ static void __init setup_per_cpu_areas(v
 
 	/* Copy section for each CPU (we discard the original) */
 	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
-	ptr = alloc_bootmem(size * nr_possible_cpus);
+	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
 		__per_cpu_offset[i] = ptr - __per_cpu_start;

-- 

