Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbZALWGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbZALWGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZALWF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:05:27 -0500
Received: from relay3.sgi.com ([192.48.171.31]:46127 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753624AbZALWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:05:22 -0500
Message-Id: <20090112220520.035880000@polaris-admin.engr.sgi.com>
References: <20090112220519.566749000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 12 Jan 2009 14:05:22 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/8] blackfin irq: update blackfin for new irq_desc
Content-Disposition: inline; filename=irq:update-blackfin-to-new-irq_desc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, update to new cpumask API

Irq_desc.affinity and irq_desc.pending_mask are now cpumask_var_t's
so access to them should be using the new cpumask API.

Since CONFIG_CPUMASK_OFFSTACK is not likely to be enabled for the blackfin
architecture, double check that it is indeed not set, as we do not
allocate any variable-sized cpumask_var_t's.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/kernel/irqchip.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6-for-ingo.orig/arch/blackfin/kernel/irqchip.c
+++ linux-2.6-for-ingo/arch/blackfin/kernel/irqchip.c
@@ -69,6 +69,11 @@ static struct irq_desc bad_irq_desc = {
 #endif
 };
 
+#ifdef CONFIG_CPUMASK_OFFSTACK
+/* We are not allocating a variable-sized bad_irq_desc.affinity */
+#error "Blackfin architecture does not support CONFIG_CPUMASK_OFFSTACK."
+#endif
+
 int show_interrupts(struct seq_file *p, void *v)
 {
 	int i = *(loff_t *) v, j;

-- 
