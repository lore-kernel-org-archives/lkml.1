Return-Path: <linux-kernel-owner+w=401wt.eu-S933511AbYDZAUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511AbYDZAUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762574AbYDZAQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:16:02 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59199 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759087AbYDZAPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:15:52 -0400
Message-Id: <20080426001550.905540000@polaris-admin.engr.sgi.com>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 17:15:59 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] net: Pass reference to cpumask variable in net/sunrpc/svc.c
Content-Disposition: inline; filename=cpumask-in-sunrpc_svc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Pass reference to cpumask variable instead of using stack.

For inclusion into sched-devel/latest tree.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 net/sunrpc/svc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.sched.orig/net/sunrpc/svc.c
+++ linux-2.6.sched/net/sunrpc/svc.c
@@ -604,7 +604,7 @@ __svc_create_thread(svc_thread_fn func, 
 	error = kernel_thread((int (*)(void *)) func, rqstp, 0);
 
 	if (have_oldmask)
-		set_cpus_allowed(current, oldmask);
+		set_cpus_allowed_ptr(current, &oldmask);
 
 	if (error < 0)
 		goto out_thread;

-- 
