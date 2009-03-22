Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbZCVWMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbZCVWMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 18:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbZCVWK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 18:10:58 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:18798 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbZCVWK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 18:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iugfY9o1UMHdEMfpCGws/Pxb/vUZsfALH0Awm9hI3rj78NdPHG1g8xYCbxDaEBMSYD
         edsS73Sx4kZ7D+IWfo6YKP6Mq8Ab8M2yiVNpYUBP7WbZLQapsT3KpUeBppixPIQ0YFgJ
         bZYCqqXtpvn7muaiSezP0PMT32i3CUIyTbtj4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/5] tracing/ftrace: make nop using polling wait for events on pipe
Date: Sun, 22 Mar 2009 23:10:47 +0100
Message-Id: <1237759847-21025-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: display events when they arrive

Now that the events don't use wake_up() anymore, we need the nop
tracer to poll waiting for events on the pipe. Especially because
nop is useful to look at orphans traces types (traces types that
don't rely on specific tracers) because it doesn't produce traces
itself.

And unlike other tracers that trigger specific traces periodically,
nop triggers no traces by itself that can wake him.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
-- 
1.6.1

