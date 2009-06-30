Return-Path: <linux-kernel-owner+w=401wt.eu-S1761257AbZF3X3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257AbZF3X3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760446AbZF3X2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:28:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:60510 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760324AbZF3X2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:28:45 -0400
Date: Tue, 30 Jun 2009 23:28:24 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090630230140.995643441@samba.org>
References: <20090630230140.995643441@samba.org>
Subject: [tip:perfcounters/urgent] perf top: Add ppc64 specific skip symbols and strip ppc64 . prefix
Message-ID: <tip-3a3393ef75a14ae259a82f3f38624efa17884168@git.kernel.org>
Git-Commit-ID: 3a3393ef75a14ae259a82f3f38624efa17884168
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 23:28:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a3393ef75a14ae259a82f3f38624efa17884168
Gitweb:     http://git.kernel.org/tip/3a3393ef75a14ae259a82f3f38624efa17884168
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Wed, 1 Jul 2009 09:00:47 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 01:25:19 +0200

perf top: Add ppc64 specific skip symbols and strip ppc64 . prefix

Filter out some ppc64 specific idle loop functions and remove
leading '.' on ppc64 text symbols.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
LKML-Reference: <20090630230140.995643441@samba.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-top.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 731ec6d..0506cd6 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -293,6 +293,8 @@ char *skip_symbols[] = {
 	"enter_idle",
 	"exit_idle",
 	"mwait_idle",
+	"ppc64_runlatch_off",
+	"pseries_dedicated_idle_sleep",
 	NULL
 };
 
@@ -303,6 +305,13 @@ static int symbol_filter(struct dso *self, struct symbol *sym)
 	const char *name = sym->name;
 	int i;
 
+	/*
+	 * ppc64 uses function descriptors and appends a '.' to the
+	 * start of every instruction address. Remove it.
+	 */
+	if (name[0] == '.')
+		name++;
+
 	if (!strcmp(name, "_text") ||
 	    !strcmp(name, "_etext") ||
 	    !strcmp(name, "_sinittext") ||
