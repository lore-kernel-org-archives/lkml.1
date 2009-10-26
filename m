Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZJZTAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZJZTAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbZJZTAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:00:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48556 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZJZTAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:00:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AE5F1D2.9030908@s5r6.in-berlin.de>
Date: Mon, 26 Oct 2009 20:00:34 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Leonidas ." <leonidas137@gmail.com>
CC: Noah Watkins <noah@noahdesu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Difference between atomic operations and memory barriers
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com>	 <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com> <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com>
In-Reply-To: <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leonidas . wrote:
> On Mon, Oct 26, 2009 at 11:49 PM, Noah Watkins <noah@noahdesu.com> wrote:
>>> Trying to understand difference between atomic ops and memory barriers.

Atomic accesses and barriers are different concepts.

The former means that there won't be intermediary values visible (to
another CPU or to a DMA capable device) at any time; there will only be
either the old value or the new value, but nothing half-done.

The latter means that an order between two (or more) separate accesses
is enforced.

You cannot use barriers to make intrinsically non-atomic accesses look
atomically; you need a lock for such a purpose.  (Or RCU.)

>>> I was thinking all atomic operations must be using barrier internally, but I read
>>> somewhere that only some of them use barriers. Sorry for being vague here.
>>> 
>>> Operations before call to smp_mb() will not be re-ordered and all cpus will see
>>> consistent value after the variable is updated.
>>> 
>>> E.g.
>>> void * ptr = (void *) str;
>>> smb_mb();
>>> 
>>> Will this not atomically update ptr? Ptr will be seen by all cpu's in same state
>>> after it has been assigned str, right?
>> 
>> There is a bit of info in:
>>    Documentation/atomic_ops.txt
>>
>> -noah
>>
>>
> 
> 
> Thanks for the pointer, there are no atomic operations for pointers, right?
> I guess barrier is what we need in that case.

There are more atomic accesses than those which deal with atomic_t.  For
example,
	any_t *ptr = something;
is definitely atomic, and we rely on this atomicity in the kernel at
many places.

I guess these things can be found somewhere in the C language specification.
-- 
Stefan Richter
-=====-==--= =-=- ==-=-
http://arcgraph.de/sr/
