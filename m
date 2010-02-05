Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab0BEHvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 02:51:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:47749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab0BEHvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:51:36 -0500
Date: Fri, 5 Feb 2010 07:48:40 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ananth@in.ibm.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20100205062433.3745.36726.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100205062433.3745.36726.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Add mcount to the kprobes blacklist
Message-ID: <tip-5ecaafdbf44b1ba400b746c60c401d54c7ee0863@git.kernel.org>
Git-Commit-ID: 5ecaafdbf44b1ba400b746c60c401d54c7ee0863
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 07:48:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ecaafdbf44b1ba400b746c60c401d54c7ee0863
Gitweb:     http://git.kernel.org/tip/5ecaafdbf44b1ba400b746c60c401d54c7ee0863
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 5 Feb 2010 01:24:34 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Feb 2010 08:13:57 +0100

kprobes: Add mcount to the kprobes blacklist

Since mcount function can be called from everywhere,
it should be blacklisted. Moreover, the "mcount" symbol
is a special symbol name. So, it is better to put it in
the generic blacklist.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100205062433.3745.36726.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kprobes.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c3340e8..ccec774 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -94,6 +94,7 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{"native_get_debugreg",},
 	{"irq_entries_start",},
 	{"common_interrupt",},
+	{"mcount",},	/* mcount can be called from everywhere */
 	{NULL}    /* Terminator */
 };
 
