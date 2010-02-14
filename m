Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab0BNJOe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:14:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:33645 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab0BNJO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:14:27 -0500
Date: Sun, 14 Feb 2010 09:13:35 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100210162346.GA6933@osiris.boeblingen.de.ibm.com>
References: <20100210162346.GA6933@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/kprobes: Fix probe parsing
Message-ID: <tip-a9bb18f36c8056f0712fb28c52c0f85d98438dfb@git.kernel.org>
Git-Commit-ID: a9bb18f36c8056f0712fb28c52c0f85d98438dfb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Feb 2010 09:13:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9bb18f36c8056f0712fb28c52c0f85d98438dfb
Gitweb:     http://git.kernel.org/tip/a9bb18f36c8056f0712fb28c52c0f85d98438dfb
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Wed, 10 Feb 2010 17:23:47 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Feb 2010 09:43:58 +0100

tracing/kprobes: Fix probe parsing

Trying to add a probe like:

  echo p:myprobe 0x10000 > /sys/kernel/debug/tracing/kprobe_events

will fail since the wrong pointer is passed to strict_strtoul
when trying to convert the address to an unsigned long.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100210162346.GA6933@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_kprobe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 6ea90c0..50b1b82 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -689,7 +689,7 @@ static int create_trace_probe(int argc, char **argv)
 			return -EINVAL;
 		}
 		/* an address specified */
-		ret = strict_strtoul(&argv[0][2], 0, (unsigned long *)&addr);
+		ret = strict_strtoul(&argv[1][0], 0, (unsigned long *)&addr);
 		if (ret) {
 			pr_info("Failed to parse address.\n");
 			return ret;
