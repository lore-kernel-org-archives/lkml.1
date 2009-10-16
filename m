Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZJPMSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZJPMSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 08:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZJPMSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 08:18:06 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46026 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZJPMSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 08:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Mq9frXRfsCJocL0NWvtKsGhMb7Kgwv7epr4MAcftFR9ctqlafVlVFgA3IOVo/NxJfb
         3vkZ3qyJwU6eWfkHUqXE7LcyP5xJOdkorwf/62ZqT0MXWcNbT2UH5ZlRXBsSjP7GQ8dn
         1Igmw0RhtwmG69D4jnokgNIlJ2w2rHlsVIMrc=
MIME-Version: 1.0
In-Reply-To: <1255694894.3008.40.camel@pc1117.cambridge.arm.com>
References: <20091014153146.8955.19964.stgit@pc1117.cambridge.arm.com>
	 <4AD770FB.5030104@cs.helsinki.fi>
	 <1255694894.3008.40.camel@pc1117.cambridge.arm.com>
Date: Fri, 16 Oct 2009 15:17:28 +0300
X-Google-Sender-Auth: 9367b6c57e60b881
Message-ID: <84144f020910160517t5247f49dpefcd58f5058fa153@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: Do not use off-slab management with 
	SLAB_NOLEAKTRACE
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 3:08 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Thu, 2009-10-15 at 21:59 +0300, Pekka Enberg wrote:
>> Catalin Marinas wrote:
>> > With the slab allocator, if off-slab management is enabled for the
>> > kmem_caches used by kmemleak, it leads to recursive calls into
>> > kmemleak_alloc(). Off-slab management can be triggered by other config
>> > options increasing the slab size, e.g. DEBUG_PAGEALLOC.
>> >
>> > Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
>> > Cc: Christoph Lameter <cl@linux-foundation.org>
>> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>>
>> Forcing slabs to use on-slab management is pretty bad from memory
>> consumption point of view. Wouldn't it be better to annotate the
>> recursive calls somehow?
>
> The are annotated using SLAB_NOLEAKTRACE but off-slab management uses a
> general cachep and we cannot use this flag on them as we end up ignoring
> kmalloc allocations. An alternative is to use GFP_ flag rather than a
> SLAB_ one to track the recursive calls.
>
> I could also rework the way hooks were added to slab.c but currently
> they follow the same places as kmemcheck_slab_alloc and
> lockdep_trace_alloc.
>
> Anyway, the kmemleak caches only need off-slab management when
> DEBUG_PAGEALLOC is enabled but in this case the memory consumption is
> high anyway.

Oh, right, I misread the patch, sorry. Please feel free to put the
patch in kmemleak.git:

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
