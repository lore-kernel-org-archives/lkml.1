Return-Path: <linux-kernel-owner+w=401wt.eu-S934279AbYBHH3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279AbYBHH3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 02:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbYBHH3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 02:29:37 -0500
Received: from neuf-infra-smtp-out-sp604003av.neufgp.fr ([84.96.92.124]:46522
	"EHLO neuf-infra-smtp-out-sp604003av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758047AbYBHH3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 02:29:36 -0500
Message-ID: <47AC04CD.9090407@cosmosbay.com>
Date: Fri, 08 Feb 2008 08:29:17 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [git pull] more SLUB updates for 2.6.25
References: <Pine.LNX.4.64.0802071755580.7473@schroedinger.engr.sgi.com> <200802081812.22513.nickpiggin@yahoo.com.au>
In-Reply-To: <200802081812.22513.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin a écrit :
> On Friday 08 February 2008 13:13, Christoph Lameter wrote:
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/christoph/vm.git slub-linus
>>
>> (includes the cmpxchg_local fastpath since the cmpxchg_local work
>> by Matheiu is in now, and the non atomic unlock by Nick. Verified that
>> this is not doing any harm after some other patches had been removed.
> 
> Ah, good. I think it is always a good thing to be able to remove atomics.
> They place quite a bit of burden on the CPU, especially x86 where it also
> has implicit memory ordering semantics (although x86 can speculatively
> get around much of the problem, it's obviously worse than no restriction)
> 
> Even if perhaps some cache coherency or timing quirk makes the non-atomic
> version slower (all else being equal), then I'd still say that the non
> atomic version should be preferred.
> 

What about IRQ masking then ?

Many CPU pay high cost for cli/sti pair...

And SLAB/SLUB allocators, even if only used from process context, want to 
disable/re-enable interrupts...

I understand kmalloc() want generic pools, but dedicated pools could avoid 
this cli/sti

