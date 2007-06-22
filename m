Return-Path: <linux-kernel-owner+w=401wt.eu-S1760423AbXFVS1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423AbXFVS1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760766AbXFVS0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:26:52 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:57051 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760648AbXFVS0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:26:51 -0400
Message-Id: <20070622182315.421315690@goodmis.org>
References: <20070622182051.859570787@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jun 2007 14:20:55 -0400
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
Subject: [RFC PATCH 4/5 v2] Make DRM use the tasklet is-sched API
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
