Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbYJaMOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbYJaMOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 08:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYJaMOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 08:14:34 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:49538 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYJaMOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 08:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=NsEpSHqBC7zgbwx6lNN79JjcBt1c2WdLhHswS5dKsc/zhcqd4o/lQI68a5ws8p56q4
         tax0kgirsyc5cpussEI5W6pWeWevxrixpcpqdeariA2Uy6UEOejosR1/9gr5UeKp/0V9
         fSi2WOWqVh52ye3SI3NsV1exW9u4o4CzXI9gU=
Message-ID: <490AF6A4.7080604@gmail.com>
Date: Fri, 31 Oct 2008 13:14:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][RESEND] tracing/ftrace: Remove unused code in sched_switch
 tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When init_sched_switch_trace() is called, it has no reason to start
the sched tracer if the sched_ref is not zero.

_ If this is non-zero, the tracer is already used, but we can register it
to the tracing engine. There is already a security which avoid the tracer
probes not to be resgistered twice. 

_ If this is zero, this block will not be used.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_switch.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 59de514..96620c7 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -203,14 +203,6 @@ static struct tracer sched_switch_trace __read_mostly =
 
 __init static int init_sched_switch_trace(void)
 {
-	int ret = 0;
-
-	if (atomic_read(&sched_ref))
-		ret = tracing_sched_register();
-	if (ret) {
-		pr_info("error registering scheduler trace\n");
-		return ret;
-	}
 	return register_tracer(&sched_switch_trace);
 }
 device_initcall(init_sched_switch_trace);
