Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbZBZUcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbZBZUcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZBZUcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:32:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058AbZBZUcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:32:15 -0500
Date: Thu, 26 Feb 2009 12:32:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesper Krogh <jesper@krogh.cc>
cc: David Woodhouse <David.Woodhouse@intel.com>, Dave Olsen <dolsen@lnxi.com>,
       Ryan Jackson <rjackson@lnxi.com>, linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <49A6EE17.4070102@krogh.cc>
Message-ID: <alpine.LFD.2.00.0902261229050.3111@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain> <49A679E8.1010301@krogh.cc> <alpine.LFD.2.00.0902260941090.3111@localhost.localdomain> <49A6EE17.4070102@krogh.cc>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Feb 2009, Jesper Krogh wrote:

> Linus Torvalds wrote:
> > On Thu, 26 Feb 2009, Jesper Krogh wrote:
> > > 
> > > Booting up 2.6.29-rc6 gave me this one in dmesg...
> > > 
> > > [   21.136149] ck804xrom ck804xrom_init_one(): Unable to register resource
> > > 0x00000000ff000000-0x00000000ffffffff - kernel bug?
> > 
> > Well, it _is_ a kernel bug, but it's in that stupid driver. It does
> > everything wrong, including printing out a scary message.
> 
> I've seen that before.. (even reported it before). It just "slipped" into the
> cut'n'paste It was the following stuff that I intended to report.

Ok. They very much are related. The new warning is just that - a new 
warning.

> > > [   21.136269] WARNING: at arch/x86/mm/ioremap.c:208
> > > __ioremap_caller+0x359/0x390()
> > 
> > This is a different, but related warning, since the driver is doing an
> > ioremap across different resources. The warning is directly related to the
> > fact that the resource wasn't actually valid to begin with.
> > 
> > What does "cat /proc/iomem" say?
> 
> http://krogh.cc/~jesper/iomem.txt

Ok, so the thing conflicts with

	ff700000-ffffffff : reserved
	  ff700000-ffffffff : pnp 00:0b

and that probably _is_ somehow related to the whole flash thing. 

I guess the driver could use "insert_resource()" and the problem would go 
away. Except I do think it should be marked very dangerous some way, so 
that you can't even enable it unless you really really know you want to 
(eg something like EXPERIMENTAL). Because I don't think this driver is 
appropriate in any other case..

> Being a "stupid" user, I pick the easy way to build a fresh kernel: 1) 
> pick the distro .config 2) make oldconfig 3) Let the kernel load what it 
> think it needs. 4) Report if I see and strange stuff (warnings / bugs / 
> oops) or misbehaviour.
> 
> So I dont know if I need that driver for anything vital. Should I care? 
> Or shouldn't it "just work"?

You definitely don't need it, and everything will work without it. 

			Linus
