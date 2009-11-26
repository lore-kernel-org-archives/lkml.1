Return-Path: <linux-kernel-owner+w=401wt.eu-S1760480AbZKZMfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480AbZKZMfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 07:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760439AbZKZMfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 07:35:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:57907 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760425AbZKZMfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 07:35:16 -0500
Date: Thu, 26 Nov 2009 12:34:16 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com, mel@csn.ul.ie,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, penberg@cs.helsinki.fi, mel@csn.ul.ie,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B0E286A.2000405@cn.fujitsu.com>
References: <4B0E286A.2000405@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Fix kmem event exports
Message-ID: <tip-4d795fb17a02a87e35782773b88b7a63acfbeaae@git.kernel.org>
Git-Commit-ID: 4d795fb17a02a87e35782773b88b7a63acfbeaae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d795fb17a02a87e35782773b88b7a63acfbeaae
Gitweb:     http://git.kernel.org/tip/4d795fb17a02a87e35782773b88b7a63acfbeaae
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 26 Nov 2009 13:11:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 13:17:43 +0100

tracing: Fix kmem event exports

Commit 53d0422 ("tracing: Convert some kmem events to DEFINE_EVENT")
moved the kmem tracepoint creation from util.c to page_alloc.c,
but forgot to move the exports.

Move them back.

Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
LKML-Reference: <4B0E286A.2000405@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/page_alloc.c |    4 +---
 mm/util.c       |    3 +++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bdb22f5..2bc2ac6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -48,14 +48,12 @@
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
 #include <linux/kmemleak.h>
+#include <trace/events/kmem.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
 #include "internal.h"
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/kmem.h>
-
 /*
  * Array of node states.
  */
diff --git a/mm/util.c b/mm/util.c
index 15d1975..7c35ad9 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -6,6 +6,9 @@
 #include <linux/sched.h>
 #include <asm/uaccess.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/kmem.h>
+
 /**
  * kstrdup - allocate space for and copy an existing string
  * @s: the string to duplicate
