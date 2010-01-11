Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325Ab0AKVaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0AKVaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311Ab0AKVa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:30:27 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:60356 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab0AKV11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Zdb7xa+PveP3C0yCEqBF+dqKYoMcPCP8U8RPv8RWWWcLoeCXNGNnGkGIJA/y/gpcUG
         E85IhaT6zsX5UjO1RosSOWRtkFZdF9jEns8/DatssS3N+6EoStU8ikTWzPtYVxJWn/Xx
         7Yv9S+phjS7J6NTgUbqoPtHy6L0rr4jSjw9Zg=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 13/26] genirq: Convert locks to raw_spinlocks
Date: Mon, 11 Jan 2010 22:26:43 +0100
Message-Id: <1263245216-14754-14-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-13-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks that cannot sleep in preempt-rt to raw_spinlocks.

See also: fd2bde5dd1689cc8ede833604cc19d1c835faf61

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/arm/oprofile/op_model_mpcore.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/oprofile/op_model_mpcore.c b/arch/arm/oprofile/op_model_mpcore.c
index 4ce0f98..cc125c2 100644
--- a/arch/arm/oprofile/op_model_mpcore.c
+++ b/arch/arm/oprofile/op_model_mpcore.c
@@ -263,10 +263,10 @@ static void em_route_irq(int irq, unsigned int cpu)
 	struct irq_desc *desc = irq_desc + irq;
 	const struct cpumask *mask = cpumask_of(cpu);
 
-	spin_lock_irq(&desc->lock);
+	raw_spin_lock_irq(&desc->lock);
 	cpumask_copy(desc->affinity, mask);
 	desc->chip->set_affinity(irq, mask);
-	spin_unlock_irq(&desc->lock);
+	raw_spin_unlock_irq(&desc->lock);
 }
 
 static int em_setup(void)
-- 
1.6.5.2

