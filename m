Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0CEPnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:43:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57546 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab0CEPnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:43:16 -0500
Message-Id: <20100305154128.813452402@chello.nl>
References: <20100305153926.639506880@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 05 Mar 2010 16:39:28 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/5] perf, x86: Fix silly bug in data store buffer allocation
Content-Disposition: inline; filename=perf-fixup-intel-ds.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the ds allocation error path, where we could free @buffer
before we used it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -127,10 +127,8 @@ static int reserve_ds_buffers(void)
 
 		err = -ENOMEM;
 		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
-		if (unlikely(!ds)) {
-			kfree(buffer);
+		if (unlikely(!ds))
 			break;
-		}
 		per_cpu(cpu_hw_events, cpu).ds = ds;
 
 		if (x86_pmu.bts) {

-- 

