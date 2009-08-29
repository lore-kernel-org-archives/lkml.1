Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbZH2N7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbZH2N7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 09:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZH2N7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 09:59:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:36539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbZH2N7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 09:59:05 -0400
Date: Sat, 29 Aug 2009 13:58:45 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A95C350.8060308@kernel.org>
References: <4A95C350.8060308@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irq: Add irq_node() primitive
Message-ID: <tip-5bfb5b51382f4bd01d9ced11503264d2cc74fe41@git.kernel.org>
Git-Commit-ID: 5bfb5b51382f4bd01d9ced11503264d2cc74fe41
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 29 Aug 2009 13:58:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5bfb5b51382f4bd01d9ced11503264d2cc74fe41
Gitweb:     http://git.kernel.org/tip/5bfb5b51382f4bd01d9ced11503264d2cc74fe41
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 26 Aug 2009 16:20:48 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 29 Aug 2009 15:53:00 +0200

irq: Add irq_node() primitive

... to return irq_desc node info without #ifdefs at the callsites.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <4A95C350.8060308@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/irqnr.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index ec87b21..7bf89bc 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -41,6 +41,12 @@ extern struct irq_desc *irq_to_desc(unsigned int irq);
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
