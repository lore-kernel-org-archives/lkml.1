Return-Path: <linux-kernel-owner+w=401wt.eu-S1757681AbYH1BJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbYH1BJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbYH1BJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:09:24 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:54958 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbYH1BJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:09:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Tgj5SPwNd4u3J1GwDWpFVXBESIIGlZ58Qx2D80iMvyu+MPkFESWRgHq9MzR0nRKnvh
         vm4yVqA39MXKHQYc89FaF8Xa8jjnD7JTcOT8/ttLESqPvLzQGLWiW5X08YM55rMQCX6h
         d4jS0jfdMgLFvRFANfntXmC3PAQTP+e6Y3x6Y=
Date: Thu, 28 Aug 2008 05:10:57 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Less softirq vectors
Message-ID: <20080828011057.GA3634@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need whole 32 of them, only NR_SOFTIRQS.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/interrupt.h |    2 ++
 kernel/softirq.c          |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -252,6 +252,8 @@ enum
 	HRTIMER_SOFTIRQ,
 #endif
 	RCU_SOFTIRQ, 	/* Preferable RCU should always be the last softirq */
+
+	NR_SOFTIRQS
 };
 
 /* softirq mask and active fields moved to irq_cpustat_t in
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -46,7 +46,7 @@ irq_cpustat_t irq_stat[NR_CPUS] ____cacheline_aligned;
 EXPORT_SYMBOL(irq_stat);
 #endif
 
-static struct softirq_action softirq_vec[32] __cacheline_aligned_in_smp;
+static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
 static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 

