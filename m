Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbZFNLUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbZFNLUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756526AbZFNLUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:20:08 -0400
Received: from www.tglx.de ([62.245.132.106]:36270 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260AbZFNLUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:20:06 -0400
Date: Sun, 14 Jun 2009 13:19:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][GIT PULL][PATCH 0/10 -tip] cpu_debug patches 20090613
In-Reply-To: <1244957739.2679.42.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0906141224550.2800@localhost.localdomain>
References: <1244910436.11733.14.camel@ht.satnam>  <alpine.LFD.2.00.0906132056540.2800@localhost.localdomain> <1244957739.2679.42.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder,

[ I sanitized the cc list to restrict the annoyance to those who have
to deal with that. Please stop adding people who are not affected by
this. ]

On Sun, 14 Jun 2009, Jaswinder Singh Rajput wrote:

> On Sun, 2009-06-14 at 00:27 +0200, Thomas Gleixner wrote:
> > On Sat, 13 Jun 2009, Jaswinder Singh Rajput wrote:
> > 
> > > Please let me know how we can improve it and add more features so it
> > > becomes more useful.
> > 
> > I really have to ask, why this is useful at all.
> > 
> 
> Currently for X86 I can do :
> 
> 1. read complete state (dump all registers like for MTRR, APIC)
> 2. read individual register
> 3. write to individual register
> 4. read/write these registers/info with shell through debugfs
> 5. read these registers/info before getting shell
> 
> And I did this for complete X86 CPU registers and info:
> 1. Standard Registers
> 2. Control Registers
> 3. Debug Registers
> 4. Descriptor Tables
> 5. APIC Registers
> 6. Model specific Register (MSRs)
> 7. PCI configuration registers (for AMD)
> 8. Basic cpuinfo
> 9. CPUID Functions

I did not ask what it can do. I did ask what's the usefulness of
it. Your answer is the same list on which I commented on already in
technical detail, but you ignored those comments.

> This will be really useful for :
> 1. developer who is porting/developing the kernel or drivers.

We can access all this information already with existing tools.

> 2. User who is reading hardware manual and want to see these value on
> its CPU

Same here.
 
> Of course you need a Hardware manual to check address and detail
> information. I do not want to keep detail for each register.

That's why anyone with common sense will use lspci, cpuid to get the
information in both raw and decoded format.
 
> In X86 many tools are available which can read many registers but not
> available for many architectures (I CCed some architecture maintainers
> so that they can also specify issues they face when supporting new
> CPU/architecture), they can also take advantage of it if we move

I have ported Linux to a couple of new platforms and the problem you
face is that the kernel does not boot at all in the early stage of the
boot process. 

How does cpu_debug help in that situation ? It does not help at all.

> cpu_debug architecture independent portion outside X86.

There is nothing x86 independent in cpu_debug.
 
> I am not against of any tool but some issues about tools are :
> 1. Not supported for all architectures

Again cpu_debug can not made generic as it is poking in architecture
specific hardware.

> 2. Do not support latest or upcoming hardware

All these tools show the raw values, which also covers latest hardware.

> 3. You need to mount filesystem and execute some shell to give commands

Are you saying that the access to your debugfs based cpu_debug
information does neither require a mounted file system nor a shell nor
commands? It provides the information by telepathy, right?

> 4. you need different tools to access different registers

Write a wrapper script if that annoys you.
 
> So I want to know how can we can make cpu_debug more useful.

I have not yet seen a single technical argument for what it is useful
at all.

So please stop hand waving about what it might do as long as you can
not provide a single technical reason why cpu_debug should be in the
kernel at all.

Go through the kernel.org bugzilla and show me _one_ single bug which
I debugged with the bug reporter, which could have been resolved
faster by using cpu_debug. And think careful about it before you
provide me that information.

> > The reinvention of useful tools like lspci, cpuid, rdmsr, wrmsr inside
> > of the kernel with a worse user interface and less information
> > provided is just a waste of time and resources.
> > 
> 
> what user interface and information you want ?

I'm happy to use the existing tools and their user interface. There is
no value of having inferior reimplementations of those tools in the
kernel.

Thanks,

	tglx
