Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbYEWQuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbYEWQuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYEWQtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:49:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51981 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYEWQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:49:54 -0400
Date: Fri, 23 May 2008 09:05:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH] sched: print module list in the "scheduling while atomic"
 warning
Message-ID: <20080523090558.06b6632f@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] sched: print module list in the "scheduling while atomic" warning

For the normal WARN_ON() etc we added a print-the-modules-list already,
which is very useful to figure out candidates for certain types of bugs.

This patch adds the same print to the "scheduling while atomic" BUG warning,
for the same reason: when we get here it's very useful to see which modules
are loaded, to narrow down the candidate code list.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index cfa222a..764b5b6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4411,6 +4411,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 		prev->comm, prev->pid, preempt_count());
 
 	debug_show_held_locks(prev);
+	print_modules();
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
 
-- 
1.5.4.5

