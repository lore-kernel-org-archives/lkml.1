Return-Path: <linux-kernel-owner+w=401wt.eu-S1751387Ab0APUxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab0APUxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 15:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076Ab0APUxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 15:53:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:49050 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0APUxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 15:53:14 -0500
Date: Sat, 16 Jan 2010 12:53:19 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH] perf timechart: Use tid not pid for COMM change
Message-ID: <20100116125319.34ac3edd@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3e519cea7bbc7c6a3c07e3a24e9f33bf15305516 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 16 Jan 2010 12:51:30 -0800
Subject: [PATCH] perf timechart: Use tid not pid for COMM change

A process that changes its comm field, does this on a per kernel
task struct basis. The timechart tool used, incorrectly, the pid to track
this, and should have used the tid instead...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
CC: stable@kernel.org
---
 tools/perf/builtin-timechart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index a589a43..3f8bbcf 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -280,7 +280,7 @@ static u64 cpus_pstate_state[MAX_CPUS];
 
 static int process_comm_event(event_t *event, struct perf_session *session __used)
 {
-	pid_set_comm(event->comm.pid, event->comm.comm);
+	pid_set_comm(event->comm.tid, event->comm.comm);
 	return 0;
 }
 
-- 
1.6.2.5



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
