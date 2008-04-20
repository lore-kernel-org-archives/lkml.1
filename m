Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbYDTNVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbYDTNVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 09:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYDTNVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 09:21:38 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34498 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbYDTNVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 09:21:37 -0400
Date: Sun, 20 Apr 2008 16:21:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420132113.GA1899@cs181133002.pp.htv.fi>
References: <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080420124717.GH8474@1wt.eu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 02:47:17PM +0200, Willy Tarreau wrote:
>...
> I certainly can understand that reducing memory footprint is useful, but
> if we want wider testing of 4k stacks, considering they may fail in error
> path in complex I/O environment, it's not likely during -rc kernels that
> we'll detect problems, and if we push them down the throat of users in a
> stable release, of course they will thank us very much for crashing their
> NFS servers in production during peak hours.

I've seen many bugs in error paths in the kernel and fixed quite a 
few of them - and stack problems were not a significant part of them.

There are so many possible bugs (that also occur in practice) that 
singling out stack usage won't gain much.

> I have nothing against changing the default setting to 4k provided that
> it is easy to get back to the save setting (ie changing a config option,
> or better, a cmdline parameter). I just don't agree with the idea of
> forcing users to swim in the sh*t, it only brings bad reputation to
> Linux.
>...

What actually brings bad reputation is shipping a 4k option that is 
known to break under some circumstances.

And history has shown that as long as 8k stacks are available on i386 
some problems will not get fixed. 4k stacks are available as an option 
on i386 for more than 4 years, and at about as long we know that there 
are some setups (AFAIK all that might still be present seem to include 
XFS) that are known to not work reliably with 4k stacks.

If we go after stability and reputation, we have to make a decision 
whether we want to get 4k stacks on 32bit architectures with 4k page 
size unconditionally or not at all. That's the way that gets the maximal 
number of bugs shaken out [1] for all supported configurations before 
they would hit a stable kernel.

> Willy

cu
Adrian

[1] obviously not all, but that's true for all classes of bugs

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

