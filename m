Return-Path: <linux-kernel-owner+w=401wt.eu-S934543AbZGQNW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543AbZGQNW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933583AbZGQNW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:22:59 -0400
Received: from www.tglx.de ([62.245.132.106]:49328 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933431AbZGQNW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:22:58 -0400
Date: Fri, 17 Jul 2009 15:22:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] tracing fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0907171521430.11571@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

Thanks,

	tglx

------------------>
Xiao Guangrong (1):
      tracing/function: Fix the return value of ftrace_trace_onoff_callback()


 kernel/trace/trace_functions.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 7402144..75ef000 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -363,7 +363,7 @@ ftrace_trace_onoff_callback(char *glob, char *cmd, char *param, int enable)
  out_reg:
 	ret = register_ftrace_function_probe(glob, ops, count);
 
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 static struct ftrace_func_command ftrace_traceon_cmd = {
