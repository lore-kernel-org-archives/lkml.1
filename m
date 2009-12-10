Return-Path: <linux-kernel-owner+w=401wt.eu-S1760688AbZLJHtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688AbZLJHtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760639AbZLJHtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:49:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:46444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760530AbZLJHtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:49:13 -0500
Date: Thu, 10 Dec 2009 07:48:49 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20091209153204.F4CD.A69D9226@jp.fujitsu.com>
References: <20091209153204.F4CD.A69D9226@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Only call pipe_close if pipe_close is defined
Message-ID: <tip-29bf4a5e3fed3dde3eb629a0cb1762c1e9217458@git.kernel.org>
Git-Commit-ID: 29bf4a5e3fed3dde3eb629a0cb1762c1e9217458
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29bf4a5e3fed3dde3eb629a0cb1762c1e9217458
Gitweb:     http://git.kernel.org/tip/29bf4a5e3fed3dde3eb629a0cb1762c1e9217458
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 9 Dec 2009 12:37:43 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 9 Dec 2009 12:47:35 -0500

tracing: Only call pipe_close if pipe_close is defined

This fixes a cut and paste error that had pipe_close get called
if pipe_open was defined (not pipe_close).

Reported-by: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
LKML-Reference: <20091209153204.F4CD.A69D9226@jp.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f804b40..dc937e1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2899,7 +2899,7 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 		cpumask_clear_cpu(iter->cpu_file, tracing_reader_cpumask);
 
 
-	if (iter->trace->pipe_open)
+	if (iter->trace->pipe_close)
 		iter->trace->pipe_close(iter);
 
 	mutex_unlock(&trace_types_lock);
