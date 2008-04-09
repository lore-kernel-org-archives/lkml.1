Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYDIGAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYDIGAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 02:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYDIGAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 02:00:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33135 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751465AbYDIGAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 02:00:32 -0400
Message-ID: <47FC5B7C.3020504@sgi.com>
Date: Tue, 08 Apr 2008 23:00:28 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: bootmem allocator
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu> <87iqytqwl7.fsf@basil.nowhere.org> <20080408080446.GA12308@elte.hu>
In-Reply-To: <20080408080446.GA12308@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
>>> hm, bootmem allocator is supposed to clear memory. We have a couple 
>>> of places that rely on that.
>> I was actually considering to change that for the GB pages hugetlbfs 
>> patchkit, because memset for 1G is a little slow and not needed (will 
>> be cleared later anyways) and it might be a problem for very large 
>> systems with a lot of such pages at boot.
> 
> changing the default behavior of bootmem alloc to be non-clearing is a 
> really bad idea that will only cause unrobustness. The proper approach 
> is to add an _opt-in_ API that does not clear memory 
> (bootmem_alloc_dontclear() or whatever), available to callers that know 
> it for sure that they dont need the clearing.

Yes, changing the default of bootmem_alloc is a bad idea.  I just changed
a bunch of static arrays to bootmem alloc's and it was pointed out early
that not only does bootmem_alloc clear memory, but also panics if it's not
available.

> Also take into account that alloc_bootmem_low() :
> - calls panic() if not enough memory
> - already clears allocated memory
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

A specialized call to bootmem_alloc probably needs it's own API... ;-)

Thanks,
Mike
