Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbZFXJ0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbZFXJ0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZFXJ0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:26:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53033 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZFXJ0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:26:05 -0400
Message-ID: <4A41F165.2000906@cn.fujitsu.com>
Date: Wed, 24 Jun 2009 17:27:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: fix trace_buf_size boot option
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be able to specify [KMG] when setting trace_buf_size
boot option, as documented in kernel-parameters.txt

[ Impact: allow to specify [KMG] in trace_buf_size boot option ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    3 ++-
 kernel/trace/trace.c                |    5 ++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 256a650..421f1e6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2446,7 +2446,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	tp720=		[HW,PS2]
 
-	trace_buf_size=nn[KMG] [ftrace] will set tracing buffer size.
+	trace_buf_size=nn[KMG]
+			[FTRACE] will set tracing buffer size.
 
 	trix=		[HW,OSS] MediaTrix AudioTrix Pro
 			Format:
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3bb3100..7068468 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -284,13 +284,12 @@ void trace_wake_up(void)
 static int __init set_buf_size(char *str)
 {
 	unsigned long buf_size;
-	int ret;
 
 	if (!str)
 		return 0;
-	ret = strict_strtoul(str, 0, &buf_size);
+	buf_size = memparse(str, &opt);
 	/* nr_entries can not be zero */
-	if (ret < 0 || buf_size == 0)
+	if (buf_size == 0)
 		return 0;
 	trace_buf_size = buf_size;
 	return 1;
-- 
1.5.4.rc3

