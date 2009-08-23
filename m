Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZHWGJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZHWGJJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 02:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZHWGJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 02:09:08 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:45748 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZHWGJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 02:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EImyLfgV/b14ghiqHD9M2YB/Z2df0MBu2wWQy6bCOJso/EjElbwYt9U+/c+zgZUqyc
         gMrtLec4sIEbrGuSEzqqS6I20iPz+7/yE9aBdgYF+JiEBPYNf+suMuL9IX3TntoSmNp2
         sETN/Ys8rQiV6BnXF70A4FyHDpC23FGIjHUdI=
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: raz ben yehuda <raziebe@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: riel@redhat.com, mingo@elte.hu, peterz@infradead.org,
       andrew motron <akpm@osdl.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <1251004897.7043.70.camel@marge.simson.net>
References: <1250983671.5688.21.camel@raz>
	 <1251004897.7043.70.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 23 Aug 2009 12:09:11 +0300
Message-Id: <1251018551.3810.35.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-23 at 07:21 +0200, Mike Galbraith wrote:
> On Sun, 2009-08-23 at 02:27 +0300, raz ben yehuda wrote:
> > 			The Open University of Israel
> > 		  Department of Mathematics and computer science	
> > 			
> > 		  	 	FINAL PAPER
> > 			     OFFLINE  SCHEDULER
> > 
> > 
> > 
> > OFFSCHED is a platform aimed to assign an assignment to an offloaded processor.An offloaded processor is a processor that is hot un-plugged from the operating system.
> > 
> > Description
> > 
> > In today’s computer world, we find that most processors have several embedded cores and hyper-threading. Most programmers do not really use these powerful features and let the operating system do the work.
> > At most, a programmer will bound an application to a certain processor or assign an interrupt to a different processor. At the end, we get system busy in maintaining tasks across processors, balancing interrupts, flushing TLBs and DTLBs using atomic operations even when not needed and worst of all, spin locks across processors in vein; and the more processors the merrier. I argue that in some cases, part of this behavior is due to fact the multiple core operating system is not service oriented but a system oriented. There is no easy way to assign a processor to do a distinct service, undisturbed, accurate, and fast as long as the processor is an active part of an operating system and still be a part of most of the operating system address space.
> > 
> > OFFSCHED Purpose
> > 
> > The purpose of the OFFSCHED is to create a platform for services. For example, assume a firewall is being attacked; the Linux operating system will generate endless number of interrupts and/or softirqs to analyze the traffic and throw out bad packets. This is on the expense of “good” packets. Have you ever tried to “ssh” to an attacked machine? Who protects the operating system ?
> > What if we can simply do the packet analysis outside the operating system, without being interrupted ?
> > Why not assign a core to do only “firewalling”? Or just routing? Design a new type of Real Time system? Maybe assign it as an ultra accurate timer? Create a delaying service that does not just spin? Offload a TCP stack? perhaps a new type of a locking scheme? New type bottom-halves? Debug a running kernel through an offloaded processor? Maybe assign a GPU to do other things than just graphics?
> > Amdahl Law teaches us that linear speed-up is not very feasible , so why not spare a processor to do certain tasks better?
> > Technologically speaking, I am referring to the Linux kernel ability to virtually hot unplug a (SMT) processor ;but instead of letting it wonder in endless “halts”, assign it a service.
> 
> Seems to me this boils down to a different way to make a SW box in a HW
> box, which already exists.  What does this provide that  partitioning a
> box with csets and virtualization doesn't?
OFFSCHED does not compete with cpu sets nor virtualization.it is
different.

1. Neither virtuallization nor cpu sets provide hard real time. OFFSCHED
does this with a little cost and no impact on the OS.OFFSCHED is not
just accurate , it is also extremely fast,after all, it is NMI'ed
processor.

2. OFFSCHED has a access to every piece of memory in the system. so it
can act as a centry for the system, or use linux facilities. Also, the
kernel can access OFFSCHED memory, it is the same address space.

3. OFFSCHED can improve the linux OS ( NAPI,OFFSCHED firewall,RTOP ),
while a guest OS cannot.

4. cpu sets cannot replace softirqs and hardirqs. OFFSCHED can. cpu sets
deals with kernel threads and user space threads. in OFFSCHED we use
offlets. 

5. cpu sets and  virtualization are services provided by the kernel to
the "system".who serves the kernel ? who protects the kernel ? 

6. offlets gives the programmer full control over an entire processor.
no preemption, no interrupts, no quiesce. you know what happens , and
when it happens.

I have this hard real time system several years on my SMP/MC/SMT
machines. It serves me well. The core of OFFSCHED patch was 4 lines.
So,i simply compile a ***entirely regular*** linux bzImage and that's
it. It did not mess with drivers, spinlocks, softirqs ..., OFFSCHED just
directed the cpu_down to my own hard real time piece of code. The rest
of the kernel remained the same.  

> 	-Mike
> 

