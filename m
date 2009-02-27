Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZB0Ub2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZB0Ub2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758448AbZB0UbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:31:12 -0500
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:47883 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759546AbZB0UbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:31:09 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Fri, 27 Feb 2009 20:29:24 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] tracing: remove unused code
Message-ID: <20090227202923.GA3826@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct file_operations tracing_lt_fops and tracing_lt_open are not used
anywhere.  These are legacy from the /debug/tracing/latency_trace, which has
been removed in commit 886b5b73d71e4027d7dc6c14f5f7ab102201ea6b

Signed-off-by: Luis Henriques <henrix@sapo.pt>
---
 kernel/trace/trace.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5db7485..04306a1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1822,21 +1822,6 @@ static int tracing_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-static int tracing_lt_open(struct inode *inode, struct file *file)
-{
-	struct trace_iterator *iter;
-	int ret = 0;
-
-	iter = __tracing_open(inode, file);
-
-	if (IS_ERR(iter))
-		ret = PTR_ERR(iter);
-	else
-		iter->iter_flags |= TRACE_FILE_LAT_FMT;
-
-	return ret;
-}
-
 
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
@@ -1916,13 +1901,6 @@ static struct file_operations tracing_fops = {
 	.release	= tracing_release,
 };
 
-static struct file_operations tracing_lt_fops = {
-	.open		= tracing_lt_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= tracing_release,
-};
-
 static struct file_operations show_traces_fops = {
 	.open		= show_traces_open,
 	.read		= seq_read,
-- 
1.6.1.3

