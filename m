Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZHQVH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZHQVH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZHQVH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:07:56 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:45319 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087AbZHQVHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PUn5csza/dExPojnJEcYkTlxQv3R5DcXbioEUzMMmZ2vhj9wv+9MeWgwObN0wVsyzB
         GOTNEWOroTtiUvq9MWW/A+hz1e25GaHowNOm0eMcSZx4P3uACkYc/TyEh09o8cfPwh9E
         8DLwy72M9TaP1y9YtlJNe4tDQ+2ZmN6Wsuv1M=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/4] perf tools: Warn while running perf trace without sample
Date: Mon, 17 Aug 2009 23:07:49 +0200
Message-Id: <1250543271-8383-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090817144007.GC3602@elte.hu>
References: <20090817144007.GC3602@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a user runs perf trace using an input with logged counters
without PERF_SAMPLE_RAW attribute, warn by giving a nice tip.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/builtin-trace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b160a9f..88eef71 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -184,6 +184,10 @@ static int __cmd_trace(void)
 	header = perf_header__read(input);
 	sample_type = perf_header__sample_type(header);
 
+	if (!(sample_type & PERF_SAMPLE_RAW))
+		die("No trace sample to read. Did you call perf record "
+		    "without -R?");
+
 	if (load_kernel() < 0) {
 		perror("failed to load kernel symbols");
 		return EXIT_FAILURE;
-- 
1.6.2.3

