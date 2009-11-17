Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbZKQROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbZKQROU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbZKQRNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:13:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50464 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbZKQRNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:13:50 -0500
Message-Id: <20091117171355.617800861@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 17 Nov 2009 12:12:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/3] [PATCH 2/3] tracing: Prevent build warning: ftrace_graph_buf defined but not used
References: <20091117171242.761539651@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Prevent-build-warning-ftrace_graph_buf-defin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Prevent build warning when CONFIG_FUNCTION_GRAPH_TRACER is not set.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4AF24381.5060307@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1ed514f..7f9b51e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2274,7 +2274,6 @@ void ftrace_set_notrace(unsigned char *buf, int len, int reset)
 #define FTRACE_FILTER_SIZE		COMMAND_LINE_SIZE
 static char ftrace_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
 static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
-static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
 
 static int __init set_ftrace_notrace(char *str)
 {
@@ -2291,6 +2290,7 @@ static int __init set_ftrace_filter(char *str)
 __setup("ftrace_filter=", set_ftrace_filter);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
 static int __init set_graph_function(char *str)
 {
 	strlcpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
-- 
1.6.5


