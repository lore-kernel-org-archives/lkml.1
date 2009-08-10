Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbZHJSP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbZHJSP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZHJSP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:15:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbZHJSP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:15:57 -0400
Date: Mon, 10 Aug 2009 20:15:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] irq fix
Message-ID: <20090810181541.GA31253@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Yinghai Lu (1):
      x86/irq: Fix move_irq_desc() for nodes without ram


 kernel/irq/numa_migrate.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index 2f69bee..3fd3019 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -107,8 +107,8 @@ out_unlock:
 
 struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
 {
-	/* those all static, do move them */
-	if (desc->irq < NR_IRQS_LEGACY)
+	/* those static or target node is -1, do not move them */
+	if (desc->irq < NR_IRQS_LEGACY || node == -1)
 		return desc;
 
 	if (desc->node != node)
