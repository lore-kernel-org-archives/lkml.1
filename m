Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbZK3IY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbZK3IY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZK3IY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:24:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:37888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbZK3IYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:24:24 -0500
Date: Mon, 30 Nov 2009 08:23:57 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259565529-6407-3-git-send-email-tzanussi@gmail.com>
References: <1259565529-6407-3-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/scripting] perf trace/scripting: Ignore shadowed variable warning for perf-trace-perl.c
Message-ID: <tip-e136323c5a8a7d91d17c5b7b340758bb9dd33739@git.kernel.org>
Git-Commit-ID: e136323c5a8a7d91d17c5b7b340758bb9dd33739
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e136323c5a8a7d91d17c5b7b340758bb9dd33739
Gitweb:     http://git.kernel.org/tip/e136323c5a8a7d91d17c5b7b340758bb9dd33739
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Mon, 30 Nov 2009 01:18:47 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 30 Nov 2009 09:04:00 +0100

perf trace/scripting: Ignore shadowed variable warning for perf-trace-perl.c

The debugging versions of the ENTER and LEAVE internal perl
macros, used when embedding perl, define a local block with a
my_perl perl variable that shadows a global variable of the same
name, which is also the name expected by the embedding API for
the embedded interpreter.

Since we don't have control over the code generated in this case
(it's an externality) and can't get rid of the warning, ignore it.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: anton@samba.org
Cc: hch@infradead.org
LKML-Reference: <1259565529-6407-3-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d62a2d7..20cd663 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -872,7 +872,7 @@ util/find_next_bit.o: ../../lib/find_next_bit.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o util/find_next_bit.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
 util/trace-event-perl.o: util/trace-event-perl.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o util/trace-event-perl.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes  -Wno-unused-parameter $<
+	$(QUIET_CC)$(CC) -o util/trace-event-perl.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
 scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o scripts/perl/Perf-Trace-Util/Context.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
