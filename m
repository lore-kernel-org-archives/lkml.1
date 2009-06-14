Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbZFNOeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbZFNOeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 10:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbZFNOd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 10:33:59 -0400
Received: from www.tglx.de ([62.245.132.106]:52480 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbZFNOd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 10:33:59 -0400
Date: Sun, 14 Jun 2009 16:32:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][GIT PULL][PATCH 0/10 -tip] cpu_debug patches 20090613
In-Reply-To: <1244985598.2451.35.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0906141552220.2800@localhost.localdomain>
References: <1244910436.11733.14.camel@ht.satnam>  <alpine.LFD.2.00.0906132056540.2800@localhost.localdomain>  <1244957739.2679.42.camel@ht.satnam>  <alpine.LFD.2.00.0906141224550.2800@localhost.localdomain> <1244985598.2451.35.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder,

On Sun, 14 Jun 2009, Jaswinder Singh Rajput wrote:
> On Sun, 2009-06-14 at 13:19 +0200, Thomas Gleixner wrote:
> > > This will be really useful for :
> > > 1. developer who is porting/developing the kernel or drivers.
> > 
> > We can access all this information already with existing tools.
> > 
> 
> Why you are thinking about X86 ?

Because I work on it and that code is in the area which I'm
responsible for. And I want useful code in that area, not something
which causes a lot of churn for no value at all.

> I worked on embedded processors more than 10 year, I never found any
> tools, and sometimes we get the first lot of the boards.

I have worked on ARM, MIPS, SH, PPC often enough and I never needed
such a tool.

> Only tool which I used is printk.

Which is perfectly fine to do low level debugging.

> Even though the code I used in cpu_debug I wrote that code to support :
> 1. Performance counters for AMD
> 2. Support Temperature sensor for AMD 11H

And you needed cpu_debug to do this ? 

Sorry, I really do not understand that. Ingo and I wrote the inital
code of performance counters (both the generic parts and Intel
support) in a couple of days w/o feeling the need of cpu_debug even
once.

If you need cpu_debug for doing your work, fine. Maintain it somewhere
and figure out how many people come along and find it useful. But do
not impose this on the x86 code base.

> > > In X86 many tools are available which can read many registers but not
> > > available for many architectures (I CCed some architecture maintainers
> > > so that they can also specify issues they face when supporting new
> > > CPU/architecture), they can also take advantage of it if we move
> > 
> > I have ported Linux to a couple of new platforms and the problem you
> > face is that the kernel does not boot at all in the early stage of the
> > boot process. 
> > 
> > How does cpu_debug help in that situation ? It does not help at all.
> > 
> I supported functions if you pass seq = NULL then it will print on
> screen, then you do need any filesystem or debugfs.

Fine. And what is triggering the printout of a particular register ?

You need to hack the kernel to call the print functions in cpu_debug,
right ?

So where is the value of this? It is ad hoc debugging and there is no
gain to replace a printk(THE INFO I NEED) with a call to
cpu_debug().

Actually its worse. If I need the information of an APIC register,
then I print excaclty this register and not the whole lot of registers,
which then will scroll the screen with the important information
away.

Also I need information of a register in context with the content of
some variables of the code I'm debugging. printk() allows me to add
sensible and useful information in a compact format. cpu_debug does
not.

> > > 2. Do not support latest or upcoming hardware
> > 
> > All these tools show the raw values, which also covers latest hardware.
> > 
> 
> But when I used them they said processor not supported.

And why didn't you get the source and fix it? Instead of improving an
existing tool you impose a ridicolous amount of useless code on x86.

> > > 3. You need to mount filesystem and execute some shell to give commands
> > 
> > Are you saying that the access to your debugfs based cpu_debug
> > information does neither require a mounted file system nor a shell nor
> > commands? It provides the information by telepathy, right?
> > 
> 
> you can call the function, and pass seq as NULL, it will use printk and
> dump state on screen. I just did this for MSR, I can also support for
> other registers.

As I said above. There is no gain in doing so. Ad hoc debugging is the
same with printk and cpu_debug except that cpu_debug is inferior.

> > > So I want to know how can we can make cpu_debug more useful.
> > 
> > I have not yet seen a single technical argument for what it is useful
> > at all.
> > 
> 
> Because your eyes are closed, please open it.

I have my eyes open and I looked at the existing code and the proposed
patches in detail. I also looked at your arguments which can be boiled
down to:

1) Jaswinder prefers to have cpu_debug_print_whatever() instead of
   printk(THE INFO I NEED) for ad hoc debugging.

2) Jaswinder cannot work without cpu_debug.

Both are not really convincing technical arguments. cpu_debug has
_ZERO_ gain over printk() based debugging and it adds _ZERO_ value
with its debugfs based interface.

Thanks,

	tglx
