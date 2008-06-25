Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYFYHNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYFYHNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 03:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbYFYHNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 03:13:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:24639 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYFYHN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 03:13:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=GE+4JmBYWFGtYQfnM7rCd3pwC3SpfARG9lT6mgQkDHz8jv5/ipawDO8WTqbyVVXNWt
         VVtPfMJHT/mNz1Mru2e6rQyIAPFDj6+Mth5jEHz+blmnhkzEpPOoAw1QyK487z825TmQ
         anPq5mvz1P/nFQR1EQy69E/dJwr41KdVTxBgs=
Date: Wed, 25 Jun 2008 09:13:23 +0200
To: Johannes Weiner <hannes@saeurebad.de>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] softlockup: show irqtrace
Message-ID: <20080625071323.GA7987@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo, can you please drop the "softirq softlockup debugging" patch and
apply this instead? This much, much prettier, reuses existing debugging
infrastructure, and is a lot more generic.

(Compile tested on allyesconfig, allnoconfig, allnoconfig + softlockup
debugging.)


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Wed, 25 Jun 2008 08:50:10 +0200
Subject: [PATCH] softlockup: show irqtrace

This patch adds some information about when interrupts were last
enabled and disabled to the output of the softlockup detector.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 kernel/softlockup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 01b6522..980f703 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -13,6 +13,7 @@
 #include <linux/delay.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/lockdep.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
 
@@ -115,6 +116,7 @@ void softlockup_tick(void)
 	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
 			this_cpu, now - touch_timestamp,
 			current->comm, task_pid_nr(current));
+	print_irqtrace_events(current);
 	if (regs)
 		show_regs(regs);
 	else
-- 
1.5.4.1

