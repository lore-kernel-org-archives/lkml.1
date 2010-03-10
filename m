Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab0CJNTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:19:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:57410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab0CJNTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:19:37 -0500
Date: Wed, 10 Mar 2010 13:18:55 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100304140100.468665803@chello.nl>
References: <20100304140100.468665803@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf: Add attr->precise support to raw event parsing
Message-ID: <tip-69fef0d2e2c2c049ef4207a52e78b50d527bd85a@git.kernel.org>
Git-Commit-ID: 69fef0d2e2c2c049ef4207a52e78b50d527bd85a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:18:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69fef0d2e2c2c049ef4207a52e78b50d527bd85a
Gitweb:     http://git.kernel.org/tip/69fef0d2e2c2c049ef4207a52e78b50d527bd85a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 4 Mar 2010 13:57:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:32 +0100

perf: Add attr->precise support to raw event parsing

Minimal userspace interface to the new 'precise' events flag.

Can be used like "perf top -e r00c0p" which will use PEBS to sample
retired instructions.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <20100304140100.468665803@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 05d0c5c..a201445 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -656,6 +656,10 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
+		if (str[n+1] == 'p') {
+			attr->precise = 1;
+			n++;
+		}
 		*strp = str + n + 1;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
