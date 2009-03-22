Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbZCVSpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbZCVSpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 14:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZCVSox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 14:44:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:47577 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbZCVSow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 14:44:52 -0400
Subject: [PATCH -tip] trace: ring_buffer.c fix various signedness issues
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 00:14:31 +0530
Message-Id: <1237747471.8713.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Mon, 23 Mar 2009 00:02:38 +0530
Subject: [PATCH] trace: ring_buffer.c fix various signedness issues

Impact:cleanup

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 kernel/trace/ring_buffer.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

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
-- 
1.6.0.6



