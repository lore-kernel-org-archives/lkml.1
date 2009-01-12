Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbZALWH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbZALWH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbZALWF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:05:29 -0500
Received: from relay1.sgi.com ([192.48.179.29]:54672 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753221AbZALWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:05:22 -0500
Message-Id: <20090112220519.746125000@polaris-admin.engr.sgi.com>
References: <20090112220519.566749000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 12 Jan 2009 14:05:20 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>
Subject: [PATCH 1/8] alpha irq: update alpha for new irq_desc
Content-Disposition: inline; filename=irq:update-alpha-to-new-irq_desc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, update to new cpumask API

Irq_desc.affinity and irq_desc.pending_mask are now cpumask_var_t's
so access to them should be using the new cpumask API.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6-for-ingo.orig/arch/alpha/kernel/irq.c
+++ linux-2.6-for-ingo/arch/alpha/kernel/irq.c
@@ -55,7 +55,7 @@ int irq_select_affinity(unsigned int irq
 		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
-	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
+	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
 	irq_desc[irq].chip->set_affinity(irq, cpumask_of(cpu));
 	return 0;
 }

-- 
