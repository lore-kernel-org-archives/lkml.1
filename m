Return-Path: <linux-kernel-owner+w=401wt.eu-S932272AbZEEKuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbZEEKuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbZEEKtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:49:52 -0400
Received: from www.tglx.de ([62.245.132.106]:34232 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbZEEKtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:49:52 -0400
Date: Tue, 5 May 2009 12:48:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] genirq fixes for 2.6.30
Message-ID: <alpine.LFD.2.00.0905051246210.3375@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq/urgent git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/urgent

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      Revert "genirq: assert that irq handlers are indeed running in hardirq context"


 kernel/irq/handle.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index d82142b..26e0875 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -363,8 +363,6 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
 
-	WARN_ONCE(!in_irq(), "BUG: IRQ handler called from non-hardirq context!");
-
 	if (!(action->flags & IRQF_DISABLED))
 		local_irq_enable_in_hardirq();
 
