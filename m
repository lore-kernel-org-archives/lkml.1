Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189Ab0AZMMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab0AZMMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437Ab0AZMMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:12:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37858
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab0AZMMm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:12:42 -0500
Date: Tue, 26 Jan 2010 04:12:53 -0800 (PST)
Message-Id: <20100126.041253.189819572.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d671001260123r7013a92fqb007e4f255e8b3ba@mail.gmail.com>
References: <20100125.165644.197238824.davem@davemloft.net>
	<a4423d671001260123r7013a92fqb007e4f255e8b3ba@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Tue, 26 Jan 2010 12:23:06 +0300

> Hi David
> 
>> 7) IRQ ->set_affinity() using wrong cpu mask, thanks to Ben H. for
>>   noticing.
>>      sparc64: Fix IRQ ->set_affinity() methods.
> 
> This commit breaks UP build

Sorry, I'll fix this, thanks for the report.

sparc64: Fix UP build.

Can't reference irq_desc[].affinity when !SMP.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index f2179cc..e1cbdb9 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -268,10 +268,8 @@ static int irq_choose_cpu(unsigned int virt_irq, const struct cpumask *affinity)
 	return cpuid;
 }
 #else
-static int irq_choose_cpu(unsigned int virt_irq, const struct cpumask *affinity)
-{
-	return real_hard_smp_processor_id();
-}
+#define irq_choose_cpu(virt_irq, affinity)	\
+	real_hard_smp_processor_id()
 #endif
 
 static void sun4u_irq_enable(unsigned int virt_irq)
