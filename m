Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbZCWIcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbZCWIcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757913AbZCWIbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:31:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:51630 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898AbZCWIbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:31:43 -0400
Date: Mon, 23 Mar 2009 08:31:02 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237759847-21025-5-git-send-email-fweisbec@gmail.com>
References: <1237759847-21025-5-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/filters] tracing/ftrace: make nop-tracer use polling wait for events on pipe
Message-ID: <tip-7e6ea92df3fd7cbe74e7985c6f3e40255c44b201@git.kernel.org>
Git-Commit-ID: 7e6ea92df3fd7cbe74e7985c6f3e40255c44b201
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 08:31:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e6ea92df3fd7cbe74e7985c6f3e40255c44b201
Gitweb:     http://git.kernel.org/tip/7e6ea92df3fd7cbe74e7985c6f3e40255c44b201
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 22 Mar 2009 23:10:47 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 09:22:15 +0100

tracing/ftrace: make nop-tracer use polling wait for events on pipe

Impact: display events when they arrive

Now that the events don't use wake_up() anymore, we need the nop
tracer to poll waiting for events on the pipe. Especially because
nop is useful to look at orphan traces types (traces types that
don't rely on specific tracers) because it doesn't produce traces
itself.

And unlike other tracers that trigger specific traces periodically,
nop triggers no traces by itself that can wake him.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1237759847-21025-5-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_nop.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index 9aa84bd..394f944 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -91,6 +91,7 @@ struct tracer nop_trace __read_mostly =
 	.name		= "nop",
 	.init		= nop_trace_init,
 	.reset		= nop_trace_reset,
+	.wait_pipe	= poll_wait_pipe,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_nop,
 #endif
