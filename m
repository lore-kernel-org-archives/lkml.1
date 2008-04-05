Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYDEBLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYDEBLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYDEBLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56576 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751641AbYDEBLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:03 -0400
Message-Id: <20080405011102.347280000@polaris-admin.engr.sgi.com>
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:09 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] numa: move large array from stack to _initdata section
Content-Disposition: inline; filename=numa_initmem_init
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Move large array "struct bootnode nodes" from stack to _initdata
    section to reduce amount of stack space required.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/mm/numa_64.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.x86.orig/arch/x86/mm/numa_64.c
+++ linux-2.6.x86/arch/x86/mm/numa_64.c
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
