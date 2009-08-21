Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbZHUIhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbZHUIhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 04:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbZHUIhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 04:37:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbZHUIhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 04:37:47 -0400
Date: Fri, 21 Aug 2009 04:34:45 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, yinghai@kernel.org,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20090821083709.5098.52505.sendpatchset@localhost.localdomain>
Subject: [Patch] x86: fix a wrong argument of reserve_bootmem()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This line looks suspicious, because if this is true, then the 'flags' parameter
of function reserve_bootmem_generic() will be unused when !CONFIG_NUMA.
I don't think this is what we want.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>

---
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 6176fe8..ea56b8c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -796,7 +796,7 @@ int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 		return ret;
 
 #else
-	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
+	reserve_bootmem(phys, len, flags);
 #endif
 
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
