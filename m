Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYDIGEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYDIGEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 02:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYDIGE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 02:04:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45199 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbYDIGE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 02:04:27 -0400
Date: Wed, 9 Apr 2008 08:08:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: bootmem allocator
Message-ID: <20080409060854.GB19010@one.firstfloor.org>
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu> <87iqytqwl7.fsf@basil.nowhere.org> <20080408080446.GA12308@elte.hu> <47FC5B7C.3020504@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FC5B7C.3020504@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 11:00:28PM -0700, Mike Travis wrote:
> Ingo Molnar wrote:
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> >>> hm, bootmem allocator is supposed to clear memory. We have a couple 
> >>> of places that rely on that.
> >> I was actually considering to change that for the GB pages hugetlbfs 
> >> patchkit, because memset for 1G is a little slow and not needed (will 
> >> be cleared later anyways) and it might be a problem for very large 
> >> systems with a lot of such pages at boot.
> > 
> > changing the default behavior of bootmem alloc to be non-clearing is a 
> > really bad idea that will only cause unrobustness. The proper approach 
> > is to add an _opt-in_ API that does not clear memory 
> > (bootmem_alloc_dontclear() or whatever), available to callers that know 
> > it for sure that they dont need the clearing.
> 
> Yes, changing the default of bootmem_alloc is a bad idea.  I just changed
> a bunch of static arrays to bootmem alloc's and it was pointed out early
> that not only does bootmem_alloc clear memory, but also panics if it's not
> available.

There are more and more bootmem calls that don't want the panic actually.
That is why _nopanic was invented (and gets more and more variants)
At some point the default could be even switched.

I think the right way would be to survey the callers (there are not
that many) and then come up with a sane single API that caters to the
majority of them by default and passes flags for the special cases.

-Andi
