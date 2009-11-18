Return-Path: <linux-kernel-owner+w=401wt.eu-S1751492AbZKRLNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbZKRLNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 06:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZKRLNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 06:13:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:36109 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbZKRLNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 06:13:53 -0500
Date: Wed, 18 Nov 2009 11:13:24 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4AF24381.5060307@cn.fujitsu.com>
References: <4AF24381.5060307@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Prevent build warning: 'ftrace_graph_buf' defined but not used
Message-ID: <tip-f6060f46819f313d34a8c8151390cda509c23389@git.kernel.org>
Git-Commit-ID: f6060f46819f313d34a8c8151390cda509c23389
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6060f46819f313d34a8c8151390cda509c23389
Gitweb:     http://git.kernel.org/tip/f6060f46819f313d34a8c8151390cda509c23389
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Thu, 5 Nov 2009 11:16:17 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 17 Nov 2009 11:05:49 -0500

tracing: Prevent build warning: 'ftrace_graph_buf' defined but not used

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
