Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbZHWJwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbZHWJwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbZHWJwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:52:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:53453 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755964AbZHWJwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:52:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19cmKlubyVcXJ4EQSIGL8atQbwMYYuwXe8tBIhVJ2
	dysNQUMhTj/epr
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Mike Galbraith <efault@gmx.de>
To: raz ben yehuda <raziebe@gmail.com>
Cc: riel@redhat.com, mingo@elte.hu, peterz@infradead.org,
       andrew motron <akpm@osdl.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <1251025557.3810.65.camel@raz>
References: <1250983671.5688.21.camel@raz>
	 <1251004897.7043.70.camel@marge.simson.net>  <1251018551.3810.35.camel@raz>
	 <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>
Content-Type: text/plain
Date: Sun, 23 Aug 2009 11:52:13 +0200
Message-Id: <1251021133.14003.172.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-23 at 14:05 +0300, raz ben yehuda wrote:
> On Sun, 2009-08-23 at 09:30 +0200, Mike Galbraith wrote:
> > On Sun, 2009-08-23 at 12:09 +0300, raz ben yehuda wrote:
> > > On Sun, 2009-08-23 at 07:21 +0200, Mike Galbraith wrote:
> > 
> > > > Seems to me this boils down to a different way to make a SW box in a HW
> > > > box, which already exists.  What does this provide that  partitioning a
> > > > box with csets and virtualization doesn't?
> > > OFFSCHED does not compete with cpu sets nor virtualization.it is
> > > different.
> > > 
> > > 1. Neither virtuallization nor cpu sets provide hard real time. OFFSCHED
> > > does this with a little cost and no impact on the OS.OFFSCHED is not
> > > just accurate , it is also extremely fast,after all, it is NMI'ed
> > > processor.
> > 
> > Why not?  Why can't I run an RT kernel with an RTOS guest and let it do
> > it's deadline management thing?
> Have you ever tested how long a single context switch cost ? can you run
> this system with a 1us accuracy ? you cannot.try ftrac'ing your system.
> the interrupt alone costs several hundreds nano seconds. By the time you
> will be reaching your code, the deadline will be nearly gone.  

I've measured context switch cost many times.  The point though, wasn't
how tight a constraint may be, you maintained that realtime was out the
window, and I didn't see any reason for that to be the case.

> > > 2. OFFSCHED has a access to every piece of memory in the system. so it
> > > can act as a centry for the system, or use linux facilities. Also, the
> > > kernel can access OFFSCHED memory, it is the same address space.
> > 
> > Hm.  That appears to be a self negating argument.
> correct. but I can receive packets over napi and transmit packets over hard_start_xmit
> much faster than any guest OS. I can disable interrupts and move to poll
> mode, thus helping the operating system. can a guest OS help linux?

Depends entirely on the job at hand.  If the job is running a firewall
in kernel mode, no it won't cut the mustard.

(no offense intended, but this all sounds like a great big kernel module
to me, one which doesn't even taint the kernel)
  
> > > 3. OFFSCHED can improve the linux OS ( NAPI,OFFSCHED firewall,RTOP ),
> > > while a guest OS cannot.
> > > 
> > > 4. cpu sets cannot replace softirqs and hardirqs. OFFSCHED can. cpu sets
> > > deals with kernel threads and user space threads. in OFFSCHED we use
> > > offlets.
> > 
> > Which still looks like OS-fu to me.
> I do not understand this remark.

Whether it's offlet, tasklet, insert buzz-word of the day, it's thread
of execution management, which I called OS-fu, ie one of those things
that OSs do.

The rest, I'll leave off replying to, we're kinda splitting hairs.  I
don't see a big generic benefit to OFFSCHED or ilk, others do.

	-Mike


