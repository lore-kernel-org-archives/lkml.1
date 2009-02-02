Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbZBBXEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbZBBXEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZBBXEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:04:42 -0500
Received: from relay3.sgi.com ([192.48.171.31]:33258 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753212AbZBBXEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:04:41 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86: UV uv_flush_tlb_others WARN_ON
Cc: mingo@elte.hu, tj@kernel.org
Message-Id: <E1LU7sT-0004ZT-9G@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Mon, 02 Feb 2009 17:06:53 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Cliff Wickman <cpw@sgi.com>

uv_flush_tlb_others() (arch/x86/kernel/tlb_uv.c)
The "WARN_ON(!in_atomic())" fails if CONFIG_PREEMPT is not enabled.
And CONFIG_PREEMPT is not enabled by default in the distribution that
most UV owners will use.

We could #ifdef CONFIG_PREEMPT the warning, but that is not good form.

And there seems to be no suitable fix to in_atomic() when CONFIG_PREMPT
is not on.
  As you commented, Ingo:
  > and we have no proper primitive to test for atomicity. (mainly
  > because we dont know about atomicity on a non-preempt kernel)

I propose that we drop the WARN_ON.

Diffed against 2.6.29-rc2

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -316,8 +316,6 @@ const struct cpumask *uv_flush_tlb_other
 	int locals = 0;
 	struct bau_desc *bau_desc;
 
-	WARN_ON(!in_atomic());
-
 	cpumask_andnot(flush_mask, cpumask, cpumask_of(cpu));
 
 	uv_cpu = uv_blade_processor_id();
