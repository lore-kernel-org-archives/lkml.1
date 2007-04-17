Return-Path: <linux-kernel-owner+w=401wt.eu-S1031283AbXDQWJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031283AbXDQWJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031282AbXDQWJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:09:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34652 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031283AbXDQWJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:09:48 -0400
Date: Wed, 18 Apr 2007 00:09:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Permanent Kgdb integration into the kernel - lets get with it.
Message-ID: <20070417220946.GC11944@one.firstfloor.org>
References: <7.469046093@selenic.com> <461C81C0.9040003@yahoo.com.au> <20070417204557.GL11115@waste.org> <46253B9F.4010907@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46253B9F.4010907@windriver.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I too am open to having a API, for KGDB, but it does need more than just 
> the trap vectors and the serial driver as hook points. There are a 
> number of patches to fix problems randing from the NET_POLL API, NMI 
> handling, 

You should submit these changes all as you fix them to the relevant
maintainers and mailing lists. There is only limited review capacity
and sending too many may tax it too much. So it's best used spaced
out -- as you do them. Also then you probably still remember why
you actually changed something. The few kgdb that were submitted
ever usually had the problem that they were submitted by someone
else who didn't do the work and couldn't quite remember why they
were actually needed.  Unsurprisingly they often didn't get
merged then.

> If you have an API, that you would like to contribute or suggest, I for 

The main interface are the (somewhat misnamed) die chains. More and more 
architectures are moving to them. 

There probably needs to be another one for serial intercept, but that 
should be very simple.  For network netpoll already exists.

> one am interested. I have long thought it would be nice to be able to 
> choose between kernel debug tools KDB, KGDB, KEXEC etc... much like you 
> can dynamically load I/O modules in KGDB and choose either RS232 or 
> Ethernet after the kernel has booted.

At some point we had a fully modular kdb (modprobe kdb worked) 
and kgdb was nearly there. Unfortunately the changes for kdb were
somewhat ugly. Unfortunately that work never hit the standard
patchkits for kgdb/kdb.

> At the current time, I am most certainly trying to consolidate the 
> source forge KGDB patches, Tom Rini's branch, as well as my own 
> development branch and hopefully Sergei's development branch as well. 
> Perhaps after the code stream is stable you we can take a further look 
> at what it takes to abstract a generic kernel debug interface. In the 

There already is one. I don't see the need for another one.

> mean time if you have code or skeleton API proposal, I am definitely 
> listening. It would be nice to have an in kernel soft single step API as 
> an example, which could be leveraged by KGDB and utrace/ptrace, but that 
> is a bit forward looking at this point.

kprobes already do that fine with the existing interfaces. Also
single stepping is not particularly complicated so i don't see why
you want to abstract it.

The other issue that needed some changes was stopping all CPUs for
debugging. Since some other subsystems (like kexec) have this problem
already i would suggest generalizing and exporting what they have already.

-Andi
