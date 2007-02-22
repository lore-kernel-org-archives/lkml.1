Return-Path: <linux-kernel-owner+w=401wt.eu-S932799AbXBVH4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbXBVH4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 02:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbXBVH4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 02:56:34 -0500
Received: from www.osadl.org ([213.239.205.134]:50531 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932799AbXBVH4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 02:56:34 -0500
Subject: Re: [PATCH] Fix posix-cpu-timer breakage caused by stale
	p->last_ran value
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Mike Galbraith <efault@gmx.de>, balducci@units.it,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <20070222074624.GA9800@elte.hu>
References: <20070221104747.3cb0da32.akpm@linux-foundation.org>
	 <1172104409.25076.165.camel@localhost.localdomain>
	 <20070222074624.GA9800@elte.hu>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 09:01:39 +0100
Message-Id: <1172131299.25076.168.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 08:46 +0100, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > The problem is that the p->last_ran value is not updated after a 
> > context switch. So a subsequent call to current_sched_time() 
> > calculates with a stale p->last_ran value, i.e. accounts the full 
> > time, which the task was scheduled away.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> >  	sched_info_switch(prev, next);
> >  	if (likely(prev != next)) {
> > -		next->timestamp = now;
> > +		next->timestamp = next->last_ran = now;
> 
> ouch! nice catch. Also for v2.6.20.2 i think. 2.6.19 should be 
> unaffected.

Yes, was introduced in 2.6.20 and definitely should hit the stable tree.

	tglx


