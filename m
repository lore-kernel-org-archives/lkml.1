Return-Path: <linux-kernel-owner+w=401wt.eu-S1763348AbYDVPzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763348AbYDVPzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbYDVPyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:54:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbYDVPyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:54:51 -0400
Message-ID: <480E0A1C.8080408@redhat.com>
Date: Tue, 22 Apr 2008 10:54:04 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/4] mark lockdep functions as noinline_for_stack
References: <480E06A6.1080803@redhat.com>
In-Reply-To: <480E06A6.1080803@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the self-documenting noinline_for_stack attribute
in lockdep functions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.25/kernel/lockdep.c
===================================================================
--- linux-2.6.25.orig/kernel/lockdep.c	2008-04-22 10:31:08.158469196 -0500
+++ linux-2.6.25/kernel/lockdep.c	2008-04-22 10:51:17.107410380 -0500
@@ -878,7 +878,7 @@ static struct held_lock *check_source, *
  * Print a dependency chain entry (this is only done when a deadlock
  * has been detected):
  */
-static noinline int
+static noinline_for_stack int
 print_circular_bug_entry(struct lock_list *target, unsigned int depth)
 {
 	if (debug_locks_silent)
@@ -895,7 +895,7 @@ print_circular_bug_entry(struct lock_lis
  * When a circular dependency is detected, print the
  * header first:
  */
-static noinline int
+static noinline_for_stack int
 print_circular_bug_header(struct lock_list *entry, unsigned int depth)
 {
 	struct task_struct *curr = current;
@@ -920,7 +920,7 @@ print_circular_bug_header(struct lock_li
 	return 0;
 }
 
-static noinline int print_circular_bug_tail(void)
+static noinline_for_stack int print_circular_bug_tail(void)
 {
 	struct task_struct *curr = current;
 	struct lock_list this;
@@ -945,7 +945,7 @@ static noinline int print_circular_bug_t
 
 #define RECURSION_LIMIT 40
 
-static int noinline print_infinite_recursion_bug(void)
+static int noinline_for_stack print_infinite_recursion_bug(void)
 {
 	if (!debug_locks_off_graph_unlock())
 		return 0;
@@ -959,7 +959,7 @@ static int noinline print_infinite_recur
  * Prove that the dependency graph starting at <entry> can not
  * lead to <target>. Print an error and return 0 if it does.
  */
-static noinline int
+static noinline_for_stack int
 check_noncircular(struct lock_class *source, unsigned int depth)
 {
 	struct lock_list *entry;
@@ -1001,7 +1001,7 @@ static struct lock_class *forwards_match
  * Return 1 otherwise and keep <forwards_match> unchanged.
  * Return 0 on error.
  */
-static noinline int
+static noinline_for_stack int
 find_usage_forwards(struct lock_class *source, unsigned int depth)
 {
 	struct lock_list *entry;
@@ -1040,7 +1040,7 @@ find_usage_forwards(struct lock_class *s
  * Return 1 otherwise and keep <backwards_match> unchanged.
  * Return 0 on error.
  */
-static noinline int
+static noinline_for_stack int
 find_usage_backwards(struct lock_class *source, unsigned int depth)
 {
 	struct lock_list *entry;

