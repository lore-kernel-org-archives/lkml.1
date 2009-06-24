Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbZFXJsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbZFXJsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759148AbZFXJry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:47:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:59797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759109AbZFXJrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:47:53 -0400
Date: Wed, 24 Jun 2009 09:47:22 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A41F2DB.4020102@cn.fujitsu.com>
References: <4A41F2DB.4020102@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: Fix trace_buf_size boot option
Message-ID: <tip-9d612beff5089b89a295a2331883a8ce3fff08c1@git.kernel.org>
Git-Commit-ID: 9d612beff5089b89a295a2331883a8ce3fff08c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 09:47:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d612beff5089b89a295a2331883a8ce3fff08c1
Gitweb:     http://git.kernel.org/tip/9d612beff5089b89a295a2331883a8ce3fff08c1
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Jun 2009 17:33:15 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Jun 2009 11:41:12 +0200

tracing: Fix trace_buf_size boot option

We should be able to specify [KMG] when setting trace_buf_size
boot option, as documented in kernel-parameters.txt

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A41F2DB.4020102@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/kernel-parameters.txt |    3 ++-
 kernel/trace/trace.c                |    5 ++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 92e1ab8..d3f41db 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2475,7 +2475,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	tp720=		[HW,PS2]
 
-	trace_buf_size=nn[KMG] [ftrace] will set tracing buffer size.
+	trace_buf_size=nn[KMG]
+			[FTRACE] will set tracing buffer size.
 
 	trix=		[HW,OSS] MediaTrix AudioTrix Pro
 			Format:
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3bb3100..3aa0a0d 100644
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
+	buf_size = memparse(str, &str);
 	/* nr_entries can not be zero */
-	if (ret < 0 || buf_size == 0)
+	if (buf_size == 0)
 		return 0;
 	trace_buf_size = buf_size;
 	return 1;
