Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZCPHxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZCPHxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZCPHxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:53:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56704 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbZCPHxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:53:00 -0400
Date: Mon, 16 Mar 2009 18:52:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>
Subject: [PATCH] powerpc/cell: fix unused variable warning in interrupt.c
Message-Id: <20090316185256.4a160374.sfr@canb.auug.org.au>
In-Reply-To: <20090202174817.dd4a26f0.sfr@canb.auug.org.au>
References: <20090202174817.dd4a26f0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


arch/powerpc/platforms/cell/interrupt.c: In function 'handle_iic_irq':
arch/powerpc/platforms/cell/interrupt.c:240: warning: unused variable 'cpu'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/platforms/cell/interrupt.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

On Mon, 2 Feb 2009 17:48:17 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:
> 
> arch/powerpc/platforms/cell/interrupt.c: In function 'handle_iic_irq':
> arch/powerpc/platforms/cell/interrupt.c:240: warning: unused variable 'cpu'
> 
> Caused by commit dee4102a9a5882b4f7d5cc165ba29e8cc63cf92e ("sparseirq:
> use kstat_irqs_cpu instead").

This patch is relative to next-20090312 and updates the sparseirq tree.

diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 1f0d774..882e470 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -237,8 +237,6 @@ extern int noirqdebug;
 
 static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
 {
-	const unsigned int cpu = smp_processor_id();
-
 	spin_lock(&desc->lock);
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-- 
1.6.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
