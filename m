Return-Path: <linux-kernel-owner+w=401wt.eu-S1161025AbXCGAeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161025AbXCGAeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161028AbXCGAeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:34:06 -0500
Received: from www.osadl.org ([213.239.205.134]:47005 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161025AbXCGAeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:34:02 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Hecht <dhecht@vmware.com>, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <45EE0628.1080108@goop.org>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 01:40:07 +0100
Message-Id: <1173228007.24738.509.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 16:24 -0800, Jeremy Fitzhardinge wrote:
> >> 3) clockevent set_next_event interface is suboptimal for paravirt (and 
> >> probably realtime-ish uses).  The problem is that the expiry is passed 
> >> as a relative time.  On paravirt, an arbitrary amount of (stolen) time 
> >> may have passed since the delta was computed and when the timer device 
> >> is programmed, causing that next interrupt to be too far out in the 
> >> future.  It seems a better interface for set_next_event would be to pass 
> >> the current time and the absolute expiry.  Actually, I sent email to 
> >> Thomas and Ingo about this (and some other clockevents/hrtimer feedback) 
> >> in July 2006, but never heard back.  Thoughts?
> >>     
> >
> > There is no problem for realtime uses, as the reprogramming path is
> > running with local interrupts disabled. I can see the point for paravirt
> > and I'm not opposed to change / expand the interface for that. It might
> > be done by an extra clockevents feature flag, which requests absolute
> > time instead of relative time.
> >   
> 
> I'm not sure how much different it makes overall.  It's true that
> absolute time would be a more useful interface, but because the guest
> vcpu can be preempted at any time, we could miss the timeout
> regardless.  In Xen if you set a timeout for the past you get an
> immediate interrupt; I presume the clockevent code can deal with that?

Yep. You also can return -ETIME so it just works w/o an interrupt.

	tglx




