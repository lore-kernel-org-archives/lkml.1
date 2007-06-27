Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbXF0Ton@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbXF0Ton (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761298AbXF0Tnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:43:40 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:50410 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427AbXF0Tnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:43:37 -0400
Message-Id: <20070627194327.735483284@goodmis.org>
References: <20070627193633.025544061@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 27 Jun 2007 15:36:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jonathan Corbet <corbet@lwn.net>,
       Arjan van de Ven <arjan@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC PATCH 4/8] Make DRM use the tasklet is-sched API
Content-Disposition: inline; filename=tasklet-driver-hacks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update the DRM driver to use the new tasklet API, which does not rely
on the tasklet implementation details.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Index: linux-2.6.21-rt9/drivers/char/drm/drm_irq.c
===================================================================
--- linux-2.6.21-rt9.orig/drivers/char/drm/drm_irq.c
+++ linux-2.6.21-rt9/drivers/char/drm/drm_irq.c
@@ -461,7 +461,7 @@ void drm_locked_tasklet(drm_device_t *de
 	static DECLARE_TASKLET(drm_tasklet, drm_locked_tasklet_func, 0);
 
 	if (!drm_core_check_feature(dev, DRIVER_HAVE_IRQ) ||
-	    test_bit(TASKLET_STATE_SCHED, &drm_tasklet.state))
+	    tasklet_is_scheduled(&drm_tasklet))
 		return;
 
 	spin_lock_irqsave(&dev->tasklet_lock, irqflags);

-- 
