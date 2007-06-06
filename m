Return-Path: <linux-kernel-owner+w=401wt.eu-S935854AbXFFV4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935854AbXFFV4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934563AbXFFV4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:56:14 -0400
Received: from animx.eu.org ([216.98.75.249]:42608 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135AbXFFV4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:56:13 -0400
Date: Wed, 6 Jun 2007 17:55:05 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Bodo Eggert <7eggert@gmx.de>, Andi Kleen <andi@firstfloor.org>,
       tmoore@spatial.ca, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Re: 4Gb ram not showing up
Message-ID: <20070606215505.GA19651@animx.eu.org>
Mail-Followup-To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Bodo Eggert <7eggert@gmx.de>, Andi Kleen <andi@firstfloor.org>,
	tmoore@spatial.ca, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.58.0706061356310.2657@be1.lrz> <20070606143723.GF10008@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606143723.GF10008@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Wed, Jun 06, 2007 at 02:12:22PM +0200, Bodo Eggert wrote:
> > Change the description of CONFIG_*HIGHMEM* to reflect "lost" memory due to 
> > PCI space and the existence of the NX flag.
> > 
> > Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
> > ---
> > I made this quick patch using the information from LKML as I remembered 
> > it. Please verify.
> > 
> > @@ -510,8 +510,15 @@ config NOHIGHMEM
> >  	  by the kernel to permanently map as much physical memory as
> >  	  possible.
> >  
> > -	  If the machine has between 1 and 4 Gigabytes physical RAM, then
> > +
> > +	  If the machine has between 1 and 3.5 Gigabytes physical RAM, then
> >  	  answer "4GB" here.
> > +	  

Might be better to say 3 Gigabytes instead of 3.5.  I booted a 4gb kernel on
a machine with 4gb at work and only saw 3gb of memory.

Also, I've noticed that there's ~128mb of memory lost if you select 1gb when
you have 1gb of memory installed.

> >  	  If more than 4 Gigabytes is used then answer "64GB" here. This
> >  	  selection turns Intel PAE (Physical Address Extension) mode on.
> > @@ -520,6 +527,10 @@ config NOHIGHMEM
> >  	  processors (Pentium Pro and better). NOTE: If you say "64GB" here,
> >  	  then the kernel will not boot on CPUs that don't support PAE!
> >  
> > +	  An additional benefit of the 64GB-Mode is the availability of the
> > +	  no-execute-pageflag, which can be used to prevent some attacks from
> > +	  injecting malicious code into applications.
> > +
> >  	  The actual amount of total physical memory will either be
> >  	  auto detected or can be forced by using a kernel command line option
> >  	  such as "mem=256M". (Try "man bootparam" or see the documentation of
> > @@ -532,14 +543,14 @@ config HIGHMEM4G
> >  	bool "4GB"
> >  	depends on !X86_NUMAQ
> >  	help
> > -	  Select this if you have a 32-bit processor and between 1 and 4
> > +	  Select this if you have a 32-bit processor and between 1 and 3.5
> >  	  gigabytes of physical RAM.
> >  
> >  config HIGHMEM64G
> > -	bool "64GB"
> > +	bool "64GB (enables no-execute memory protection if available)"
> >  	depends on X86_CMPXCHG64
> >  	help
> > -	  Select this if you have a 32-bit processor and more than 4
> > +	  Select this if you have a 32-bit processor and more than 3.5
> >  	  gigabytes of physical RAM.

Same here

> Seems like an improvement to me.  To fully explain how it could be 3 or
> 3.5 or 3.25 or who knows how many GB you can actually use without PAE
> would probably require writing a small novel.  Certainly talking about
> address space instead of amounts of physical memory is more correct.

It's probably worth it to just say 3gb.

I've looked at the cpuinfo for several machines, all of which (pIII and
better, not all physically support even 2gb of memory) show pae in the
flags, so is there really a reason not to just specify 64gb always?

The oldest machine I have access to is a pII 333mhz machine, cpuinfo also
lists pae in the cpu flags.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
