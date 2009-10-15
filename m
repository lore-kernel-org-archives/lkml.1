Return-Path: <linux-kernel-owner+w=401wt.eu-S1762466AbZJOIcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762466AbZJOIcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbZJOIcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:32:09 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:42153 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZJOIcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ppqK6EGzg0R0RH5ckeD7X3yHYlpGfl6cDYFElJnjMYdQI3URNYI5PnP7AUNA86NY4u
         +G3ZRh5/K2GAYZ3pHvgk+QIgUzSj6qxV0UYCHo2Aba0vybumVMc/2PQ6ayxNL2kpD/ww
         rfnMfxbzwQAPLDqL+SGMrK8Mc7+12e6D/UbTs=
MIME-Version: 1.0
In-Reply-To: <f22d86810910141224i5f5d7725l9aa2b2262dc30ba4@mail.gmail.com>
References: <f22d86810910132336r1d6f6363qa983b355676dc413@mail.gmail.com>
	 <f22d86810910140221q7e03e693kad122a37461cea1d@mail.gmail.com>
	 <20091014101336.GA25108@redhat.com>
	 <f22d86810910140324l7b78ed57v7e7c774d5f8a1bd3@mail.gmail.com>
	 <4AD60CD1.4000804@s5r6.in-berlin.de>
	 <f22d86810910141211u1f83f57fibfaa5ee19a39813f@mail.gmail.com>
	 <4AD6235B.8090905@s5r6.in-berlin.de>
	 <f22d86810910141224i5f5d7725l9aa2b2262dc30ba4@mail.gmail.com>
Date: Thu, 15 Oct 2009 01:31:30 -0700
Message-ID: <f22d86810910150131l303200bfq952f479b3fbff563@mail.gmail.com>
Subject: Re: How to check whether executing in atomic context?
From: "Leonidas ." <leonidas137@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Gleb Natapov <gleb@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 12:24 PM, Leonidas . <leonidas137@gmail.com> wrote:
> On Thu, Oct 15, 2009 at 12:45 AM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> Leonidas . wrote:
>>> On Wed, Oct 14, 2009 at 11:09 PM, Stefan Richter
>>> <stefanr@s5r6.in-berlin.de> wrote:
>>>> let the caller of your routine tell it whether it's atomic context
>>>> or not.
>> [...]
>>> What makes it more complicated is this, the user might achieve the
>>> functionality via instrumenting his source code, i.e. something like
>>> using -finstrument flag of gcc. As per above inferences about
>>> in_atomic(), in case of instrumentation there is no choice other than
>>> providing all apis as atomic apis, this might not be the right thing
>>> to do under all circumstances. Especially, for my code since I do lot
>>> of allocations for book keeping.
>>>
>>> I am not aware of any Linux kernel module which can comply to this
>>> kind of use case, what would be the most optimal thing to do here?
>>
>> And preallocation is not feasible either?
>> --
>> Stefan Richter
>> -=====-==--= =-=- -===-
>> http://arcgraph.de/sr/
>>
>
> Yes, I preallocate a buffer at module init time. But assume that, I am
> profiling kmalloc(),
> and number of kmallocs() done over time increases rapidly, I need to allocate
> on demand as well depending on the load. (Actually, I am not profiling kmalloc,
> it just makes a good example in this case). Currently, I preallocate a
> large buffer
> and as I reach the threshold, I try to grab small buffers as needed.
> Obvious solution
> here would be to grab a larger buffer, the only issue here would be it
> might be just wasteful.
>
> So, knowing the running context and allocating sounded like a better idea to me.
>
> -Leo.
>

>Or deferring work to a kernel thread.

You mean, have a kernel thread periodically check the memory
requirements and do allocations in
kernel thread context? So basically, insuring that all the allocations
are done outside atomic context
i.e. either preallocate or use kernel thread.

-Leo.
