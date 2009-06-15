Return-Path: <linux-kernel-owner+w=401wt.eu-S1765059AbZFOSOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765059AbZFOSOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933559AbZFOSNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:13:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:42642 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933568AbZFOSNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:13:54 -0400
Date: Mon, 15 Jun 2009 18:13:26 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4A35B898.2050607@cn.fujitsu.com>
References: <4A35B898.2050607@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: replace a GFP_ATOMIC with GFP_KERNEL allocation
Message-ID: <tip-e4f2d10f479d18198ebafcb5e124cc3dd8b8817a@git.kernel.org>
Git-Commit-ID: e4f2d10f479d18198ebafcb5e124cc3dd8b8817a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Jun 2009 18:13:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4f2d10f479d18198ebafcb5e124cc3dd8b8817a
Gitweb:     http://git.kernel.org/tip/e4f2d10f479d18198ebafcb5e124cc3dd8b8817a
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 15 Jun 2009 10:57:28 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 15 Jun 2009 11:37:14 -0400

tracing: replace a GFP_ATOMIC with GFP_KERNEL allocation

Atomic allocation is not needed here.

[ Impact: clean up of memory alloction type ]

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A35B898.2050607@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7355a38..0f57f1b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3627,7 +3627,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	struct trace_seq *s;
 	unsigned long cnt;
 
-	s = kmalloc(sizeof(*s), GFP_ATOMIC);
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return ENOMEM;
 
