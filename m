Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0CJNOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:14:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:43126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab0CJNOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:14:52 -0500
Date: Wed, 10 Mar 2010 13:14:18 GMT
From: tip-bot for Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       ebmunson@us.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, ebmunson@us.ibm.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267804269-22660-2-git-send-email-acme@infradead.org>
References: <1267804269-22660-2-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Add ID and to recorded event data when recording multiple events
Message-ID: <tip-8907fd607b66e36636469a2de9833db643869db8@git.kernel.org>
Git-Commit-ID: 8907fd607b66e36636469a2de9833db643869db8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:14:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8907fd607b66e36636469a2de9833db643869db8
Gitweb:     http://git.kernel.org/tip/8907fd607b66e36636469a2de9833db643869db8
Author:     Eric B Munson <ebmunson@us.ibm.com>
AuthorDate: Fri, 5 Mar 2010 12:51:05 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:53:46 +0100

perf record: Add ID and to recorded event data when recording multiple events

Currently perf record does not write the ID or the to disk for
events. This doesn't allow report to tell if an event stream
contains one or more types of events.  This patch adds this
entry to the list of data that record will write to disk if more
than one event was requested.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1267804269-22660-2-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 771533c..f573bbb 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -244,6 +244,9 @@ static void create_counter(int counter, int cpu, pid_t pid)
 
 	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
+	if (nr_counters > 1)
+		attr->sample_type |= PERF_SAMPLE_ID;
+
 	if (freq) {
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 		attr->freq		= 1;
