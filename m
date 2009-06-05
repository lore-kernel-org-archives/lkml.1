Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbZFESrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbZFESrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZFESq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:46:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:37600 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbZFESq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:46:58 -0400
Date: Fri, 5 Jun 2009 18:46:19 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1244223061-5399-1-git-send-email-fweisbec@gmail.com>
References: <1244223061-5399-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf top: Fix zero or negative refresh delay
Message-ID: <tip-2f335a02b3c816e77e7df1d15b12e3bbb8f4c8f0@git.kernel.org>
Git-Commit-ID: 2f335a02b3c816e77e7df1d15b12e3bbb8f4c8f0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 18:46:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f335a02b3c816e77e7df1d15b12e3bbb8f4c8f0
Gitweb:     http://git.kernel.org/tip/2f335a02b3c816e77e7df1d15b12e3bbb8f4c8f0
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 5 Jun 2009 19:31:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 20:42:53 +0200

perf top: Fix zero or negative refresh delay

If perf top is executed with a zero value for the refresh rate,
we get a division by zero exception while computing samples_per_sec.

Also a zero refresh rate is not possible, neither do we want to
accept negative values.

[ Impact: fix division by zero in perf top ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1244223061-5399-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index ff7e13c..b2f480b 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -693,6 +693,9 @@ int cmd_top(int argc, const char **argv, const char *prefix)
 		event_id[0] = 0;
 	}
 
+	if (delay_secs < 1)
+		delay_secs = 1;
+
 	for (counter = 0; counter < nr_counters; counter++) {
 		if (event_count[counter])
 			continue;
