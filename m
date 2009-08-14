Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbZHNBq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbZHNBq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 21:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZHNBq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 21:46:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:54856 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbZHNBq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 21:46:26 -0400
Message-ID: <4A84C190.1060005@kernel.org>
Date: Thu, 13 Aug 2009 18:44:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH] irq: add irq_node
References: <4A84C13E.5050606@kernel.org>
In-Reply-To: <4A84C13E.5050606@kernel.org>
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
