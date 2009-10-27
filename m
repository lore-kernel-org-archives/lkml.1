Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZJ0NzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZJ0NzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbZJ0NzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:55:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:50385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbZJ0NzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:55:08 -0400
Date: Tue, 27 Oct 2009 13:54:34 GMT
From: tip-bot for Marti Raudsepp <marti@juffo.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, marti@juffo.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, marti@juffo.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <03ec9ee96f17cef05424.1256603584@localhost>
References: <03ec9ee96f17cef05424.1256603584@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Notify user when unrecognized event is specified
Message-ID: <tip-85df6f683efa457440eb922272fd5a71aa022ad4@git.kernel.org>
Git-Commit-ID: 85df6f683efa457440eb922272fd5a71aa022ad4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85df6f683efa457440eb922272fd5a71aa022ad4
Gitweb:     http://git.kernel.org/tip/85df6f683efa457440eb922272fd5a71aa022ad4
Author:     Marti Raudsepp <marti@juffo.org>
AuthorDate: Tue, 27 Oct 2009 00:33:04 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 27 Oct 2009 14:52:31 +0100

perf tools: Notify user when unrecognized event is specified

Previously no indication was given about what went wrong.

Signed-off-by: Marti Raudsepp <marti@juffo.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <03ec9ee96f17cef05424.1256603584@localhost>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b097570..e9e6d5c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -678,6 +678,8 @@ parse_event_symbols(const char **str, struct perf_event_attr *attr)
 	if (ret != EVT_FAILED)
 		goto modifier;
 
+	fprintf(stderr, "invalid or unsupported event: '%s'\n", *str);
+	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
 	return EVT_FAILED;
 
 modifier:
