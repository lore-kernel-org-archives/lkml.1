Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbZIOKJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbZIOKJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZIOKJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:09:50 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61892 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbZIOKJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:09:47 -0400
Message-ID: <4AAF6728.6010807@bk.jp.nec.com>
Date: Tue, 15 Sep 2009 19:06:32 +0900
From: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
       systemtap@sources.redhat.com
Subject: [PATCH 2/2] tracing: Export ftrace API for kernel modules
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export register_ and unresgister_ftrace_function_probe to modules. This can
be used by SystemTap.

Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
---
 kernel/trace/ftrace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5ef8f59..9c32291 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2042,6 +2042,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 
 	return count;
 }
+EXPORT_SYMBOL_GPL(register_ftrace_function_probe);
 
 enum {
 	PROBE_TEST_FUNC		= 1,
@@ -2108,6 +2109,7 @@ unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	__unregister_ftrace_function_probe(glob, ops, data,
 					  PROBE_TEST_FUNC | PROBE_TEST_DATA);
 }
+EXPORT_SYMBOL_GPL(unregister_ftrace_function_probe);
 
 void
 unregister_ftrace_function_probe_func(char *glob, struct ftrace_probe_ops *ops)
-- 
1.5.5.1




