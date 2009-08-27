Return-Path: <linux-kernel-owner+w=401wt.eu-S1751521AbZH0RWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbZH0RWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZH0RW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:22:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZH0RWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:22:24 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 6/6] kprobes: Prohibit to probe
	native_get_debugreg
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Thu, 27 Aug 2009 13:23:32 -0400
Message-ID: <20090827172332.8246.34194.stgit@localhost.localdomain>
In-Reply-To: <20090827152539.GE6058@nowhere>
References: <20090827152539.GE6058@nowhere>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since do_debug() calls get_debugreg(), native_get_debugreg() will be called
from singlestepping. This can cause an int3 infinit loop.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
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
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
