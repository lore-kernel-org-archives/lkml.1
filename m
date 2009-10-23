Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbZJWXiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbZJWXiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZJWXh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:37:59 -0400
Received: from relay2.sgi.com ([192.48.179.30]:54770 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752904AbZJWXh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:37:56 -0400
Message-Id: <20091023233759.720502000@alcatraz.americas.sgi.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 Oct 2009 18:37:50 -0500
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] SGI x86_64 UV: Limit the number of scheduler debug messages
Content-Disposition: inline; filename=limit_sched
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit number of sched debug messages while system is BOOTING.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/sched.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -8003,7 +8003,9 @@
 			sd->child = NULL;
 	}
 
-	sched_domain_debug(sd, cpu);
+	if (cpu < 2 || system_state != SYSTEM_BOOTING ||
+					!limit_console_output(false))
+		sched_domain_debug(sd, cpu);
 
 	rq_attach_root(rq, rd);
 	rcu_assign_pointer(rq->sd, sd);

-- 
