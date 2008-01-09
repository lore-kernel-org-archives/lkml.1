Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYAIIDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYAIIDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYAIID3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:03:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbYAIID2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:03:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] show_task: real_parent
X-Fcc: ~/Mail/linus
X-Zippy-Says: My EARS are GONE!!
Message-Id: <20080109080323.8FCDC26F9A7@magilla.localdomain>
Date: Wed,  9 Jan 2008 00:03:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The show_task function invoked by sysrq-t et al displays the
pid and parent's pid of each task.  It seems more useful to
show the actual process hierarchy here than who is using
ptrace on each process.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3df84ea..37cf07a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4918,7 +4918,7 @@ static void show_task(struct task_struct *p)
 	}
 #endif
 	printk(KERN_CONT "%5lu %5d %6d\n", free,
-		task_pid_nr(p), task_pid_nr(p->parent));
+		task_pid_nr(p), task_pid_nr(p->real_parent));
 
 	if (state != TASK_RUNNING)
 		show_stack(p, NULL);
