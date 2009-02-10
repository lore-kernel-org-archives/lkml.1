Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZBJSpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZBJSpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 13:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZBJSor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 13:44:47 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:56226 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbZBJSoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 13:44:46 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 2/3] trace: fix sparse warnings: fix (un-)signedness
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Feb 2009 19:44:34 +0100
Message-ID: <20090210184420.28131.58330.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090210184214.28131.90564.stgit@vmbox.hanneseder.net>
References: <20090210184214.28131.90564.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  kernel/trace/ring_buffer.c:70:37: warning: incorrect type in argument 2 (different signedness)
  kernel/trace/ring_buffer.c:84:39: warning: incorrect type in argument 2 (different signedness)
  kernel/trace/ring_buffer.c:96:43: warning: incorrect type in argument 2 (different signedness)
  kernel/trace/ring_buffer.c:2475:13: warning: incorrect type in argument 2 (different signedness)
  kernel/trace/ring_buffer.c:2475:13: warning: incorrect type in argument 2 (different signedness)
  kernel/trace/ring_buffer.c:2478:42: warning: incorrect type in argument 2 (different signedness)
  kernel/trace/ring_buffer.c:2478:42: warning: incorrect type in argument 2 (different signedness)
  kernel/trace/ring_buffer.c:2500:40: warning: incorrect type in argument 3 (different signedness)
  kernel/trace/ring_buffer.c:2505:44: warning: incorrect type in argument 2 (different signedness)
  kernel/trace/ring_buffer.c:2507:46: warning: incorrect type in argument 2 (different signedness)
  kernel/trace/trace.c:2130:40: warning: incorrect type in argument 3 (different signedness)
  kernel/trace/trace.c:2280:40: warning: incorrect type in argument 3 (different signedness)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 kernel/trace/ring_buffer.c |    8 ++++----
 kernel/trace/trace.c       |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index aee76b3..6249e71 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -57,7 +57,7 @@ enum {
 	RB_BUFFERS_DISABLED	= 1 << RB_BUFFERS_DISABLED_BIT,
 };
 
-static long ring_buffer_flags __read_mostly = RB_BUFFERS_ON;
+static unsigned long ring_buffer_flags __read_mostly = RB_BUFFERS_ON;
 
 /**
  * tracing_on - enable all tracing buffers
@@ -2468,7 +2468,7 @@ static ssize_t
 rb_simple_read(struct file *filp, char __user *ubuf,
 	       size_t cnt, loff_t *ppos)
 {
-	long *p = filp->private_data;
+	unsigned long *p = filp->private_data;
 	char buf[64];
 	int r;
 
@@ -2484,9 +2484,9 @@ static ssize_t
 rb_simple_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
-	long *p = filp->private_data;
+	unsigned long *p = filp->private_data;
 	char buf[64];
-	long val;
+	unsigned long val;
 	int ret;
 
 	if (cnt >= sizeof(buf))
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0e7c84f..16b8be4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2118,7 +2118,7 @@ tracing_ctrl_write(struct file *filp, const char __user *ubuf,
 {
 	struct trace_array *tr = filp->private_data;
 	char buf[64];
-	long val;
+	unsigned long val;
 	int ret;
 
 	if (cnt >= sizeof(buf))
@@ -2266,9 +2266,9 @@ static ssize_t
 tracing_max_lat_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
-	long *ptr = filp->private_data;
+	unsigned long *ptr = filp->private_data;
 	char buf[64];
-	long val;
+	unsigned long val;
 	int ret;
 
 	if (cnt >= sizeof(buf))

