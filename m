Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYCZBi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYCZBi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 21:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYCZBiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 21:38:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53168 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165AbYCZBiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 21:38:14 -0400
Message-Id: <20080326013812.474773000@polaris-admin.engr.sgi.com>
References: <20080326013811.569646000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Mar 2008 18:38:16 -0700
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 05/12] init: move large array from stack to _initdata section
Content-Disposition: inline; filename=numa_initmem_init
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move large array "struct bootnode nodes" from stack to _initdata
section.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/mm/numa_64.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux.trees.git.orig/arch/x86/mm/numa_64.c
+++ linux.trees.git/arch/x86/mm/numa_64.c
@@ -411,9 +411,10 @@ static int __init split_nodes_by_size(st
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
