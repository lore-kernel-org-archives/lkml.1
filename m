Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbZJNTYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbZJNTYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbZJNTYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:24:42 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:58892 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZJNTYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ME8WivPCdzk9W7UdVWAJ9tws3BAmjNXy71npLgpmUjwXEKMGpP+EMDrwQjgXKa1ndT
         5dgmYALR8giBTrKVANpHcw4RMkOukRj7m6n5K9Qb581JZfZxQHFveb0CjrJKatI5E+NU
         z3YQ/ytaYDn4fzA8xjH/5LsKZcM7zj294OkHQ=
MIME-Version: 1.0
In-Reply-To: <4AD6235B.8090905@s5r6.in-berlin.de>
References: <f22d86810910132336r1d6f6363qa983b355676dc413@mail.gmail.com>
	 <f22d86810910140221q7e03e693kad122a37461cea1d@mail.gmail.com>
	 <20091014101336.GA25108@redhat.com>
	 <f22d86810910140324l7b78ed57v7e7c774d5f8a1bd3@mail.gmail.com>
	 <4AD60CD1.4000804@s5r6.in-berlin.de>
	 <f22d86810910141211u1f83f57fibfaa5ee19a39813f@mail.gmail.com>
	 <4AD6235B.8090905@s5r6.in-berlin.de>
Date: Thu, 15 Oct 2009 00:54:03 +0530
Message-ID: <f22d86810910141224i5f5d7725l9aa2b2262dc30ba4@mail.gmail.com>
Subject: Re: How to check whether executing in atomic context?
From: "Leonidas ." <leonidas137@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Gleb Natapov <gleb@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 12:45 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Leonidas . wrote:
>> On Wed, Oct 14, 2009 at 11:09 PM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
>>> let the caller of your routine tell it whether it's atomic context
>>> or not.
> [...]
>> What makes it more complicated is this, the user might achieve the
>> functionality via instrumenting his source code, i.e. something like
>> using -finstrument flag of gcc. As per above inferences about
>> in_atomic(), in case of instrumentation there is no choice other than
>> providing all apis as atomic apis, this might not be the right thing
>> to do under all circumstances. Especially, for my code since I do lot
>> of allocations for book keeping.
>>
>> I am not aware of any Linux kernel module which can comply to this
>> kind of use case, what would be the most optimal thing to do here?
>
> And preallocation is not feasible either?
> --
> Stefan Richter
> -=====-==--= =-=- -===-
> http://arcgraph.de/sr/
>

Yes, I preallocate a buffer at module init time. But assume that, I am
profiling kmalloc(),
and number of kmallocs() done over time increases rapidly, I need to allocate
on demand as well depending on the load. (Actually, I am not profiling kmalloc,
it just makes a good example in this case). Currently, I preallocate a
large buffer
and as I reach the threshold, I try to grab small buffers as needed.
Obvious solution
here would be to grab a larger buffer, the only issue here would be it
might be just wasteful.

So, knowing the running context and allocating sounded like a better idea to me.

-Leo.
