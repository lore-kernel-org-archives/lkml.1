Return-Path: <linux-kernel-owner+w=401wt.eu-S1759103AbZFNNTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103AbZFNNTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbZFNNTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:19:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:58365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbZFNNTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:19:13 -0400
Subject: Re: [RFC][GIT PULL][PATCH 0/10 -tip] cpu_debug patches 20090613
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0906141224550.2800@localhost.localdomain>
References: <1244910436.11733.14.camel@ht.satnam>
	 <alpine.LFD.2.00.0906132056540.2800@localhost.localdomain>
	 <1244957739.2679.42.camel@ht.satnam>
	 <alpine.LFD.2.00.0906141224550.2800@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 14 Jun 2009 18:49:58 +0530
Message-Id: <1244985598.2451.35.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-14 at 13:19 +0200, Thomas Gleixner wrote:
> Jaswinder,
> 
> [ I sanitized the cc list to restrict the annoyance to those who have
> to deal with that. Please stop adding people who are not affected by
> this. ]
> 

I wrote cpu_debug because of past issues I faced working with Hitachi
and ARM processor. I just start working on X86 from last few months, I
wrote cpu_debug for X86 because currently I have only X86 machine, I am
planning to divide cpu_debug into architecture dependent and
non-dependent code so that other architectures can also benefit from it.

That's why I CCed other architecture's maintainers.


> > This will be really useful for :
> > 1. developer who is porting/developing the kernel or drivers.
> 
> We can access all this information already with existing tools.
> 

Why you are thinking about X86 ?

I worked on embedded processors more than 10 year, I never found any
tools, and sometimes we get the first lot of the boards.

Only tool which I used is printk.

Even though the code I used in cpu_debug I wrote that code to support :
1. Performance counters for AMD
2. Support Temperature sensor for AMD 11H

>  
> > Of course you need a Hardware manual to check address and detail
> > information. I do not want to keep detail for each register.
> 
> That's why anyone with common sense will use lspci, cpuid to get the
> information in both raw and decoded format.


These does not make sense if the kernel is not booting and filesystem is
not available.
To use the tools I need to build the tools, build filesystem for my
processor and load on filesystem.

>  
> > In X86 many tools are available which can read many registers but not
> > available for many architectures (I CCed some architecture maintainers
> > so that they can also specify issues they face when supporting new
> > CPU/architecture), they can also take advantage of it if we move
> 
> I have ported Linux to a couple of new platforms and the problem you
> face is that the kernel does not boot at all in the early stage of the
> boot process. 
> 
> How does cpu_debug help in that situation ? It does not help at all.
> 

I supported functions if you pass seq = NULL then it will print on
screen, then you do need any filesystem or debugfs.

> > cpu_debug architecture independent portion outside X86.
> 
> There is nothing x86 independent in cpu_debug.
>  

There is, I will show you.

> > I am not against of any tool but some issues about tools are :
> > 1. Not supported for all architectures
> 
> Again cpu_debug can not made generic as it is poking in architecture
> specific hardware.
> 

Ok I will show you.

> > 2. Do not support latest or upcoming hardware
> 
> All these tools show the raw values, which also covers latest hardware.
> 

But when I used them they said processor not supported.

> > 3. You need to mount filesystem and execute some shell to give commands
> 
> Are you saying that the access to your debugfs based cpu_debug
> information does neither require a mounted file system nor a shell nor
> commands? It provides the information by telepathy, right?
> 

you can call the function, and pass seq as NULL, it will use printk and
dump state on screen. I just did this for MSR, I can also support for
other registers.

> > 4. you need different tools to access different registers
> 
> Write a wrapper script if that annoys you.
>  

when tools, filesystem and shell is not available where you will run
your script ?

> > So I want to know how can we can make cpu_debug more useful.
> 
> I have not yet seen a single technical argument for what it is useful
> at all.
> 

Because your eyes are closed, please open it.

Thanks,
--
JSR


