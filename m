Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987Ab0AWAUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab0AWAUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562Ab0AWAUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:20:40 -0500
Received: from kroah.org ([198.145.64.141]:35112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab0AWATE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:19:04 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:13 2010
Message-Id: <20100123001113.653626125@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Arjan van de Ven <arjan@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [27/29] perf timechart: Use tid not pid for COMM change
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arjan van de Ven <arjan@linux.intel.com>

commit 8f06d7e6e1bbfb32698d6d455583ab7460c090e2 upstream.

A process that changes its comm field, does this on a per kernel
task struct basis. The timechart tool used, incorrectly, the pid
to track this, and should have used the tid instead...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100116125319.34ac3edd@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/builtin-timechart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -275,7 +275,7 @@ static u64 cpus_pstate_state[MAX_CPUS];
 static int
 process_comm_event(event_t *event)
 {
-	pid_set_comm(event->comm.pid, event->comm.comm);
+	pid_set_comm(event->comm.tid, event->comm.comm);
 	return 0;
 }
 static int


