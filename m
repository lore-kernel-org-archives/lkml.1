Return-Path: <linux-kernel-owner+w=401wt.eu-S1761719AbYDSDLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761719AbYDSDLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYDSDLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:11:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbYDSDLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:11:39 -0400
Date: Fri, 18 Apr 2008 23:11:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, sandmann@redhat.com, pq@iki.fi,
       srostedt@redhat.com
Subject: [PATCH 1/5 -v2] ftrace: simple clean ups
In-Reply-To: <20080418131535.dbcd315d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0804182309540.19025@gandalf.stny.rr.com>
References: <20080418200538.788522018@goodmis.org> <20080418200849.968033091@goodmis.org>
 <20080418131535.dbcd315d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton mentioned some clean ups that should be done to ftrace.
This patch does some of the simple clean ups.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

Index: linux-sched-devel.git/kernel/trace/trace.c
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace.c	2008-04-18 23:01:57.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace.c	2008-04-18 23:03:52.000000000 -0400
@@ -36,8 +36,7 @@ unsigned long __read_mostly	tracing_max_
 unsigned long __read_mostly	tracing_thresh;

 /* dummy trace to disable tracing */
-static struct tracer no_tracer __read_mostly =
-{
+static struct tracer no_tracer __read_mostly = {
 	.name		= "none",
 };

@@ -1961,8 +1960,8 @@ tracing_iter_ctrl_write(struct file *fil
 	int neg = 0;
 	int i;

-	if (cnt > 63)
-		cnt = 63;
+	if (cnt >= sizeof(buf))
+		return -EINVAL;

 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
@@ -2054,8 +2053,8 @@ tracing_ctrl_write(struct file *filp, co
 	long val;
 	char buf[64];

-	if (cnt > 63)
-		cnt = 63;
+	if (cnt >= sizeof(buf))
+		return -EINVAL;

 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
@@ -2154,10 +2153,8 @@ tracing_max_lat_read(struct file *filp,
 	char buf[64];
 	int r;

-	r = snprintf(buf, 64, "%ld\n",
+	r = scnprintf(buf, sizeof(buf), "%ld\n",
 		     *ptr == (unsigned long)-1 ? -1 : nsecs_to_usecs(*ptr));
-	if (r > 64)
-		r = 64;
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }

@@ -2169,8 +2166,8 @@ tracing_max_lat_write(struct file *filp,
 	long val;
 	char buf[64];

-	if (cnt > 63)
-		cnt = 63;
+	if (cnt >= sizeof(buf))
+		return -EINVAL;

 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
@@ -2434,8 +2431,8 @@ tracing_entries_write(struct file *filp,
 	unsigned long val;
 	char buf[64];

-	if (cnt > 63)
-		cnt = 63;
+	if (cnt >= sizeof(buf))
+		return -EINVAL;

 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;


