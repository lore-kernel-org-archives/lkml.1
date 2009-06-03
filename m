Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbZFCWgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbZFCWgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZFCWg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:36:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:43619 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbZFCWg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:36:26 -0400
Date: Wed, 3 Jun 2009 22:35:58 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Handle all known event types
Message-ID: <tip-d11444dfa78cdd887d8dfd2fab3883132aff2c2d@git.kernel.org>
Git-Commit-ID: d11444dfa78cdd887d8dfd2fab3883132aff2c2d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 22:35:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d11444dfa78cdd887d8dfd2fab3883132aff2c2d
Gitweb:     http://git.kernel.org/tip/d11444dfa78cdd887d8dfd2fab3883132aff2c2d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 23:29:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 23:29:14 +0200

perf report: Handle all known event types

We have munmap, throttle/unthrottle and period events as well,
process them - otherwise they are considered broke events and
we mis-parse the next few events.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 82b6252..6003cc3 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -893,6 +893,15 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	case PERF_EVENT_COMM:
 		return process_comm_event(event, offset, head);
 
+	/*
+	 * We dont process them right now but they are fine:
+	 */
+	case PERF_EVENT_MUNMAP:
+	case PERF_EVENT_PERIOD:
+	case PERF_EVENT_THROTTLE:
+	case PERF_EVENT_UNTHROTTLE:
+		return 0;
+
 	default:
 		return -1;
 	}
