Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbZKXLpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbZKXLpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbZKXLpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:45:32 -0500
Received: from mail.klingt.org ([86.59.21.178]:38348 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbZKXLpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:45:31 -0500
Message-ID: <4B0BC74B.2040805@klingt.org>
Date: Tue, 24 Nov 2009 12:45:15 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091121 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 3/5] slab.c: remove branch hint
References: <cover.1259059549.git.tim@klingt.org> <4B0BBBA8.2090604@klingt.org>	 <20091124112058.GA23765@elte.hu> <84144f020911240328l3d36d347o6c91b2b1a0f50f2a@mail.gmail.com>
In-Reply-To: <84144f020911240328l3d36d347o6c91b2b1a0f50f2a@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Tue, 24 Nov 2009 12:45:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/24/2009 12:28 PM, Pekka Enberg wrote:
> On Tue, Nov 24, 2009 at 1:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> (Pekka Cc:-ed)
>>
>> * Tim Blechmann <tim@klingt.org> wrote:
>>
>>> branch profiling on my nehalem machine showed 99% incorrect branch hints:
>>>
>>>    28459  7678524  99 __cache_alloc_node             slab.c
>>>   3551
>>>
>>> Signed-off-by: Tim Blechmann <tim@klingt.org>
>>> ---
>>>  mm/slab.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/mm/slab.c b/mm/slab.c
>>> index f70b326..4125fcd 100644
>>> --- a/mm/slab.c
>>> +++ b/mm/slab.c
>>> @@ -3548,7 +3548,7 @@ __cache_alloc_node(struct kmem_cache *cachep,
>>> gfp_t flags, int nodeid,
>>>       slab_irq_save(save_flags, this_cpu);
>>>       this_node = cpu_to_node(this_cpu);
>>> -     if (unlikely(nodeid == -1))
>>> +     if (nodeid == -1)
>>>               nodeid = this_node;
>>>       if (unlikely(!cachep->nodelists[nodeid])) {
> 
> That sounds odd to me. Can you see where the incorrectly predicted
> calls are coming from? Calling kmem_cache_alloc_node() with node set
> to -1 most of the time could be a real bug somewhere.

i don't know, if there is any facility in the ftrace branch profiler to
get call graph information, but i can try to manually dump backtraces in
this condition path ...
could be a specific situation on my machine, though ...

tim

- -- 
tim@klingt.org
http://tim.klingt.org

You don't have to call it music if the term shocks you.
  John Cage
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksLx0kACgkQdL+4qsZfVsskOQCglFQG3eYAfdgXoOAHAGTqaLcU
8e0AoIQNbzSRxttGFaXTF3PEh5O4aGEB
=3nmT
-----END PGP SIGNATURE-----
