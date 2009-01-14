Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZANC7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZANC7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZANC7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:59:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:51909 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZANC7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:59:12 -0500
Date: Wed, 14 Jan 2009 03:59:10 +0100
From: Nick Piggin <npiggin@suse.de>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       linux-mm@kvack.org
Subject: Re: OOPS and panic on 2.6.29-rc1 on xen-x86
Message-ID: <20090114025910.GA17395@wotan.suse.de>
References: <20090112172613.GA8746@shion.is.fushizen.net> <3e8340490901122054q4af2b4cm3303c361477defc0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8340490901122054q4af2b4cm3303c361477defc0@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:54:32PM -0500, Bryan Donlan wrote:
> On Mon, Jan 12, 2009 at 12:26 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
> > [resending with log/config inline as my previous message seems to have
> >  been eaten by vger's spam filters]
> >
> > Hi,
> >
> > After testing 2.6.29-rc1 on xen-x86 with a btrfs root filesystem, I
> > got the OOPS quoted below and a hard freeze shortly after boot.
> > Boot messages and config are attached.
> >
> > This is on a test system, so I'd be happy to test any patches.
> >
> > Thanks,
> >
> > Bryan Donlan
> 
> I've bisected the bug in question, and the faulty commit appears to be:
> commit e97a630eb0f5b8b380fd67504de6cedebb489003
> Author: Nick Piggin <npiggin@suse.de>
> Date:   Tue Jan 6 14:39:19 2009 -0800
> 
>     mm: vmalloc use mutex for purge
> 
>     The vmalloc purge lock can be a mutex so we can sleep while a purge is
>     going on (purge involves a global kernel TLB invalidate, so it can take
>     quite a while).
> 
>     Signed-off-by: Nick Piggin <npiggin@suse.de>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> The bug is easily reproducable by a kernel build on -j4 - it will
> generally OOPS and panic before the build completes.
> Also, I've tested it with ext3, and it still occurs, so it seems
> unrelated to btrfs at least :)
> 
> >
> > ------------[ cut here ]------------
> > Kernel BUG at c05ef80d [verbose debug info unavailable]
> > invalid opcode: 0000 [#1] SMP
> > last sysfs file: /sys/block/xvdc/size
> > Modules linked in:

It is bugging in schedule somehow, but you don't have verbose debug
info compiled in. Can you compile that in and reproduce if you have
the time?

Going bug here might indicate that there is some other problem with
the Xen and/or vmalloc code, regardless of reverting this patch.

Thanks,
Nick
