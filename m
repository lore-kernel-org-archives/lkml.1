Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbZLPRBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbZLPRBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZLPRBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:01:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:54650 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762286AbZLPRAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:00:13 -0500
Message-Id: <20091216165904.987643843@chello.nl>
References: <20091216165553.802559834@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 17:55:56 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] perf-record: Use per-task-per-cpu events for inherited events
Content-Disposition: inline; filename=perf3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create events with a pid and cpu contraint for inherited events so
that we get a stream per cpu, instead of all cpus contending on a
single stream.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/builtin-record.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/tools/perf/builtin-record.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-record.c
+++ linux-2.6/tools/perf/builtin-record.c
@@ -278,7 +278,7 @@ static void create_counter(int counter, 
 
 	attr->mmap		= track;
 	attr->comm		= track;
-	attr->inherit		= (cpu < 0) && inherit;
+	attr->inherit		= inherit;
 	attr->disabled		= 1;
 
 try_again:
@@ -537,7 +537,7 @@ static int __cmd_record(int argc __used,
 	}
 
 
-	if (!system_wide || profile_cpu != -1) {
+	if ((!system_wide && !inherit) || profile_cpu != -1) {
 		open_counters(profile_cpu, target_pid);
 	} else {
 		for (i = 0; i < nr_cpus; i++)

-- 

