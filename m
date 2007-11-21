Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbXKUCax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbXKUCax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 21:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXKUCap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 21:30:45 -0500
Received: from dialup-63-108-131-18.nehp.net ([63.108.131.18]:38643 "EHLO
	waltsputer.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751068AbXKUCao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 21:30:44 -0500
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 21:30:44 EST
Message-ID: <47439670.4060102@lorettotel.net>
Date: Tue, 20 Nov 2007 20:22:40 -0600
From: Walt H <walt_h@lorettotel.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: lkml@rtr.ca, arjan@infradead.org, nickpiggin@yahoo.com.au
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On Tue, 20 Nov 2007 15:17:15 +1100
> Nick Piggin <nickpiggin@yahoo.com.au <mailto:nickpiggin@yahoo.com.au>> wrote:
>
> > On Tuesday 20 November 2007 15:12, Mark Lord wrote:
> > > On 32-bit x86, we have CONFIG_IRQBALANCE available,
> > > but not on 64-bit x86.  Why not?
>
> because the in-kernel one is actually quite bad.
>
>
> > > My QuadCore box works very well in 32-bit mode with IRQBALANCE,
> > > but responsiveness sucks bigtime when run in 64-bit mode (no
> > > IRQBALANCE) during periods of multiple heavy I/O streams (USB flash
> > > drives).
>
> please run the userspace irq balancer, see http://www.irqbalance.org
> afaik most distros ship that by default anyway.

I've been running the daemon for quite some time, however, have noticed 
something on my newest computer.  It's a core2 duo and the IRQ balance 
daemon always exits after some time.  After looking at the source, I see 
it's because dual core/hyperthreaded boxes (single domain caches) always 
get treated as though the --oneshot option were passed and exit after 
the first pass (I assume same thing happens on quad cores?).

Does this not adversely affect IRQ balancing on those CPU's?  If the IRQ 
load of a mostly idle device changes from when the daemon was run, 
wouldn't the inability of the balance to adjust it adversely affect 
performance if the load changes at a later time? I'm used to my old SMP 
box with 2 physical cores, so this is just something I've wondered about 
on the new box.  Thanks,

-Walt


