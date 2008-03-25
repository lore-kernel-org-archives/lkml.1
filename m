Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbYCYCcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbYCYCcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYCYCb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:31:27 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44674 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752132AbYCYCbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:31:22 -0400
Message-Id: <20080325023121.727305000@polaris-admin.engr.sgi.com>
References: <20080325023120.859257000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 24 Mar 2008 19:31:25 -0700
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 05/12] init: move large array from stack to _initdata section
Content-Disposition: inline; filename=numa_initmem_init
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move large array "struct bootnode nodes" from stack to _initdata
section.

Based on linux-2.6.25-rc5-mm1

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/mm/numa_64.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.25-rc5.orig/arch/x86/mm/numa_64.c
+++ linux-2.6.25-rc5/arch/x86/mm/numa_64.c
@@ -381,9 +381,10 @@ static int __init split_nodes_by_size(st
  * Sets up the system RAM area from start_pfn to end_pfn according to the
  * numa=fake command-line option.
  */
+static struct bootnode nodes[MAX_NUMNODES] __initdata;
+
 static int __init numa_emulation(unsigned long start_pfn, unsigned long end_pfn)
 {
-	struct bootnode nodes[MAX_NUMNODES];
 	u64 size, addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = end_pfn << PAGE_SHIFT;
 	int num_nodes = 0, num = 0, coeff_flag, coeff = -1, i;

-- 
