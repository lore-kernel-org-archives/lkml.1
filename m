Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbZJQJ6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbZJQJ6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 05:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZJQJ6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 05:58:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:40358 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbZJQJ6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 05:58:35 -0400
Date: Sat, 17 Oct 2009 09:57:58 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20090827172332.8246.34194.stgit@localhost.localdomain>
References: <20090827172332.8246.34194.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] kprobes: Prohibit to probe native_get_debugreg
Message-ID: <tip-65e234ec2c4a0659ca22531dc1372a185f088517@git.kernel.org>
Git-Commit-ID: 65e234ec2c4a0659ca22531dc1372a185f088517
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 09:58:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65e234ec2c4a0659ca22531dc1372a185f088517
Gitweb:     http://git.kernel.org/tip/65e234ec2c4a0659ca22531dc1372a185f088517
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 27 Aug 2009 13:23:32 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 30 Aug 2009 03:15:55 +0200

kprobes: Prohibit to probe native_get_debugreg

Since do_debug() calls get_debugreg(), native_get_debugreg() will be
called from singlestepping. This can cause an int3 infinite loop.

We can't put it in the .text.kprobes section because it is inlined,
then we blacklist its name.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090827172332.8246.34194.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/kprobes.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index f72e96c..3267d90 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -90,6 +90,7 @@ static spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
  */
 static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{"preempt_schedule",},
+	{"native_get_debugreg",},
 	{NULL}    /* Terminator */
 };
 
