Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbXGJBle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbXGJBle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbXGJBl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 21:41:27 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:35830 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751917AbXGJBl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 21:41:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=bRXVAY8Tj43B5UAlYudHoEacI1gpZlSeZ3LJfRE9WVkm1j9vGx/EMijgIWjd8lqa8JtqOaIyawh1DrXodwjSil0whV7BcKuUqv/AchmJh9Q7epC/PxVtBblj2MQ5h+Q844KAw58U6CWNn3rZymOQNvWSSDjceqqwA5WpQqsWXjg=  ;
X-YMail-OSG: Kqh5MZ0VM1mzpzO_SaTuga1z.5Bz7IiV5ab8Mmgl.4JZMd4SgU5zwN3kEkb22QKJ4DQNOfbjyQ--
Message-ID: <4692E3BF.9010305@yahoo.com.au>
Date: Tue, 10 Jul 2007 11:41:19 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org> <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 9 Jul 2007, Nick Piggin wrote:
> 
> 
>>>A reason for retaining slob would be that it has some O(n) memory saving
>>>due to better packing, etc.  Indeed that was the reason for merging it in
>>>the first place.  If slob no longer retains that advantage (wrt slub) then
>>>we no longer need it.
>>
>>SLOB contains several significant O(1) and also O(n) memory savings that
>>are so far impossible-by-design for SLUB. They are: slab external
>>fragmentation is significantly reduced; kmalloc internal fragmentation is
>>significantly reduced; order of magnitude smaller kmem_cache data type;
>>order of magnitude less code...
> 
> 
> Well that is only true for kmalloc objects < PAGE_SIZE and to some extend 
> offset by the need to keep per object data in SLUB. But yes the power of 
> two caches are a necessary design feature of SLAB/SLUB that allows O(1) 
> operations of kmalloc slabs which in turns causes memory wastage because 
> of rounding of the alloc to the next power of two. SLUB has less wastage
> there than SLAB since it can fit power of two object tightly into a slab 
> instead of having to place additional control information there like SLAB.

OK but we're talking about SLOB. And the number that matters is the amount
of memory used, which is higher with SLUB than with SLOB in our tests.


> O(n) memory savings? What is that?

Allocate n things and your memory waste is proportional to n (well that's
O(n) waste, so I guess by savings I mean that SLOB's memory saving compared
to SLUB are proportional to n).

-- 
SUSE Labs, Novell Inc.
