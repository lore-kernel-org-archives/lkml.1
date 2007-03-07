Return-Path: <linux-kernel-owner+w=401wt.eu-S1161094AbXCGBQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161094AbXCGBQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161098AbXCGBQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:16:46 -0500
Received: from www.osadl.org ([213.239.205.134]:51711 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161094AbXCGBQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:16:45 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Dan Hecht <dhecht@vmware.com>
Cc: Zachary Amsden <zach@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <45EE0A68.6010406@vmware.com>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0A68.6010406@vmware.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 02:22:50 +0100
Message-Id: <1173230571.24738.534.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 16:42 -0800, Dan Hecht wrote:
> >> accounting would be wrong.  Instead, we should allow the 
> >> tick_sched_timer in cases (c) and (d) to have runtime configurable 
> >> period, and then scale the time value accordingly before passing to 
> >> account_system_time.  This is probably something the Xen folks will want 
> >> also, since I think Xen itself only gets 100hz hard timer, and so it can 
> >> implement at best a oneshot virtual timer with 100hz resolution.  Any 
> >> objections to us doing something like this?
> > 
> > Yes. It's gross hackery. 
> > 
> > 1) We want to have a cleanup of the tick assumptions _all_ over the
> > place and this is going to be real hard work.
> > 
> > 2) As I said above. The time accounting for virtualization needs to be
> > fixed in a generic way.
> > 
> > I'm not going to accept some weird hackery for virtualization, which is
> > of exactly ZERO value for the kernel itself. Quite the contrary it will
> > make the cleanup harder and introduce another hard to remove thing,
> > which will in the worst case last for ever.
> >
> 
> Okay, to confirm I'm on the same page as you, you want to move process 
> time accounting from being periodic sampled based to being trace based? 
> i.e. at the system-call/interrupt boundaries, read clocksource and 
> compute directly the amount of system/user/process time?

At least for the paravirt guests this is the correct approach. Once the
CPU vendors come up with a sane solution for a reliable and fast clock
source we might use that on real hardware as well.

> Do you know if anyone has explored this?  I thought there was a 
> discussion about this a while back but it was rejected due to the 
> sample-based approach having much lower overheads on high system call 
> rate workloads.

Yes, with todays hardware it is simply a PITA. PowerPC has some basic
support for this though, IIRC.

	tglx


