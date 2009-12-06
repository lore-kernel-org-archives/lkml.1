Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbZLFKDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbZLFKDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 05:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbZLFKDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 05:03:48 -0500
Received: from www.tglx.de ([62.245.132.106]:48458 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202AbZLFKDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 05:03:47 -0500
Date: Sun, 6 Dec 2009 11:03:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] genirq updates for 2.6.33
Message-ID: <alpine.LFD.2.00.0912061102300.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

Thanks,

	tglx

------------------>
Luis Henriques (1):
      genirq: do not execute DEBUG_SHIRQ when irq setup failed


 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 1516ab7..8c68d5b 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -768,7 +768,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 		kfree(action);
 
 #ifdef CONFIG_DEBUG_SHIRQ
-	if (irqflags & IRQF_SHARED) {
+	if (!retval && (irqflags & IRQF_SHARED)) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
 		 * to happen immediately, so let's make sure....
