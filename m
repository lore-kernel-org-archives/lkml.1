Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZBJEIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZBJEIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 23:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZBJEI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 23:08:26 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:55003 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZBJEI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 23:08:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=XVYkMz75HiOUr9XdKzFzDfASgGSn1vg9d1KxuB4bkANSPxP0ZeHCuh5iZD3U/4C0rM
         xiL7dMul1TAJkRaWMpVysTIyQEEyiPjLNrZmmAzg3xiEsbadwv7+7exSXYwRpFx6dnzq
         4D1aBLWKS/gry3ADXPo2E00iPId/yAmdiq4aY=
Message-ID: <4990fdb7.0e0f660a.1d27.5399@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Tue, 10 Feb 2009 04:43:30 +0100
Subject: [PATCH 1/2] tracing/sysprof: add missing tracing_{start,stop}_record_cmdline()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing pair tracing_{start,stop}_record_cmdline() to record well
the cmdline associated with pid.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_sysprof.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 84ca9d8..9902c15 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -238,6 +238,8 @@ static int stack_trace_init(struct trace_array *tr)
 {
 	sysprof_trace = tr;
 
+	tracing_start_cmdline_record();
+
 	mutex_lock(&sample_timer_lock);
 	start_stack_timers();
 	tracer_enabled = 1;
@@ -247,6 +249,7 @@ static int stack_trace_init(struct trace_array *tr)
 
 static void stack_trace_reset(struct trace_array *tr)
 {
+	tracing_stop_cmdline_record();
 	stop_stack_trace(tr);
 }
 
-- 
1.6.1


