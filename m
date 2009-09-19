Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbZISJwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbZISJwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbZISJwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:52:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:57093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181AbZISJw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:52:29 -0400
Date: Sat, 19 Sep 2009 09:52:05 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, arjan@linux.intel.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090912130440.548666c1@infradead.org>
References: <20090912130440.548666c1@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf: Allow perf utilities to have "callback" options without arguments
Message-ID: <tip-a79d7db9fdb0037925ffa31f6ff9b189ff75d235@git.kernel.org>
Git-Commit-ID: a79d7db9fdb0037925ffa31f6ff9b189ff75d235
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 09:52:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a79d7db9fdb0037925ffa31f6ff9b189ff75d235
Gitweb:     http://git.kernel.org/tip/a79d7db9fdb0037925ffa31f6ff9b189ff75d235
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sat, 12 Sep 2009 07:52:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 11:42:11 +0200

perf: Allow perf utilities to have "callback" options without arguments

timechart needs to add a "callback" type command line argument that
does not take arguments.

This patch adds the parse-options.h infrastructure to make this
possible.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090912130440.548666c1@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-options.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index 8aa3464..2ee248f 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -104,6 +104,8 @@ struct option {
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), .argh = "time", .help = (h), .callback = parse_opt_approxidate_cb }
 #define OPT_CALLBACK(s, l, v, a, h, f) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f) }
+#define OPT_CALLBACK_NOOPT(s, l, v, a, h, f) \
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .flags = PARSE_OPT_NOARG }
 #define OPT_CALLBACK_DEFAULT(s, l, v, a, h, f, d) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d, .flags = PARSE_OPT_LASTARG_DEFAULT }
 
