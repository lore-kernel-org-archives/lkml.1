Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0BYKHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:07:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:47444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948Ab0BYKHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:07:32 -0500
Date: Thu, 25 Feb 2010 10:06:54 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264580883-15324-3-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-3-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/scripts: Fix bug in Util.pm
Message-ID: <tip-e26207a3819684e9b4450a2d30bdd065fa92d9c7@git.kernel.org>
Git-Commit-ID: e26207a3819684e9b4450a2d30bdd065fa92d9c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:06:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e26207a3819684e9b4450a2d30bdd065fa92d9c7
Gitweb:     http://git.kernel.org/tip/e26207a3819684e9b4450a2d30bdd065fa92d9c7
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 27 Jan 2010 02:27:53 -0600
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 23 Feb 2010 20:34:45 +0100

perf/scripts: Fix bug in Util.pm

Fix bogus calculation.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1264580883-15324-3-git-send-email-tzanussi@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
index 052f132..f869c48 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
@@ -44,7 +44,7 @@ sub nsecs_secs {
 sub nsecs_nsecs {
     my ($nsecs) = @_;
 
-    return $nsecs - nsecs_secs($nsecs);
+    return $nsecs % $NSECS_PER_SEC;
 }
 
 sub nsecs_str {
