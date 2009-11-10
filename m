Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbZKJRvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbZKJRvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbZKJRvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:51:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44812 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbZKJRvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:51:07 -0500
Date: Tue, 10 Nov 2009 18:50:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fix
Message-ID: <20091110175059.GA25458@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Yong Zhang (1):
      genirq: try_one_irq() must be called with irq disabled


 kernel/irq/spurious.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 114e704..bd7273e 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -121,7 +121,9 @@ static void poll_all_shared_irqs(void)
 		if (!(status & IRQ_SPURIOUS_DISABLED))
 			continue;
 
+		local_irq_disable();
 		try_one_irq(i, desc);
+		local_irq_enable();
 	}
 }
 
