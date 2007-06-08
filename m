Return-Path: <linux-kernel-owner+w=401wt.eu-S938277AbXFHHYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938277AbXFHHYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937965AbXFHHSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:18:03 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33275 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936729AbXFHHR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:17:59 -0400
Message-Id: <20070608071531.699545000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       William Irwin <bill.irwin@oracle.com>,
       Christoph Lameter <clameter@engr.sgi.com>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 02/32] oom: kill all threads that share mm with killed task
Content-Disposition: inline; filename=oom-kill-all-threads-that-share-mm-with-killed-task.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David Rientjes <rientjes@google.com>

oom_kill_task() calls __oom_kill_task() to OOM kill a selected task.
When finding other threads that share an mm with that task, we need to
kill those individual threads and not the same one.

(Bug introduced by f2a2a7108aa0039ba7a5fe7a0d2ecef2219a7584)

Acked-by: William Irwin <bill.irwin@oracle.com>
Acked-by: Christoph Lameter <clameter@engr.sgi.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.13.orig/mm/oom_kill.c
+++ linux-2.6.20.13/mm/oom_kill.c
@@ -335,7 +335,7 @@ static int oom_kill_task(struct task_str
 	 */
 	do_each_thread(g, q) {
 		if (q->mm == mm && q->tgid != p->tgid)
-			force_sig(SIGKILL, p);
+			force_sig(SIGKILL, q);
 	} while_each_thread(g, q);
 
 	return 0;

-- 
