Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbZEJGZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbZEJGZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 02:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZEJGZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 02:25:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:55181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZEJGZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 02:25:29 -0400
Date: Sun, 10 May 2009 06:24:45 GMT
From: tip-bot for Erdem Aktas <eaktas1@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eaktas1@gmail.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eaktas1@gmail.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <3fee128b0905092313x608e65e0l7b1116d86914114f@mail.gmail.com>
References: <3fee128b0905092313x608e65e0l7b1116d86914114f@mail.gmail.com>
Subject: [tip:perfcounters/core] perf_counter tools: fix buffer overwrite problem for perf top command
Message-ID: <tip-82afae6016b672acb90ceb8e773bba0bd977d2a3@git.kernel.org>
Git-Commit-ID: 82afae6016b672acb90ceb8e773bba0bd977d2a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 10 May 2009 06:24:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82afae6016b672acb90ceb8e773bba0bd977d2a3
Gitweb:     http://git.kernel.org/tip/82afae6016b672acb90ceb8e773bba0bd977d2a3
Author:     Erdem Aktas <eaktas1@gmail.com>
AuthorDate: Sun, 10 May 2009 02:13:19 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 10 May 2009 08:21:18 +0200

perf_counter tools: fix buffer overwrite problem for perf top command

There is a buffer overwrite problem in builtin-top.c line 526, When I
tried to use ./perf top command, it was giving memory corruption
problem.

[ Impact: fix 'perf top' crash ]

LKML-Reference: <3fee128b0905092313x608e65e0l7b1116d86914114f@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index cd6f61d..b1549dd 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -523,7 +523,7 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 	if (strstr(sym, "_text_start") || strstr(sym, "_text_end"))
 		return 1;
 
-	s->sym = malloc(strlen(str));
+	s->sym = malloc(strlen(str)+1);
 	assert(s->sym);
 
 	strcpy((char *)s->sym, str);
