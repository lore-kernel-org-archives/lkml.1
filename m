Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbXFVHMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbXFVHMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbXFVHLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:11:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:31922 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbXFVHLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:11:54 -0400
Subject: Re: [RFC PATCH 4/6] Make DRM use the tasklet is-sched API
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <1182494960.20203.34.camel@chaos>
References: <20070622040014.234651401@goodmis.org>
	 <20070622040137.104281523@goodmis.org>
	 <1182494169.3228.11.camel@dhcp193.mvista.com>
	 <1182494960.20203.34.camel@chaos>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 00:08:04 -0700
Message-Id: <1182496085.3228.26.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 08:49 +0200, Thomas Gleixner wrote:
> On Thu, 2007-06-21 at 23:36 -0700, Daniel Walker wrote:
> > On Fri, 2007-06-22 at 00:00 -0400, Steven Rostedt wrote:
> > > plain text document attachment (tasklet-driver-hacks.patch)
> > > Update the DRM driver to use the new tasklet API, which does not rely
> > > on the tasklet implementation details.
> > > 
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > 
> > > 
> > > Index: linux-2.6.21-rt9/drivers/char/drm/drm_irq.c
> > > ===================================================================
> > > --- linux-2.6.21-rt9.orig/drivers/char/drm/drm_irq.c
> > > +++ linux-2.6.21-rt9/drivers/char/drm/drm_irq.c
> > > @@ -461,7 +461,7 @@ void drm_locked_tasklet(drm_device_t *de
> > >  	static DECLARE_TASKLET(drm_tasklet, drm_locked_tasklet_func, 0);
> > >  
> > >  	if (!drm_core_check_feature(dev, DRIVER_HAVE_IRQ) ||
> > > -	    test_bit(TASKLET_STATE_SCHED, &drm_tasklet.state))
> > > +	    tasklet_is_scheduled(&drm_tasklet))
> > >  		return;
> > >  
> > >  	spin_lock_irqsave(&dev->tasklet_lock, irqflags);
> > > 
> > 
> > 
> > No sense in having a patch just for this, may as well merge this with
> > patch 3 ..
> 
> Wrong. patch 3 adds the API and this one makes use of it. Stevens split
> makes perfectly sense.

Clearly it doesn't make sense to me ;) .. The patches are too small to
split them up that way ..

Daniel

