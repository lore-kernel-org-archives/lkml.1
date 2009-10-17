Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbZJQJ6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbZJQJ6L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 05:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZJQJ6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 05:58:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:40333 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZJQJ6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 05:58:08 -0400
Date: Sat, 17 Oct 2009 09:57:30 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20090827172318.8246.53702.stgit@localhost.localdomain>
References: <20090827172318.8246.53702.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] kprobes: Fix to add __kprobes to notify_die
Message-ID: <tip-8f270083587a4cb70fa14f0e2fd698eb08a4dd07@git.kernel.org>
Git-Commit-ID: 8f270083587a4cb70fa14f0e2fd698eb08a4dd07
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 09:57:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f270083587a4cb70fa14f0e2fd698eb08a4dd07
Gitweb:     http://git.kernel.org/tip/8f270083587a4cb70fa14f0e2fd698eb08a4dd07
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 27 Aug 2009 13:23:18 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 30 Aug 2009 03:08:26 +0200

kprobes: Fix to add __kprobes to notify_die

Add __kprobes to notify_die() because do_int3() calls notify_die()
instead of atomic_notify_call_chain() which is already marked as
__kprobes.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090827172318.8246.53702.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/notifier.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 61d5aa5..acd24e7 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -558,7 +558,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 
 static ATOMIC_NOTIFIER_HEAD(die_chain);
 
-int notrace notify_die(enum die_val val, const char *str,
+int notrace __kprobes notify_die(enum die_val val, const char *str,
 	       struct pt_regs *regs, long err, int trap, int sig)
 {
 	struct die_args args = {
