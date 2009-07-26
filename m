Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbZGZIVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbZGZIVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZGZIVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:21:19 -0400
Received: from www.tglx.de ([62.245.132.106]:33919 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbZGZIVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:21:16 -0400
Message-Id: <20090726081556.967730546@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:19:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [Patch RFC 28/37] dvb: Convert "mutex" to semaphore
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=drivers-media-dvb-dvb-core-dvb-frontend-semaphore-init-instead-of-init-MUTEX.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completions in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/drivers/media/dvb/dvb-core/dvb_frontend.c
===================================================================
--- linux-2.6-tip.orig/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ linux-2.6-tip/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -678,7 +678,7 @@ static void dvb_frontend_stop(struct dvb
 
 	kthread_stop(fepriv->thread);
 
-	init_MUTEX (&fepriv->sem);
+	semaphore_init(&fepriv->sem);
 	fepriv->state = FESTATE_IDLE;
 
 	/* paranoia check in case a signal arrived */
@@ -1909,7 +1909,7 @@ int dvb_register_frontend(struct dvb_ada
 	}
 	fepriv = fe->frontend_priv;
 
-	init_MUTEX (&fepriv->sem);
+	semaphore_init(&fepriv->sem);
 	init_waitqueue_head (&fepriv->wait_queue);
 	init_waitqueue_head (&fepriv->events.wait_queue);
 	mutex_init(&fepriv->events.mtx);


