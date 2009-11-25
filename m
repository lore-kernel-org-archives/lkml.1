Return-Path: <linux-kernel-owner+w=401wt.eu-S1752333AbZKYIcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbZKYIcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZKYIcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:32:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:48043 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZKYIck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:32:40 -0500
Date: Wed, 25 Nov 2009 08:31:29 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259133299-23594-2-git-send-email-tzanussi@gmail.com>
References: <1259133299-23594-2-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add 'signed' flag setting back into trace-event-parse.c
Message-ID: <tip-0d0bea5ea4a0e91feff22ac5e32e14ff3a682247@git.kernel.org>
Git-Commit-ID: 0d0bea5ea4a0e91feff22ac5e32e14ff3a682247
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d0bea5ea4a0e91feff22ac5e32e14ff3a682247
Gitweb:     http://git.kernel.org/tip/0d0bea5ea4a0e91feff22ac5e32e14ff3a682247
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 25 Nov 2009 01:14:58 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Nov 2009 09:06:09 +0100

perf tools: Add 'signed' flag setting back into trace-event-parse.c

Commit 13999e59343b042b0807be2df6ae5895d29782a0 (perf tools:
Handle the case with and without the "signed" trace field)
removed code to set the FIELD_IS_SIGNED flag that was originally
added by commit 26a50744b21fff65bd754874072857bee8967f4d
(tracing/events: Add 'signed' field to format files).

This adds it back.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1259133299-23594-2-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index eae5605..7021dc1 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -941,7 +941,8 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 			if (read_expect_type(EVENT_ITEM, &token))
 				goto fail;
 
-			/* add signed type */
+			if (strtoul(token, NULL, 0))
+				field->flags |= FIELD_IS_SIGNED;
 
 			free_token(token);
 			if (read_expected(EVENT_OP, ";") < 0)
