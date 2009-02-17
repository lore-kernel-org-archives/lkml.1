Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZBQWSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZBQWSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZBQWSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:18:24 -0500
Received: from smtp4.ono.com ([62.42.230.177]:12456 "EHLO resmaa15.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750828AbZBQWSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:18:23 -0500
Date: Tue, 17 Feb 2009 23:18:16 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Bonding-devel] 2.6.29 regression? Bonding tied to IPV6 in
 29-rc5
Message-ID: <20090217231816.71c9ebaa@werewolf.home>
In-Reply-To: <499B30DC.5040303@hp.com>
References: <alpine.LFD.2.00.0902131413120.3179@localhost.localdomain>
	<20090217095232.5da06b9f@werewolf.home>
	<200902172001.41804.arvidjaar@mail.ru>
	<200902172117.22671.arvidjaar@mail.ru>
	<499B19AF.1000003@hp.com>
	<16929.1234904788@death.nxdomain.ibm.com>
	<499B30DC.5040303@hp.com>
X-Mailer: Claws Mail 3.7.0cvs64 (GTK+ 2.15.3; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009 16:49:16 -0500, Brian Haley <brian.haley@hp.com> wrote:

> Jay Vosburgh wrote:
> > Brian Haley <brian.haley@hp.com> wrote:
> > 
> >> Andrey Borzenkov wrote:
> > [...]
> >>> This hard dependency was apparently introduced by this commit:
> >>>
> >>> commit 305d552accae6afb859c493ebc7d98ca3371dae2
> >>> Author: Brian Haley <brian.haley@hp.com>
> >>> Date:   Tue Nov 4 17:51:14 2008 -0800
> >>>
> >>>     bonding: send IPv6 neighbor advertisement on failover
> >> I initially had bonding IPv6 support as a Kconfig option, but it was 
> >> decided it would be cleaner if it just got built-in whenever CONFIG_IPV6 
> >> was set like SCTP, with the assumption you might want it.
> >>
> >> Is it a common configuration to not allow a module to load like you're 
> >> doing in modprobe.conf?  I don't know how hard it would be to rip this 
> >> out into it's own bonding_ipv6.ko module, simply turning-off CONFIG_IPV6 
> >> seems better.
> > 
> > 	I'm not sure either of those really helps.  Distro kernels are
> > built with CONFIG_IPV6 (and would have the CONFIG_BONDING_IPV6_DINGUS
> > enabled as well), so the common case users would have it enabled, too.
> 
> I think that was one of the reasons too.
> 
> > 	Putting the ipv6 bits into a different module might not help,
> > either, because the "core" bonding code would still have the call to the
> > ipv6 functions.  Unless there's some magic way to somehow know at
> > runtime whether or not the ipv6 module is loaded, and only try to
> > resolve those symbols if ipv6 is loaded.  That seems complicated.
> 
> This separate bonding_ipv6 module would have to register itself with the 
> "core" one with a new proto_ops of some sort.  Calls are made for the 
> appropriate method, for example bond_ops->send_gratuitous(bond).  We'd 
> change the IPv4 code too.  It's just a theory, does make things more 
> complicated.
> 
> > 	To answer your question, I have come across this (aliasing ipv6
> > to nothing in modprobe.conf to disable IPv6) from time to time, but
> > didn't think of it when the NA code was added to bonding.
> 
> So I guess I'll start hacking the above, unless someone has a better 
> suggestion.

Perhaps the right way to start would be to think is if blocking the load
of ipv6 is the right way to disable IPV6.

Just as an example I realized recently (and I know it's not the same) if
I don't have ext4 loaded I can't format a disk on ext4. But disks still
work...

IPV6 looks like a special part of the kernel to disable _at runtime_.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.28.2-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed Jan
