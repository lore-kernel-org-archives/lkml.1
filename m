Return-Path: <linux-kernel-owner+w=401wt.eu-S1762995AbZE0PBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762995AbZE0PBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758179AbZE0PBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:01:06 -0400
Received: from www.tglx.de ([62.245.132.106]:50983 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105AbZE0PBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:01:05 -0400
Date: Wed, 27 May 2009 17:00:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tracing: annotate emit_log_char() notrace
Message-ID: <alpine.LFD.2.00.0905271657340.3397@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk calls emit_log_char() in a loop which is cluttering the trace
buffer. Make it notrace.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/printk.c
===================================================================
--- linux-2.6-tip.orig/kernel/printk.c
+++ linux-2.6-tip/kernel/printk.c
@@ -499,7 +499,7 @@ static void call_console_drivers(unsigne
 	_call_console_drivers(start_print, end, msg_level);
 }
 
-static void emit_log_char(char c)
+static void notrace emit_log_char(char c)
 {
 	LOG_BUF(log_end) = c;
 	log_end++;
