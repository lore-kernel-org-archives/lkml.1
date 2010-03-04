Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab0CDQeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:34:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:46479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003Ab0CDQej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:34:39 -0500
Date: Thu, 4 Mar 2010 16:34:10 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267599873-8193-3-git-send-email-tzanussi@gmail.com>
References: <1267599873-8193-3-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf trace: Don't use pager if scripting
Message-ID: <tip-cf4fee50282312528e1f8adf73b1831d1d6ae389@git.kernel.org>
Git-Commit-ID: cf4fee50282312528e1f8adf73b1831d1d6ae389
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:34:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf4fee50282312528e1f8adf73b1831d1d6ae389
Gitweb:     http://git.kernel.org/tip/cf4fee50282312528e1f8adf73b1831d1d6ae389
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 3 Mar 2010 01:04:33 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Mar 2010 12:19:55 +0100

perf trace: Don't use pager if scripting

It's useful for paging through raw traces, but just gets in the
way when scripting.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
LKML-Reference: <1267599873-8193-3-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-trace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b8153db..407041d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -573,7 +573,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 
 	if (symbol__init() < 0)
 		return -1;
-	setup_pager();
+	if (!script_name)
+		setup_pager();
 
 	session = perf_session__new(input_name, O_RDONLY, 0);
 	if (session == NULL)
