Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZHPQBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZHPQBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 12:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbZHPQBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 12:01:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:39286 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbZHPQBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 12:01:12 -0400
Date: Sun, 16 Aug 2009 16:00:36 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250437927-25490-1-git-send-email-fweisbec@gmail.com>
References: <1250437927-25490-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf tools: Substract -Wformat-nonliteral from Wformat=2 in extra flags
Message-ID: <tip-0d31b82dd5c54a0b1e1d789427abdcc180bc4602@git.kernel.org>
Git-Commit-ID: 0d31b82dd5c54a0b1e1d789427abdcc180bc4602
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Aug 2009 16:00:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d31b82dd5c54a0b1e1d789427abdcc180bc4602
Gitweb:     http://git.kernel.org/tip/0d31b82dd5c54a0b1e1d789427abdcc180bc4602
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 16 Aug 2009 17:52:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 16 Aug 2009 17:56:09 +0200

perf tools: Substract -Wformat-nonliteral from Wformat=2 in extra flags

The soon coming perf trace needs to use printf with dynamically
built formats.

But we are using -Wformat=2 which is a shortcut for the
following set: -Wformat -Wformat-security -Wformat-y2k
-Wformat-nonliteral

-Wformat-nonliteral warns when it can't check formats because
they are not builtin constant strings, but we want to feature
dynamic formats. What we want instead is Wformat=2 minus
-Wformat-nonliteral, which is what this patch does.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1250437927-25490-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d637aea..5d54ddb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -169,7 +169,7 @@ endif
 #
 # Include saner warnings here, which can catch bugs:
 #
-EXTRA_WARNINGS = -Wcast-align -Wformat=2 -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement
+EXTRA_WARNINGS = -Wcast-align -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement
 
 CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
