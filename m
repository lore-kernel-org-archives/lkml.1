Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0BOFXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 00:23:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:48268 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab0BOFXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 00:23:44 -0500
Date: Mon, 15 Feb 2010 05:21:42 GMT
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
Subject: [tip:tracing/urgent] kprobes: Add mcount to the kprobes blacklist
Message-ID: <tip-8b833c506c05c498d4215e2c260be44225daf6de@git.kernel.org>
Git-Commit-ID: 8b833c506c05c498d4215e2c260be44225daf6de
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 15 Feb 2010 05:21:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b833c506c05c498d4215e2c260be44225daf6de
Gitweb:     http://git.kernel.org/tip/8b833c506c05c498d4215e2c260be44225daf6de
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 5 Feb 2010 01:24:34 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 15 Feb 2010 05:45:49 +0100

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
index b7df302..c4b4343 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -93,6 +93,7 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{"native_get_debugreg",},
 	{"irq_entries_start",},
 	{"common_interrupt",},
+	{"mcount",},	/* mcount can be called from everywhere */
 	{NULL}    /* Terminator */
 };
 
