Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYFPWvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYFPWvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYFPWvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:51:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:40647 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYFPWvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:51:13 -0400
Date: Mon, 16 Jun 2008 15:51:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] softlockup: print a module list on being stuck
Message-ID: <20080616155108.2ae7913a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] softlockup: print a module list on being stuck

Most places in the kernel that go BUG: print a module list
(which is very useful for doing statistics and finding patterns),
however the softlockup detector does not do this yet.

This patch adds the one line change to fix this gap.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/softlockup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 01b6522..47cc709 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -115,6 +115,7 @@ void softlockup_tick(void)
 	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
 			this_cpu, now - touch_timestamp,
 			current->comm, task_pid_nr(current));
+	print_modules();
 	if (regs)
 		show_regs(regs);
 	else
-- 
1.5.4.5


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
