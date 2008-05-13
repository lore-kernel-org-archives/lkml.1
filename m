Return-Path: <linux-kernel-owner+w=401wt.eu-S1760527AbYEMQxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527AbYEMQxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbYEMQw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:52:59 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47252 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758993AbYEMQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:52:58 -0400
From: Sebastian Siewior <bigeasy@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
Cc: Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, Sebastian Siewior <bigeasy@linutronix.de>
Subject: [PATCH] ftrace: also dump the entry->flag field
Date: Tue, 13 May 2008 18:52:45 +0200
Message-Id: <1210697565-3106-4-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1210697565-3106-1-git-send-email-bigeasy@linutronix.de>
References: <1210697565-3106-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data is collected anyway so why not print it?

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
---
 kernel/trace/trace.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 06c85b3..0b0e996 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1514,7 +1514,14 @@ static int print_trace_fmt(struct trace_iterator *iter)
 	ret = trace_seq_printf(s, "[%02d] ", iter->cpu);
 	if (!ret)
 		return 0;
-	ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
+	ret = trace_seq_printf(s, "%5lu.%06lu ", secs, usec_rem);
+	if (!ret)
+		return 0;
+	ret = trace_seq_printf(s, "{%2u|%c%c%c%c}: ", entry->preempt_count,
+			entry->flags & TRACE_FLAG_IRQS_OFF      ? '.' : 'I',
+			entry->flags & TRACE_FLAG_NEED_RESCHED  ? 'R' : '.',
+			entry->flags & TRACE_FLAG_HARDIRQ       ? 'H' : '.',
+			entry->flags & TRACE_FLAG_SOFTIRQ       ? 'S' : '.');
 	if (!ret)
 		return 0;
 
-- 
1.5.4.3

