Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbZDHFGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbZDHFGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbZDHFGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:06:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64632 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZDHFGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:06:06 -0400
Message-Id: <200904080505.n3855hcn017109@www262.sakura.ne.jp>
Subject: [2.6.30-rc1] Append a comma to INIT_FTRACE_GRAPH.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: srostedt@redhat.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Apr 2009 14:05:43 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 08042009 #1827297, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to lack of a comma, build fails if elements are appended to
INIT_TASK() macro.

arch/x86/kernel/init_task.c:33: error: request for member `XXXXXXXXXX' in something not a structure or union
arch/x86/kernel/init_task.c:33: error: initializer element is not constant
arch/x86/kernel/init_task.c:33: error: (near initialization for `init_task.ret_stack')
make[1]: *** [arch/x86/kernel/init_task.o] Error 1
make: *** [arch/x86/kernel] Error 2

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/ftrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.30-rc1.orig/include/linux/ftrace.h
+++ linux-2.6.30-rc1/include/linux/ftrace.h
@@ -357,7 +357,7 @@ struct ftrace_graph_ret {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 /* for init task */
-#define INIT_FTRACE_GRAPH		.ret_stack = NULL
+#define INIT_FTRACE_GRAPH		.ret_stack = NULL,
 
 /*
  * Stack of return addresses for functions
