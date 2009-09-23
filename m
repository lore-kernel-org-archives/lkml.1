Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbZIWJFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbZIWJFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZIWJFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:05:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:54122 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZIWJFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:05:30 -0400
Date: Wed, 23 Sep 2009 09:04:34 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, rusty@rustcorp.com.au, torvalds@linux-foundation.org,
       fweisbec@gmail.com, rostedt@goodmis.org, hch@lst.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, torvalds@linux-foundation.org,
       rusty@rustcorp.com.au, fweisbec@gmail.com, hch@lst.de,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.01.0909210908020.4950@localhost.localdomain>
References: <alpine.LFD.2.01.0909210908020.4950@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] modules, tracing: Remove stale struct marker signature from module_layout()
Message-ID: <tip-115e8a288252ef748f34f8b7c1115c563d702eda@git.kernel.org>
Git-Commit-ID: 115e8a288252ef748f34f8b7c1115c563d702eda
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 09:04:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  115e8a288252ef748f34f8b7c1115c563d702eda
Gitweb:     http://git.kernel.org/tip/115e8a288252ef748f34f8b7c1115c563d702eda
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 21 Sep 2009 18:22:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Sep 2009 10:34:21 +0200

modules, tracing: Remove stale struct marker signature from module_layout()

Linus reported this new build warning:

  kernel/module.c:2951: warning: ?struct marker? declared inside parameter list
  kernel/module.c:2951: warning: its scope is only this definition or declaration, which is probably not what you want

Caused by:

  fc53776: tracing: Remove markers

module_layout() is an artificial symbol with 'significant' symbols
listed in its argument list so that it gets a proper argument types
signature that modversions can pick up to decide whether a
module is version-compatible or not. If these dont match then we
wont even look at a module.

Remove the stale marker symbol.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <alpine.LFD.2.01.0909210908020.4950@localhost.localdomain>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/module.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index b6ee424..392eb3d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2947,7 +2947,6 @@ void module_layout(struct module *mod,
 		   struct modversion_info *ver,
 		   struct kernel_param *kp,
 		   struct kernel_symbol *ks,
-		   struct marker *marker,
 		   struct tracepoint *tp)
 {
 }
