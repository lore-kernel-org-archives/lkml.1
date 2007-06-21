Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbXFUXIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbXFUXIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbXFUXIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:08:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbXFUXIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:08:43 -0400
Date: Thu, 21 Jun 2007 16:08:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
cc: Jens Axboe <jens.axboe@oracle.com>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@redhat.com,
       tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: Change in default vm_dirty_ratio
In-Reply-To: <20070621225320.GP11166@waste.org>
Message-ID: <alpine.LFD.0.98.0706211605540.3593@woody.linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain>
 <20070618164711.9de1c38e.akpm@linux-foundation.org> <20070620042434.GC12096@redhat.com>
 <20070619214407.dfff0ca6.akpm@linux-foundation.org> <1182328536.21117.24.camel@twins>
 <20070620015826.03f1d71a.akpm@linux-foundation.org> <20070620091404.GO18863@kernel.dk>
 <1182331182.21117.39.camel@twins> <20070620092058.GP18863@kernel.dk>
 <20070621225320.GP11166@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Matt Mackall wrote:
> 
> Perhaps we want to throw some sliding window algorithms at it. We can
> bound requests and total I/O and if requests get retired too slowly we
> can shrink the windows. Alternately, we can grow the window if we're
> retiring things within our desired timeframe.

I suspect that would tend to be a good way to go. But it almost certainly 
has to be per-device, which implies that somebody would have to do some 
major coding/testing on this..

The vm_dirty_ratio thing is a global value, and I think we need that 
regardless (for the independent issue of memory deadlocks etc), but if we 
*additionally* had a per-device throttle that was based on some kind of 
adaptive thing, we could probably raise the global (hard) vm_dirty_ratio a 
lot.

		Linus
