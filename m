Return-Path: <linux-kernel-owner+w=401wt.eu-S1765318AbXGSKFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765318AbXGSKFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759065AbXGSJzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:21 -0400
Received: from ns.suse.de ([195.135.220.2]:35358 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757188AbXGSJzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:09 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [19/58] x86_64: Don't use softirq save locks in smp_call_function
Message-Id: <20070719095504.376B614E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It is not fully softirq safe anyways.

Can't do a WARN_ON unfortunately because it could trigger in the 
panic case.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/smp.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smp.c
+++ linux/arch/x86_64/kernel/smp.c
@@ -386,9 +386,9 @@ int smp_call_function_single (int cpu, v
 		return 0;
 	}
 
-	spin_lock_bh(&call_lock);
+	spin_lock(&call_lock);
 	__smp_call_function_single(cpu, func, info, nonatomic, wait);
-	spin_unlock_bh(&call_lock);
+	spin_unlock(&call_lock);
 	put_cpu();
 	return 0;
 }
