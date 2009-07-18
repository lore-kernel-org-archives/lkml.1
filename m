Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZGRRXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZGRRXp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 13:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZGRRXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 13:23:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55747 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZGRRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 13:23:43 -0400
Subject: Re: [tip:core/locking] lockdep: BFS cleanup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-ec223f9a486e12dbdb8e6996fcc283eee622695b@git.kernel.org>
References: <1246201486-7308-11-git-send-email-tom.leiming@gmail.com>
	 <tip-ec223f9a486e12dbdb8e6996fcc283eee622695b@git.kernel.org>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 19:23:31 +0200
Message-Id: <1247937811.6597.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 14:24 +0000, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  ec223f9a486e12dbdb8e6996fcc283eee622695b
> Gitweb:     http://git.kernel.org/tip/ec223f9a486e12dbdb8e6996fcc283eee622695b
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 18 Jul 2009 16:02:57 +0200
> 
> lockdep: BFS cleanup
> 
> Some cleanups of the lockdep code after the BFS series:
> 
>  - Remove the last traces of the generation id
>  - Fixup comment style
>  - Move the bfs routines into lockdep.c
>  - Cleanup the bfs routines
> 
> [ tom.leiming@gmail.com: Fix crash ]
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <1246201486-7308-11-git-send-email-tom.leiming@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

/usr/src/linux-2.6/kernel/lockdep.c:543: warning: 'print_lock_class_header' defined but not used

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   48 ++++++++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3718a98..75cf4ad 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -539,30 +539,6 @@ static void lockdep_print_held_locks(struct task_struct *curr)
 	}
 }
 
-static void print_lock_class_header(struct lock_class *class, int depth)
-{
-	int bit;
-
-	printk("%*s->", depth, "");
-	print_lock_name(class);
-	printk(" ops: %lu", class->ops);
-	printk(" {\n");
-
-	for (bit = 0; bit < LOCK_USAGE_STATES; bit++) {
-		if (class->usage_mask & (1 << bit)) {
-			int len = depth;
-
-			len += printk("%*s   %s", depth, "", usage_str[bit]);
-			len += printk(" at:\n");
-			print_stack_trace(class->usage_traces + bit, len);
-		}
-	}
-	printk("%*s }\n", depth, "");
-
-	printk("%*s ... key      at: ",depth,"");
-	print_ip_sym((unsigned long)class->key);
-}
-
 static void print_kernel_version(void)
 {
 	printk("%s %.*s\n", init_utsname()->release,
@@ -1277,6 +1253,30 @@ find_usage_backwards(struct lock_list *root, enum lock_usage_bit bit,
 	return result;
 }
 
+static void print_lock_class_header(struct lock_class *class, int depth)
+{
+	int bit;
+
+	printk("%*s->", depth, "");
+	print_lock_name(class);
+	printk(" ops: %lu", class->ops);
+	printk(" {\n");
+
+	for (bit = 0; bit < LOCK_USAGE_STATES; bit++) {
+		if (class->usage_mask & (1 << bit)) {
+			int len = depth;
+
+			len += printk("%*s   %s", depth, "", usage_str[bit]);
+			len += printk(" at:\n");
+			print_stack_trace(class->usage_traces + bit, len);
+		}
+	}
+	printk("%*s }\n", depth, "");
+
+	printk("%*s ... key      at: ",depth,"");
+	print_ip_sym((unsigned long)class->key);
+}
+
 /*
  * printk the shortest lock dependencies from @start to @end in reverse order:
  */


