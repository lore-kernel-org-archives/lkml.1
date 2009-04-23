Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbZDWHad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbZDWHad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZDWH12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:28 -0400
Received: from sous-sol.org ([216.99.217.87]:48160 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754707AbZDWH1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:19 -0400
Message-Id: <20090423072201.068795610@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:30 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 010/100] tracing/core: fix early free of cpumasks
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=tracing-core-fix-early-free-of-cpumasks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

upstream commit: 2fc1dfbe17e7705c55b7a99da995fa565e26f151

Impact: fix crashes when tracing cpumasks

While ring-buffer allocation, the cpumasks are allocated too,
including the tracing cpumask and the per-cpu file mask handler.
But these cpumasks are freed accidentally just after.
Fix it.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237164303-11476-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3886,7 +3886,8 @@ __init static int tracer_alloc_buffers(v
 				       &trace_panic_notifier);
 
 	register_die_notifier(&trace_die_notifier);
-	ret = 0;
+
+	return 0;
 
 out_free_cpumask:
 	free_cpumask_var(tracing_cpumask);

