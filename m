Return-Path: <linux-kernel-owner+w=401wt.eu-S936644AbYD1Sep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936644AbYD1Sep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966432AbYD1Sce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:32:34 -0400
Received: from mail.tmr.com ([64.65.253.246]:51103 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966428AbYD1Scc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:32:32 -0400
Message-ID: <4816198C.4000005@tmr.com>
Date: Mon, 28 Apr 2008 14:38:04 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Willy Tarreau <w@1wt.eu>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <20080420132113.GA1899@cs181133002.pp.htv.fi>
In-Reply-To: <20080420132113.GA1899@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Apr 20, 2008 at 02:47:17PM +0200, Willy Tarreau wrote:
>> ...
>> I certainly can understand that reducing memory footprint is useful, but
>> if we want wider testing of 4k stacks, considering they may fail in error
>> path in complex I/O environment, it's not likely during -rc kernels that
>> we'll detect problems, and if we push them down the throat of users in a
>> stable release, of course they will thank us very much for crashing their
>> NFS servers in production during peak hours.
> 
> I've seen many bugs in error paths in the kernel and fixed quite a 
> few of them - and stack problems were not a significant part of them.
> 
> There are so many possible bugs (that also occur in practice) that 
> singling out stack usage won't gain much.
> 
>> I have nothing against changing the default setting to 4k provided that
>> it is easy to get back to the save setting (ie changing a config option,
>> or better, a cmdline parameter). I just don't agree with the idea of
>> forcing users to swim in the sh*t, it only brings bad reputation to
>> Linux.
>> ...
> 
> What actually brings bad reputation is shipping a 4k option that is 
> known to break under some circumstances.
> 
> And history has shown that as long as 8k stacks are available on i386 
> some problems will not get fixed. 4k stacks are available as an option 
> on i386 for more than 4 years, and at about as long we know that there 
> are some setups (AFAIK all that might still be present seem to include 
> XFS) that are known to not work reliably with 4k stacks.
> 
> If we go after stability and reputation, we have to make a decision 
> whether we want to get 4k stacks on 32bit architectures with 4k page 
> size unconditionally or not at all. That's the way that gets the maximal 
> number of bugs shaken out [1] for all supported configurations before 
> they would hit a stable kernel.
> 
A good argument for keeping the default 8k and letting people who know 
what they are doing, or think they do, test their system for 4k 
operation. Embedded systems typically have far better defined loads than 
servers or desktops, and are less likely to have different behavior 
change the stack requirements. That doesn't mean they do less, just that 
the load is usually better characterized.

Vendors shipping a 4k stack kernel are probably not going to be happy if 
someone nfs exports an xfs filesystem on lvm, running on md raid0 
composed of raid5 arrays, containing multipath, iSCSI, SATA and nbd 
devices. No, I didn't make that up, someone asked me what I thought 
their problem was with that setup.

The kernel is getting more complex, and I don't think that anyone but 
you is interested in making 4k stacks mandatory, or in eliminating them, 
either.

You frequently take the attitude that something you don't like (like all 
the old but WORKING network drivers) should be removed from the kernel, 
so that people will be forced to use the new whatever and find bugs so 
they can be fixed. Unfortunately in some cases the bugs are never fixed 
and Linux loses a capability it once had.

The arbitrary 4k limit requires a lot of work on dropping stack usage 
even more than has already been done, and is mostly an effort you want 
other people to make so you can be happy (I assume that if you were 
offering to do it all yourself you already would have), and most 
importantly it would waste a lot of developer effort on a low return 
goal, which could be used on useful new features or fixing corner case 
bugs. Or drinking beer...

Hell, it wastes your time arguing about it, and you do lots of useful 
things when you're not trying to force your minimalist philosophy on people.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
