Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbYHVAPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbYHVAPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYHVAPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:15:16 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:35018 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752554AbYHVAPO (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:15:14 -0400
Message-ID: <48AE0476.80109@snapgear.com>
Date: Fri, 22 Aug 2008 10:12:38 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jared Hulbert <jaredeh@gmail.com>
CC: Jamie Lokier <jamie@shareable.org>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
References: <48AD00C4.6060302@gmail.com> <20080821110749.GA1926@shareable.org> <6934efce0808210711t686a88eci6eb294dbb54d68fe@mail.gmail.com>
In-Reply-To: <6934efce0808210711t686a88eci6eb294dbb54d68fe@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jared,

Jared Hulbert wrote:
>> How does it fare with no MMU?  Can the profiler and image builder lay
>> out the XIP pages in such a way that no-MMU mmaps can map those regions?
>>
>> No complaint if not, it would be a nice bonus though.
> 
> Sorry.  I don't believe it will work on no-MMU as is.  That said you
> _could_ tweak the mkfs tool to lay mmap()'ed regions down contiguously
> but then if you mmap() an unprofiled region, well that would be bad.
> I suppose you could make axfs_mmap smart enough to handle that.  I
> guess the cleanest way would be to just make files lay down
> contiguously, you lose some of the space saving but it would work.

That would be enough I think. If you could manually select
which files are contiguous-and-uncompressed that would be
useful for some too here.


> I'm not plannin to get to this anytime soon.  But I'd be willing merge
> patches.  Can anybody convince me offline that working on no-MMU this
> makes financial sense for my employer?  This is getting to be a common
> question.  How many noMMU users are out there and why are you so
> interested?

One of those unknown factors, how many are there?
Who knows, pretty much impossible to tell.

One thing for sure is that many people who do non-MMU setups
are interested in XIP to get the space savings. These are very
often small devices with very constrained RAM and flash. (For
whatever it is worth single NOR flash only boards are common in
these smaller form factors :-)

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
