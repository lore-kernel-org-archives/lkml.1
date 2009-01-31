Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbZAaGMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbZAaGMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 01:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZAaGMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 01:12:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:32871 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbZAaGMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 01:12:00 -0500
Message-ID: <4983EB82.7060508@kernel.org>
Date: Sat, 31 Jan 2009 15:11:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Herbert Xu <herbert@gondor.apana.org.au>,
       akpm@linux-foundation.org, hpa@zytor.com, brgerst@gmail.com,
       ebiederm@xmission.com, cl@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com, hugh@veritas.com,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
References: <20090115183942.GA6325@elte.hu> <200901282108.51864.rusty@rustcorp.com.au> <498039E2.7090107@kernel.org> <200901291236.48189.rusty@rustcorp.com.au>
In-Reply-To: <200901291236.48189.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 31 Jan 2009 06:11:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

Rusty Russell wrote:
>> Rusty Russell wrote:
>>> If the stats are only manipulated in one context, than an atomic
>>> requirement is overkill (and expensive on non-x86).
>> Yes, it is.  I was hoping it to be not more expensive on most archs.
>> It isn't on x86 at the very least but I don't know much about other
>> archs.
> 
> Hmm, you can garner this from the local_t stats which were flying around.
> (see Re: local_add_return from me), or look in the preamble to
> http://ozlabs.org/~rusty/kernel/rr-latest/misc:test-local_t.patch ).

Ah... Great.

> Of course, if you want to be my hero, you could implement "soft" irq
> disable for all archs, which would make this cheaper.

I suppose you mean deferred execution of interrupt handlers for quick
atomicities.  Yeah, that would be nice for things like this.

>>> Other than the shouting, I liked Christoph's system:
>>> - CPU_INC = always safe (eg. local_irq_save/per_cpu(i)++/local_irq_restore)
>>> - _CPU_INC = not safe against interrupts (eg. get_cpu/per_cpu(i)++/put_cpu)
>>> - __CPU_INC = not safe against anything (eg. per_cpu(i)++)
>>>
>>> I prefer the name 'local' to the name 'cpu', but I'm not hugely fussed.
>> I like local better too but no biggies one way or the other.
> 
> Maybe kill local_t and take the name back.  I'll leave it to you...
> 
>>> Ah, I did not realize that you celebrated Australia day :)
>> Hey, didn't know Australia was founded on lunar New Year's day.
>> Nice. :-)
> 
> That would have been cool, but no; first time in 76 years they matched tho.

It was a joke.  :-)

Thanks.

-- 
tejun
