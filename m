Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbZJZTIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbZJZTIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZJZTIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:08:09 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:35154 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbZJZTFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:05:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H0CcjN1rU9AvP+lNJJb5TeI22UlAYU1LzEpoNNVPWKCIPjXRySTlCCLneDpDhGB+re
         MRDzC1vbzpEg/h7yXMFXGxn6vC2jIRCBncz77thcxFDpM5HmkT9m3PlJ+xrYI8au9CQc
         j7CFiSsWBCPn72bqCikIEQCf8k0rKi/cenEoc=
MIME-Version: 1.0
In-Reply-To: <4AE5F1D2.9030908@s5r6.in-berlin.de>
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com>
	 <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com>
	 <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com>
	 <4AE5F1D2.9030908@s5r6.in-berlin.de>
Date: Tue, 27 Oct 2009 00:35:18 +0530
Message-ID: <f22d86810910261205r232db5d4re97a54827c7adab3@mail.gmail.com>
Subject: Re: Difference between atomic operations and memory barriers
From: "Leonidas ." <leonidas137@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Noah Watkins <noah@noahdesu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 12:30 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Leonidas . wrote:
>> On Mon, Oct 26, 2009 at 11:49 PM, Noah Watkins <noah@noahdesu.com> wrote:
>>>> Trying to understand difference between atomic ops and memory barriers.
>
> Atomic accesses and barriers are different concepts.
>
> The former means that there won't be intermediary values visible (to
> another CPU or to a DMA capable device) at any time; there will only be
> either the old value or the new value, but nothing half-done.
>
> The latter means that an order between two (or more) separate accesses
> is enforced.
>
> You cannot use barriers to make intrinsically non-atomic accesses look
> atomically; you need a lock for such a purpose.  (Or RCU.)
>
>>>> I was thinking all atomic operations must be using barrier internally, but I read
>>>> somewhere that only some of them use barriers. Sorry for being vague here.
>>>>
>>>> Operations before call to smp_mb() will not be re-ordered and all cpus will see
>>>> consistent value after the variable is updated.
>>>>
>>>> E.g.
>>>> void * ptr = (void *) str;
>>>> smb_mb();
>>>>
>>>> Will this not atomically update ptr? Ptr will be seen by all cpu's in same state
>>>> after it has been assigned str, right?
>>>
>>> There is a bit of info in:
>>>    Documentation/atomic_ops.txt
>>>
>>> -noah
>>>
>>>
>>
>>
>> Thanks for the pointer, there are no atomic operations for pointers, right?
>> I guess barrier is what we need in that case.
>
> There are more atomic accesses than those which deal with atomic_t.  For
> example,
>        any_t *ptr = something;
> is definitely atomic, and we rely on this atomicity in the kernel at
> many places.
>
> I guess these things can be found somewhere in the C language specification.
> --
> Stefan Richter
> -=====-==--= =-=- ==-=-
> http://arcgraph.de/sr/
>

If your answer matches my inference that,

any_t *ptr = something;

is always atomic even on SMPs without using locks, barriers then my
doubt is cleared. Thanks.

-Leo.
