Return-Path: <linux-kernel-owner+w=401wt.eu-S1765623AbXIUU6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765623AbXIUU6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763518AbXIUUpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:50104 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763414AbXIUUpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:25 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: mingo@elte.hu, oleg@tv-sign.ru, 76306.1226@compuserve.com, ak@suse.de,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [41/45] i386: remove unnecessary code
Message-Id: <20070921204524.7BBAC14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ingo Molnar <mingo@elte.hu>

Oleg Nesterov pointed out that the set_fs() calls in setup_frame()
and setup_rt_frame() were superfluous.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Chuck Ebbert <76306.1226@compuserve.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/signal.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/arch/i386/kernel/signal.c
===================================================================
--- linux.orig/arch/i386/kernel/signal.c
+++ linux/arch/i386/kernel/signal.c
@@ -387,7 +387,6 @@ static int setup_frame(int sig, struct k
 	regs->edx = (unsigned long) 0;
 	regs->ecx = (unsigned long) 0;
 
-	set_fs(USER_DS);
 	regs->xds = __USER_DS;
 	regs->xes = __USER_DS;
 	regs->xss = __USER_DS;
@@ -481,7 +480,6 @@ static int setup_rt_frame(int sig, struc
 	regs->edx = (unsigned long) &frame->info;
 	regs->ecx = (unsigned long) &frame->uc;
 
-	set_fs(USER_DS);
 	regs->xds = __USER_DS;
 	regs->xes = __USER_DS;
 	regs->xss = __USER_DS;
