Return-Path: <linux-kernel-owner+w=401wt.eu-S938004AbXGSNwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938004AbXGSNwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935292AbXGSNsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934706AbXGSNsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:38 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: jesper.juhl@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [8/48] i386: Remove unneeded test of 'task' in dump_trace()
Message-Id: <20070719134837.1AB8F14E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jesper Juhl <jesper.juhl@gmail.com>

Remove unneeded test of task != NULL from
arch/i386/kernel/traps.c::dump_trace()

At the start of the function we have this test:
        if (!task)
                task = current;
so further down there's no need to test 'task'.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -148,7 +148,7 @@ void dump_trace(struct task_struct *task
 	if (!stack) {
 		unsigned long dummy;
 		stack = &dummy;
-		if (task && task != current)
+		if (task != current)
 			stack = (unsigned long *)task->thread.esp;
 	}
 
