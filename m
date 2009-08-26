Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZHZXVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZHZXVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 19:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZHZXVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 19:21:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:55269 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbZHZXVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 19:21:37 -0400
Message-ID: <4A95C350.8060308@kernel.org>
Date: Wed, 26 Aug 2009 16:20:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] irq: add irq_node
References: <20090826214323.GC25536@elte.hu> <4A95C32D.5040605@kernel.org>
In-Reply-To: <4A95C32D.5040605@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


to return irq_desc node info

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 include/linux/irqnr.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/include/linux/irqnr.h
===================================================================
--- linux-2.6.orig/include/linux/irqnr.h
+++ linux-2.6/include/linux/irqnr.h
@@ -41,6 +41,12 @@ extern struct irq_desc *irq_to_desc(unsi
 			;						\
 		else
 
+#ifdef CONFIG_SMP
+#define irq_node(irq)	(irq_to_desc(irq)->node)
+#else
+#define irq_node(irq)	0
+#endif
+
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #define for_each_irq_nr(irq)                   \
