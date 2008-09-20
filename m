Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYITCmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYITCmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 22:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYITCmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 22:42:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:38901 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYITCmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 22:42:08 -0400
Date: Fri, 19 Sep 2008 19:42:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fastboot: fix mismerged conflict in init/main.c
Message-ID: <20080919194215.12fe4c75@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] fastboot: fix mismerged conflict in init/main.c

a merge conflict via the -tip tree has resulted in a not-quite-right
piece of code; this patch fixes this up by consolidating things
into a single printk (and do this for both the entry and exit paths)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 init/main.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/init/main.c b/init/main.c
index b156c61..e50657c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -726,8 +726,7 @@ int do_one_initcall(initcall_t fn)
 	int result;
 
 	if (initcall_debug) {
-		printk("calling  %pF\n", fn);
-		printk(" @ %i\n",  task_pid_nr(current));
+		printk("calling  %pF @ %i\n", fn, task_pid_nr(current));
 		t0 = ktime_get();
 	}
 
@@ -737,9 +736,8 @@ int do_one_initcall(initcall_t fn)
 		t1 = ktime_get();
 		delta = ktime_sub(t1, t0);
 
-		print_fn_descriptor_symbol("initcall %s", fn);
-		printk(" returned %d after %Ld msecs\n", result,
-			(unsigned long long) delta.tv64 >> 20);
+		printk("initcall %pF returned %d after %Ld msecs\n", fn,
+			result, (unsigned long long) delta.tv64 >> 20);
 	}
 
 	msgbuf[0] = 0;
-- 
1.5.5.1


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
