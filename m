Return-Path: <linux-kernel-owner+w=401wt.eu-S1751514AbZHSJXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbZHSJXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZHSJXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:23:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33190 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZHSJW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:22:59 -0400
Message-Id: <20090819092023.812428023@chello.nl>
References: <20090819091823.916851355@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 19 Aug 2009 11:18:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] perf_counter: powerpc: Support the anonymized kernel callchain bits
Content-Disposition: inline; filename=perf-sekure-ppc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for anonymized kernel callchains to the powerpc callchain
code.

This patch is not folded into the patch that introduces this feature
because the powerpc callchain code isn't upstream yet, and this allows
re-ordering the patches.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_callchain.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/arch/powerpc/kernel/perf_callchain.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_callchain.c
+++ linux-2.6/arch/powerpc/kernel/perf_callchain.c
@@ -70,6 +70,11 @@ static void perf_callchain_kernel(struct
 	lr = regs->link;
 	sp = regs->gpr[1];
 	callchain_store(entry, PERF_CONTEXT_KERNEL);
+	next_ip = perf_paranoid_anon_ip();
+	if (next_ip) {
+		callchain_store(entry, next_ip);
+		return;
+	}
 	callchain_store(entry, regs->nip);
 
 	if (!validate_sp(sp, current, STACK_FRAME_OVERHEAD))

-- 

