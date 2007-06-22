Return-Path: <linux-kernel-owner+w=401wt.eu-S1761157AbXFVS2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761157AbXFVS2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760784AbXFVS1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:27:00 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:59023 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760647AbXFVS07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:26:59 -0400
Message-Id: <20070622182315.251069052@goodmis.org>
References: <20070622182051.859570787@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jun 2007 14:20:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
Subject: [RFC PATCH 3/5 v2] Add a tasklet is-scheduled API
Content-Disposition: inline; filename=tasklet-state-api.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tasklet_is_scheduled API to allow a driver
to know if its tasklet is already scheduled.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6-test/include/linux/tasklet.h
===================================================================
--- linux-2.6-test.orig/include/linux/tasklet.h
+++ linux-2.6-test/include/linux/tasklet.h
@@ -107,6 +107,11 @@ static inline void tasklet_hi_enable(str
 	atomic_dec(&t->count);
 }
 
+static inline int tasklet_is_scheduled(struct tasklet_struct *t)
+{
+	return test_bit(TASKLET_STATE_SCHED, &t->state);
+}
+
 extern void tasklet_kill(struct tasklet_struct *t);
 extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
 extern void tasklet_init(struct tasklet_struct *t,

-- 
