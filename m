Return-Path: <linux-kernel-owner+w=401wt.eu-S1751359AbZH0RWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbZH0RWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbZH0RWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:22:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbZH0RWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:22:20 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 4/6] kprobes: Fix to add __kprobes to
	notify_die
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Thu, 27 Aug 2009 13:23:18 -0400
Message-ID: <20090827172318.8246.53702.stgit@localhost.localdomain>
In-Reply-To: <20090827152539.GE6058@nowhere>
References: <20090827152539.GE6058@nowhere>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __kprobes to notify_die() because do_int3() calls notify_die() instead of
atomic_notify_call_chain() which is already marked as __kprobes.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
