Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYGXUmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYGXUmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYGXUm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:42:28 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:43624 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751350AbYGXUm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:42:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAOaDiEhMRKxB/2dsb2JhbACBWrED
Date: Thu, 24 Jul 2008 16:37:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH] Tracepoints use TABLE_SIZE macro
Message-ID: <20080724203723.GC23818@Krystal>
References: <20080715222604.331269462@polymtl.ca> <20080715222746.361289615@polymtl.ca> <Pine.LNX.4.58.0807241136420.14946@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0807241136420.14946@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:35:57 up 50 days,  1:16,  4 users,  load average: 0.19, 0.44,
	0.60
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> :

Wouldn't it look nicer to have: (TRACEPOINT_TABLE_SIZE - 1) ?

me :

Sure,

It applies on top of the "Tracepoints" patch, currently in the ftrace
tree.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: akpm@linux-foundation.org
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: Hideo AOKI <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/tracepoint.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/kernel/tracepoint.c
===================================================================
--- linux-2.6-lttng.orig/kernel/tracepoint.c	2008-07-24 16:33:52.000000000 -0400
+++ linux-2.6-lttng/kernel/tracepoint.c	2008-07-24 16:34:57.000000000 -0400
@@ -177,7 +177,7 @@ static struct tracepoint_entry *get_trac
 	struct tracepoint_entry *e;
 	u32 hash = jhash(name, strlen(name), 0);
 
-	head = &tracepoint_table[hash & ((1 << TRACEPOINT_HASH_BITS)-1)];
+	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
 	hlist_for_each_entry(e, node, head, hlist) {
 		if (!strcmp(name, e->name))
 			return e;
@@ -197,7 +197,7 @@ static struct tracepoint_entry *add_trac
 	size_t name_len = strlen(name) + 1;
 	u32 hash = jhash(name, name_len-1, 0);
 
-	head = &tracepoint_table[hash & ((1 << TRACEPOINT_HASH_BITS)-1)];
+	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
 	hlist_for_each_entry(e, node, head, hlist) {
 		if (!strcmp(name, e->name)) {
 			printk(KERN_NOTICE
@@ -233,7 +233,7 @@ static int remove_tracepoint(const char 
 	size_t len = strlen(name) + 1;
 	u32 hash = jhash(name, len-1, 0);
 
-	head = &tracepoint_table[hash & ((1 << TRACEPOINT_HASH_BITS)-1)];
+	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
 	hlist_for_each_entry(e, node, head, hlist) {
 		if (!strcmp(name, e->name)) {
 			found = 1;
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
