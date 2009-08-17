Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbZHQI5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbZHQI5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbZHQI5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:57:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54386 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757496AbZHQI5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:57:03 -0400
Message-ID: <4A891AAB.8090701@cn.fujitsu.com>
Date: Mon, 17 Aug 2009 16:54:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] ftrace: Simplify seqfile code
References: <4A891A65.70009@cn.fujitsu.com>
In-Reply-To: <4A891A65.70009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use seq_release_private().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0948634..1993b71 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1556,17 +1556,6 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-int ftrace_avail_release(struct inode *inode, struct file *file)
-{
-	struct seq_file *m = (struct seq_file *)file->private_data;
-	struct ftrace_iterator *iter = m->private;
-
-	seq_release(inode, file);
-	kfree(iter);
-
-	return 0;
-}
-
 static int
 ftrace_failures_open(struct inode *inode, struct file *file)
 {
@@ -2427,14 +2416,14 @@ static const struct file_operations ftrace_avail_fops = {
 	.open = ftrace_avail_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = ftrace_avail_release,
+	.release = seq_release_private,
 };
 
 static const struct file_operations ftrace_failures_fops = {
 	.open = ftrace_failures_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = ftrace_avail_release,
+	.release = seq_release_private,
 };
 
 static const struct file_operations ftrace_filter_fops = {
-- 
1.6.3

