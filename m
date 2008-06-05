Return-Path: <linux-kernel-owner+w=401wt.eu-S1761836AbYFEXsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761836AbYFEXsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 19:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYFEXsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 19:48:31 -0400
Received: from ozlabs.org ([203.10.76.45]:60703 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYFEXsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 19:48:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [patch 02/41] cpu alloc: The allocator
Date: Fri, 6 Jun 2008 09:48:24 +1000
User-Agent: KMail/1.9.9
Cc: Christoph Lameter <clameter@sgi.com>, Eric Dumazet <dada1@cosmosbay.com>,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>
References: <20080530035620.587204923@sgi.com> <200805301552.25423.rusty@rustcorp.com.au> <4846B50F.5060808@sgi.com>
In-Reply-To: <4846B50F.5060808@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806060948.25074.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008 01:30:23 Mike Travis wrote:
> Rusty Russell wrote:
> > On Friday 30 May 2008 15:20:45 Christoph Lameter wrote:
> >> On Fri, 30 May 2008, Eric Dumazet wrote:
> >>>> +static DEFINE_PER_CPU(UNIT_TYPE, area[UNITS]);
> >>>
> >>> area[] is not guaranteed to be aligned on anything but 4 bytes.
> >>>
> >>> If someone then needs to call cpu_alloc(8, GFP_KERNEL, 8), it might get
> >>> an non aligned result.
> >>>
> >>> Either you should add an __attribute__((__aligned__(PAGE_SIZE))),
> >>> or take into account the real address of area[] in cpu_alloc() to avoid
> >>> waste of up to PAGE_SIZE bytes
> >>> per cpu.
> >>
> >> I think cacheline aligning should be sufficient. People should not
> >> allocate large page aligned objects here.
> >
> > I vaguely recall there were issues with this in the module code.  They
> > might be gone now, but failing to meet alignment contraints without a big
> > warning would suck.
> >
> > But modifying your code to consider the actual alignment is actually
> > pretty trivial, AFAICT.
> >
> > Cheers,
> > Rusty.
>
> So paraphrasing my earlier email, we should add:
>
> 	bitmap_find_free_area(bitmap, nbits, size, align, alignbase)
>
> so that > cacheline alignment is possible?
>
> My thinking is that if we do go to true dynamically sized cpu_alloc area
> then allocating PAGE_SIZE units may be both practical and worthwhile...?
>
> Thanks,
> Mike

Well, my thinking is that unless we do true dynamic per-cpu, this entire patch 
series is a non-starter :(

Once we have that, we can reopen this.  Then we'll discuss why we're writing a 
new allocator rather than using the existing one :)

Cheers,
Rusty.
