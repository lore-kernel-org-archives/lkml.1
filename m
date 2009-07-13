Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZGMJCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZGMJCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZGMJCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:02:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:39956 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbZGMJCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:02:04 -0400
Date: Mon, 13 Jul 2009 09:01:19 GMT
From: tip-bot for Roel Kluin <roel.kluin@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, akpm@linux-foundation.org, roel.kluin@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, akpm@linux-foundation.org, roel.kluin@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A5A7F0B.4070106@gmail.com>
References: <4A5A7F0B.4070106@gmail.com>
Subject: [tip:perfcounters/urgent] perf_counter tools: Fix index boundary check
Message-ID: <tip-23cdb5d5171d591ec911aada682e09d53c14a810@git.kernel.org>
Git-Commit-ID: 23cdb5d5171d591ec911aada682e09d53c14a810
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Jul 2009 09:01:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23cdb5d5171d591ec911aada682e09d53c14a810
Gitweb:     http://git.kernel.org/tip/23cdb5d5171d591ec911aada682e09d53c14a810
Author:     Roel Kluin <roel.kluin@gmail.com>
AuthorDate: Mon, 13 Jul 2009 02:25:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Jul 2009 10:58:28 +0200

perf_counter tools: Fix index boundary check

Keep index within event_type_descriptors[]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A5A7F0B.4070106@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 518a33a..d18c98e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -436,7 +436,7 @@ void print_events(void)
 
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++, syms++) {
 		type = syms->type + 1;
-		if (type > ARRAY_SIZE(event_type_descriptors))
+		if (type >= ARRAY_SIZE(event_type_descriptors))
 			type = 0;
 
 		if (type != prev_type)
