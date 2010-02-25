Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab0BYDmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:42:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:32868 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914Ab0BYDmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pglEJfiXlywRopvcrknxnJUL08flHVhQJBr0fAPdgi+LW3BVxWrpc1RU1vOvDqawI3
         MOkXv0DMLZIYXHnXZ9KzbA8qkmebAYab9M4BC78MTP6vza557uzmkZ3KxN+d2FnJmfGO
         S+8hDZg+mhWAv41K5JXKav1a5whosDPllTsPY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/10] perf/scripts: Fix bug in Util.pm
Date: Thu, 25 Feb 2010 04:42:33 +0100
Message-Id: <1267069361-10909-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
References: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

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
-- 
1.6.2.3

