Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYKKU7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYKKU7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYKKU6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:58:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39838 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbYKKU6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:58:12 -0500
Message-ID: <4919F1B9.3060300@redhat.com>
Date: Tue, 11 Nov 2008 15:57:29 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6/7] module: Add MODULE_STATE_LIVE notify
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a module notifier call which notifies that the state of a module changes
from MODULE_STATE_COMING to MODULE_STATE_LIVE.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 kernel/module.c |    2 ++
 1 file changed, 2 insertions(+)

Steven, Ananth told me that this patch might also help to solve
cmpxchg problem.

Index: 2.6.28-rc4/kernel/module.c
===================================================================
--- 2.6.28-rc4.orig/kernel/module.c
+++ 2.6.28-rc4/kernel/module.c
@@ -2346,6 +2346,8 @@ sys_init_module(void __user *umod,
 	/* Now it's a first class citizen!  Wake up anyone waiting for it. */
 	mod->state = MODULE_STATE_LIVE;
 	wake_up(&module_wq);
+	blocking_notifier_call_chain(&module_notify_list,
+				     MODULE_STATE_LIVE, mod);

 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

