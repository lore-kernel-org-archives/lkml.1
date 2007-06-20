Return-Path: <linux-kernel-owner+w=401wt.eu-S1760439AbXFTDOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439AbXFTDOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 23:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbXFTDOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 23:14:37 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:30668 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbXFTDOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 23:14:36 -0400
X-IronPort-AV: i="4.16,440,1175486400"; 
   d="scan'208"; a="42733304:sNHT33514789"
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Paul Mundt <lethal@linux-sh.org>
Cc: Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, "Wu, Bryan" <Bryan.Wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Ungerer <gerg@snapgear.com>
In-Reply-To: <20070620030052.GA29161@linux-sh.org>
References: <46695F6D.5050600@t-online.de>
	 <200706191926.20210.rgetz@blackfin.uclinux.org>
	 <46695F6D.5050600@t-online.de>  <20070620030052.GA29161@linux-sh.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 20 Jun 2007 11:18:44 +0800
Message-Id: <1182309524.31771.15.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 20 Jun 2007 03:14:35.0398 (UTC) FILETIME=[20FDDA60:01C7B2E9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 12:00 +0900, Paul Mundt wrote:
> On Fri, Jun 08, 2007 at 03:53:49PM +0200, Bernd Schmidt wrote:
> > diff --git a/mm/nommu.c b/mm/nommu.c
> > index 2b16b00..7480a95 100644
> > --- a/mm/nommu.c
> > +++ b/mm/nommu.c
> [snip]
> > +	/*
> > +	 * Must always set the VM_SPLIT_PAGES flag for single-page allocations,
> > +	 * to avoid trying to get the order of the compound page later on.
> > +	 */
> > +	if (len == PAGE_SIZE)
> > +		vma->vm_flags |= VM_SPLIT_PAGES;
> > +	else if (flags & MAP_SPLIT_PAGES
> 
> And now you've just broken every non-blackfin nommu platform, as you've
> only defined MAP_SPLIT_PAGES in asm-blackfin/mman.h.
> 
> > +#ifdef CONFIG_NP2
> > +	    || len < total_len
> > +#endif
> 
> And what is this? It only shows up in the blackfin defconfig. This is not
> the place to be putting board-specific hacks.

Yes, it is our own NP2 memory allocator option. I think Bernd will fix
it.

> 
> On Tue, Jun 19, 2007 at 07:26:19PM -0400, Robin Getz wrote:
> > I'm assuming that since no one had any large objections, that this is OK, and 
> > we should send to Andrew to live in -mm for awhile?
> > 
> No real objections to the approach, but it would be nice if these sorts
> of things were test compiled for at least one platform that isn't yours,
> so the obviously broken stuff is fixed before it's posted and someone
> else has to find out about it later.

Exactly, Could please do some simple test on your SH-NOMMU platform? And
we are waiting for some feedback from other nommu arch maintainers.

David and Grep could you please help on this? Maybe Robin got some m68k
nommu by hand which can be used for testing, I only have Blackfin, -:))

Thanks, Paul.
Regards,
- Bryan

> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
