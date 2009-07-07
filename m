Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZGGFyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZGGFyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbZGGFyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:54:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62179 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbZGGFyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:54:03 -0400
Message-ID: <4A52E300.7020601@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 13:54:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/8] ksym_tracer: NIL-terminate user input filter
References: <4A52E291.1020408@cn.fujitsu.com>
In-Reply-To: <4A52E291.1020408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure the user input string is NULL-terminated.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_ksym.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 72fcb46..8cbed5a 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -264,11 +264,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	unsigned long ksym_addr = 0;
 	int ret, op, changed = 0;
 
-	/* Ignore echo "" > ksym_trace_filter */
-	if (count == 0)
-		return 0;
-
-	input_string = kzalloc(count, GFP_KERNEL);
+	input_string = kzalloc(count + 1, GFP_KERNEL);
 	if (!input_string)
 		return -ENOMEM;
 
@@ -276,6 +272,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 		kfree(input_string);
 		return -EFAULT;
 	}
+	input_string[count] = '\0';
 
 	ret = op = parse_ksym_trace_str(input_string, &ksymname, &ksym_addr);
 	if (ret < 0) {
-- 
1.5.4.rc3

