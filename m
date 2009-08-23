Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZHWHaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZHWHaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 03:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbZHWHaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 03:30:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:36505 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752685AbZHWHaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 03:30:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ZY79TL6OZB4GYJrSgLPfvc8m1cO18GfWstjVVSG
	gk01pTLsw8tvHn
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Mike Galbraith <efault@gmx.de>
To: raz ben yehuda <raziebe@gmail.com>
Cc: riel@redhat.com, mingo@elte.hu, peterz@infradead.org,
       andrew motron <akpm@osdl.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <1251018551.3810.35.camel@raz>
References: <1250983671.5688.21.camel@raz>
	 <1251004897.7043.70.camel@marge.simson.net>  <1251018551.3810.35.camel@raz>
Content-Type: text/plain
Date: Sun, 23 Aug 2009 09:30:21 +0200
Message-Id: <1251012621.14003.71.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-23 at 12:09 +0300, raz ben yehuda wrote:
> On Sun, 2009-08-23 at 07:21 +0200, Mike Galbraith wrote:

> > Seems to me this boils down to a different way to make a SW box in a HW
> > box, which already exists.  What does this provide that  partitioning a
> > box with csets and virtualization doesn't?
> OFFSCHED does not compete with cpu sets nor virtualization.it is
> different.
> 
> 1. Neither virtuallization nor cpu sets provide hard real time. OFFSCHED
> does this with a little cost and no impact on the OS.OFFSCHED is not
> just accurate , it is also extremely fast,after all, it is NMI'ed
> processor.

Why not?  Why can't I run an RT kernel with an RTOS guest and let it do
it's deadline management thing?

> 2. OFFSCHED has a access to every piece of memory in the system. so it
> can act as a centry for the system, or use linux facilities. Also, the
> kernel can access OFFSCHED memory, it is the same address space.

Hm.  That appears to be a self negating argument.

> 3. OFFSCHED can improve the linux OS ( NAPI,OFFSCHED firewall,RTOP ),
> while a guest OS cannot.
> 
> 4. cpu sets cannot replace softirqs and hardirqs. OFFSCHED can. cpu sets
> deals with kernel threads and user space threads. in OFFSCHED we use
> offlets.

Which still looks like OS-fu to me.

> 5. cpu sets and  virtualization are services provided by the kernel to
> the "system".who serves the kernel ? who protects the kernel ?

If either one can diddle the others ram, they are in no way isolated or
protected, so can't even defend against their own bugs.

What protects a hard RT deadline from VM pressure, memory bandwidth
consumption etc etc?  Looks to me like it's soft RT, because you can't
control the external variables.

> 6. offlets gives the programmer full control over an entire processor.
> no preemption, no interrupts, no quiesce. you know what happens , and
> when it happens.

If I can route interrupts such that only say network interrupts are
delivered to my cset/vm core, and the guest OS is a custom high speed
low drag application, I just don't see much difference.
 
> I have this hard real time system several years on my SMP/MC/SMT
> machines. It serves me well. The core of OFFSCHED patch was 4 lines.
> So,i simply compile a ***entirely regular*** linux bzImage and that's
> it. It did not mess with drivers, spinlocks, softirqs ..., OFFSCHED just
> directed the cpu_down to my own hard real time piece of code. The rest
> of the kernel remained the same.

Aaaaanyway, I'm not saying it's not a useful thing to do, just saying I
don't see any reason you can't get essentially the same result with
what's in the kernel now.

	-Mike

