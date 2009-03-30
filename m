Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbZC3ROk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbZC3ROk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbZC3RL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52297 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbZC3RLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:24 -0400
Message-Id: <20090330171023.792822360@chello.nl>
References: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:09 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/15] perf_counter: x86: proper error propagation for the x86 hw_perf_counter_init()
Content-Disposition: inline; filename=perf_counter-x86-error.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that Paul cleaned up the error propagation paths, pass down the
x86 error as well.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -954,7 +954,7 @@ hw_perf_counter_init(struct perf_counter
 
 	err = __hw_perf_counter_init(counter);
 	if (err)
-		return NULL;
+		return ERR_PTR(err);
 
 	return &x86_perf_counter_ops;
 }

-- 

