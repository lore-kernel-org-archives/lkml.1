Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbZGBKcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbZGBKcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbZGBKcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:32:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:40540 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZGBKcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:32:01 -0400
Subject: Re: lockdep max numbers (was Re: Crashes during boot on 2.6.30 /
 2.6.31-rc, random programs)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Joao Correia <joaomiguelcorreia@gmail.com>, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
In-Reply-To: <20090702093120.GD6372@cr0.nay.redhat.com>
References: <a5d9929e0906270807s4c0ef74ap2296dce4c790ea9a@mail.gmail.com>
	 <2375c9f90906281908k7aa089a3v932dd368d572194b@mail.gmail.com>
	 <a5d9929e0906290153g305427c6j37f96db060cb4738@mail.gmail.com>
	 <20090629091508.GA6308@cr0.nay.redhat.com>
	 <a5d9929e0906290330s704d5848nb36ce2d37dc9124b@mail.gmail.com>
	 <20090630091640.GB5873@cr0.nay.redhat.com>
	 <a5d9929e0907011330u3b5f45a4l667b27e5cd22e22f@mail.gmail.com>
	 <20090702093120.GD6372@cr0.nay.redhat.com>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 12:32:00 +0200
Message-Id: <1246530720.4752.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 17:31 +0800, Amerigo Wang wrote:
> On Wed, Jul 01, 2009 at 09:30:23PM +0100, Joao Correia wrote:
> >Hello again
> >
> >Looks like this just opened the lid on some other limits. I just hit
> >another thing, which hadn't shown up before i made the changes, but
> >looks like its just another limit thats too low. This one is harder to
> >reproduce tho.
> >
> >Jun 30 21:35:03 hightech kernel: BUG: MAX_LOCKDEP_CHAINS too low!
> >Jun 30 21:35:03 hightech kernel: turning off the locking correctness validator.
> >Jun 30 21:35:03 hightech kernel: Pid: 9379, comm: qemu-kvm Not tainted
> 
> 
> Similar problem...
> 
> Peter? Would like to increase these numbers?

> >2.6.30-wl #3

> >Jun 30 21:35:03 hightech kernel: [<c05d0c66>] debug_dma_map_sg+0xe1/0x147

We recently fixed the dma debug stuff to require less lockdep resources,
Joerg might know if that made it into .30.

> >>>So i dug a little on the source and changed
> >>>
> >>>include/linux/sched.h
> >>>
> >>># define MAX_LOCK_DEPTH 48UL
> >>>
> >>>to
> >>>
> >>># define MAX_LOCK_DEPTH 96UL

> >> Let's Cc: Peter to see if he would like to change this number...
> >>
> >> Peter?

I really don't think we want to raise this, I mean, holding more that 48
locks at the same time is somewhat pushing it, don't you think?

Where do you run into this limit?

