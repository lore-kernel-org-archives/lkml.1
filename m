Return-Path: <linux-kernel-owner+w=401wt.eu-S1761123AbZAOAEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761123AbZAOAEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758371AbZAOADg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:03:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56241 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777AbZAOADe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:03:34 -0500
Message-Id: <20090115000332.538872243@goodmis.org>
References: <20090115000254.519563275@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 Jan 2009 19:02:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/4] trace: stop all recording to ring buffer on ftrace_dump
Content-Disposition: inline; filename=0003-trace-stop-all-recording-to-ring-buffer-on-ftrace_d.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up to prevent more output in ftrace dump than needed

Currently ftrace_dump only calls ftrace_kill that is a fast way
to prevent the function tracer functions from being called (just sets
a flag and clears the function to call, nothing else). It is better
to also turn off any recording to the ring buffers as well.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 408c03f..dcb757f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3110,6 +3110,7 @@ void ftrace_dump(void)
 	dump_ran = 1;
 
 	/* No turning back! */
+	tracing_off();
 	ftrace_kill();
 
 	for_each_tracing_cpu(cpu) {
-- 
1.5.6.5

-- 
