Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZKEDRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZKEDRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 22:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755719AbZKEDRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 22:17:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50807 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755710AbZKEDRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 22:17:05 -0500
Message-ID: <4AF24381.5060307@cn.fujitsu.com>
Date: Thu, 05 Nov 2009 11:16:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: prevent build warning: 'ftrace_graph_buf' defined
 but not used
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


prevent build warning when !CONFIG_FUNCTION_GRAPH_TRACER

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7cb6f19..892e3ea 100644
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

