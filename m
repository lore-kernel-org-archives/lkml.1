Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbZHaEp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbZHaEp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 00:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZHaEpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 00:45:24 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:48405 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbZHaEpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 00:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jM7frZ6RNnHLhzeQwdtNNIASzX2Qn4hb/E+UMZPG3zhZfnJKTeQ/DhlWyuj9wFNLo2
         NatPpY5xvFgmTrnb2uwpB6SAps8C2hwApVyGKxSmih3csmnh7pd+ChoQM7abLTPWwfsi
         gMHIo1D3/5cGgRwSc8e80IoaGsTn46oDXZs2o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf tools: Resolve idle thread cmdline for perf trace
Date: Mon, 31 Aug 2009 06:45:19 +0200
Message-Id: <1251693921-6579-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251682323-10395-1-git-send-email-fweisbec@gmail.com>
References: <1251682323-10395-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cmd-trace tool used the cmdline file and resolved the idle thread
using a hardcoded check for the 0 task pid.

Now we have a centralized way to do that from perf using
register_idle_thread() API.

Before:
	:0-0     [000]     0.000000: irq_handler_entry: irq=0 handler=name
	:0-0     [000]     0.000000: irq_handler_entry: irq=0 handler=name

After:
	[idle]-0     [000]     0.000000: irq_handler_entry: irq=0 handler=name
	[idle]-0     [000]     0.000000: irq_handler_entry: irq=0 handler=name

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index dd3c2e7..8247fd0 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -164,6 +164,7 @@ static int __cmd_trace(void)
 	char *buf;
 
 	trace_report();
+	register_idle_thread(&threads, &last_match);
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
-- 
1.6.2.3

