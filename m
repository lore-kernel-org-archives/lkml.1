Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZCVUgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZCVUgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 16:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZCVUgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 16:36:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbZCVUgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 16:36:21 -0400
Subject: [git-pull -tip] trace: fix signedness patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 02:05:39 +0530
Message-Id: <1237754139.5417.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7f00a2495bf5b98b097c47be5d6e2d4114ec39bf:
  Ingo Molnar (1):
        Merge branches 'x86/cleanups', 'x86/mm', 'x86/setup' and 'linus' into x86/core

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git x86/core

Jaswinder Singh Rajput (2):
      trace: ring_buffer.c fix various signedness issues
      trace: trace.c fix signedness issue

 kernel/trace/ring_buffer.c |    8 ++++----
 kernel/trace/trace.c       |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

Complete diff:
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bd38c5c..114811b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -57,7 +57,7 @@ enum {
 	RB_BUFFERS_DISABLED	= 1 << RB_BUFFERS_DISABLED_BIT,
 };
 
-static long ring_buffer_flags __read_mostly = RB_BUFFERS_ON;
+static unsigned long ring_buffer_flags __read_mostly = RB_BUFFERS_ON;
 
 /**
  * tracing_on - enable all tracing buffers
@@ -2466,7 +2466,7 @@ static ssize_t
 rb_simple_read(struct file *filp, char __user *ubuf,
 	       size_t cnt, loff_t *ppos)
 {
-	long *p = filp->private_data;
+	unsigned long *p = filp->private_data;
 	char buf[64];
 	int r;
 
@@ -2482,9 +2482,9 @@ static ssize_t
 rb_simple_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
-	long *p = filp->private_data;
+	unsigned long *p = filp->private_data;
+	unsigned long val;
 	char buf[64];
-	long val;
 	int ret;
 
 	if (cnt >= sizeof(buf))
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 17bb88d..e85fc41 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2929,8 +2929,8 @@ tracing_ctrl_write(struct file *filp, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
+	unsigned long val;
 	char buf[64];
-	long val;
 	int ret;
 
 	if (cnt >= sizeof(buf))


