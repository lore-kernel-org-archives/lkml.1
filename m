Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbXDWXJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbXDWXJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbXDWXJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:09:13 -0400
Received: from gw.goop.org ([64.81.55.164]:60974 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbXDWXJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:09:00 -0400
Message-ID: <462D3C9F.2030402@goop.org>
Date: Mon, 23 Apr 2007 16:09:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/25] xen: Xen implementation for paravirt_ops
References: <20070423215638.563901986@goop.org> <200704240050.06615.ak@suse.de>
In-Reply-To: <200704240050.06615.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Monday 23 April 2007 23:56:38 Jeremy Fitzhardinge wrote:
>   
>> Hi Andi,
>>
>> It applies to 2.6.21-rc7 + your patches + the last batch of pv_ops
>> patches 
>>     
>
> I got most of those except for the broken sched_clock change.
>   

Er, we had a bit of back-and-forward with that.  How did that end up?

>> I posted. 
>>     
>
> How much testing outside Jeremylabs has it gotten? Some beta
> testing before merging would be good, otherwise we'll just have
> a flood of fixes shortly when it is exposed to users.
>   

Yes.  I'm just prepping a tree for xen-devel, and I primed people at the
Xen Summit last week.

>> This patch generally restricts itself to Xen-specific parts of the tree,
>> though it does make a few small changes elsewhere.
>>     
>
> The general problem is that it is much more than just an architecture update.
>
>   
>> These patches include:
>>  - some helper routines for allocating address space and walking pagetables
>>     
>
> Needs review from mm people.
>   

These have been pretty well looked at already.  They have been posted
repeatedly, and I think all the comments have been sorted out. 
alloc_vm_area() will be a bit affected by Andrew's -mm patch to make
vmalloc_sync_all a globally-visible arch export, but they merge nicely.

>>  - Xen interface header files
>>  - Core Xen implementation
>>  - Efficient late-pinning/early-unpinning pagetable handling 
>>     
>
> The number of new paravirt hooks makes me thing of renaming it to
> everything_ops @|
>   

There's only one new op in this series, and I couldn't work out a way to
avoid it, other than putting a #ifdef CONFIG_XEN in kernel/setup.c.  The
last patch posting didn't add any new hooks.  Which ones are you
referring to?

>>  - Virtualized time, including stolen time
>>     
>
> Can you let it be reviewed by the time people? (Thomas, Ingo, John, Roman etc.)
>   

Thomas has looked at and generally approves of the Xen clocksource/event
code.  The stolen time code is really only used to generate a few
numbers in /proc, and so has very little direct impact on the rest of
the kernel, and hasn't really attracted much interest as a result.  I've
posted the patch to implement sched_clock in terms of unstolen time to
the various time people repeatedly, and nobody has responded, so I guess
it doesn't irritate anyone too much; it would be nice to have some
definite feedback though.

>>  - Xen console, based on hvc console
>>  - Xenbus
>>     
>
> That one would need to be reviewed first. It's so much code that I can't
> do it all myself.
>   

I put a specific plea for GregKH to look at this.

>>  - Netfront, the paravirtualized network device
>>     
>
> That one should go through the network device maintainer/netdev.
>   

Stephen Hemminger has looked at this in the past and we've addressed all
his comments so far.  But it would be nice to get some more net
developers to review this; it was cc:d to netdev.

>>  - Blockfront, the paravirtualized block device
>>     
>
> And that needs a block device review and whoever maintains that (Jens?) 
>   

He was cc:d.  I'll ask him specifically.

    J
