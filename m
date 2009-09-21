Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZIUPI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZIUPI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 11:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbZIUPIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 11:08:55 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:45866 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbZIUPIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 11:08:54 -0400
Date: Mon, 21 Sep 2009 17:08:55 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@gmail.com, ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/mips: remove duplicate structure field initialization
Message-ID: <Pine.LNX.4.64.0909211708200.8549@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The definition of the irq_ipi structure has two initializations of the
flags field.  This combines them.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier I, s, fld;
position p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@s@
identifier I, s, r.fld;
position r.p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@script:python@
p0 << r.p0;
fld << r.fld;
ps << s.p;
pr << r.p;
@@

if int(ps[0].line)!=int(pr[0].line) or int(ps[0].column)!=int(pr[0].column):
  cocci.print_main(fld,p0)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/mips/kernel/smtc.c             |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 67153a0..4d181df 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -1098,9 +1098,8 @@ static void ipi_irq_dispatch(void)
 
 static struct irqaction irq_ipi = {
 	.handler	= ipi_interrupt,
-	.flags		= IRQF_DISABLED,
-	.name		= "SMTC_IPI",
-	.flags		= IRQF_PERCPU
+	.flags		= IRQF_DISABLED | IRQF_PERCPU,
+	.name		= "SMTC_IPI"
 };
 
 static void setup_cross_vpe_interrupts(unsigned int nvpe)
