Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbXJWRIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbXJWRIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbXJWRFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:05:46 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:35091
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754732AbXJWRFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:05:45 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 09/13] RT: Only dirty a cacheline if the priority is actually
	changing
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Tue, 23 Oct 2007 12:51:09 -0400
Message-ID: <20071023165109.5536.40755.stgit@novell1.haskins.net>
In-Reply-To: <20071023164156.5536.95573.stgit@novell1.haskins.net>
References: <20071023164156.5536.95573.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We can avoid dirtying a rq related cacheline with a simple check, so why not.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e536142..1058a1f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -376,7 +376,8 @@ static inline void update_rq_prio(struct rq *rq)
 	struct rt_prio_array *array = &rq->rt.active;
 	int                   prio  = sched_find_first_bit(array->bitmap);
 
-	set_rq_prio(rq, prio);
+	if (rq->highest_prio != prio)
+		set_rq_prio(rq, prio);
 }
 
 #else

