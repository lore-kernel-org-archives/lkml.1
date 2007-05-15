Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbXEOSvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbXEOSvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbXEOSv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:51:28 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:21769 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbXEOSv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:51:28 -0400
Date: Tue, 15 May 2007 19:51:05 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andi Kleen <ak@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] i386: don't check_pgt_cache in flush_tlb_mm
Message-ID: <Pine.LNX.4.64.0705151946550.30826@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 15 May 2007 18:51:26.0074 (UTC) FILETIME=[0A4B55A0:01C79722]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGFrQHN1c2UuZGUAbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAGNsYW1ldGVyQHNnaS5jb20AZGF2ZW1AZGF2ZW1sb2Z0Lm5ldAB3bGlAaG9sb21vcnBoeS5jb20A
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No other architecture calls check_pgt_cache() from within flush_tlb_mm(),
and i386 is already calling check_pgt_cache() from the usual places,
tlb_finish_mmu() and cpu_idle() (the latter being odd, but not unusual).
flush_tlb_mm() has no business to be freeing pages: remove that line,
which sneaked in with slub's i386 support.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
 arch/i386/kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.22-rc1/arch/i386/kernel/smp.c	2007-05-13 05:40:51.000000000 +0100
+++ linux/arch/i386/kernel/smp.c	2007-05-15 17:49:48.000000000 +0100
@@ -421,7 +421,7 @@ void flush_tlb_mm (struct mm_struct * mm
 	}
 	if (!cpus_empty(cpu_mask))
 		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-	check_pgt_cache();
+
 	preempt_enable();
 }
 
