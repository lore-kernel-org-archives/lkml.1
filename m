Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZJZTAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZJZTAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbZJZTAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:00:42 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:48330 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbZJZTAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fqHxvgxpg3FHg5Xkz5sqmJU91ndzKcoxTaLWlaUOxCKfeLwzbZt8Slj8vAeTqoPvjB
         5MiZNButkhoku9Jwzru2BqZ2yqcgbLPej0Ujj9jyFEEXcu8XLP+5hPFedLHmirlZVJCm
         vfMAVA6M8bJ6FVNBVryNJDp+wvj0u44rqkIfU=
MIME-Version: 1.0
In-Reply-To: <4AE5F04E.3050908@nortel.com>
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com>
	 <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com>
	 <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com>
	 <4AE5F04E.3050908@nortel.com>
Date: Tue, 27 Oct 2009 00:30:45 +0530
Message-ID: <f22d86810910261200n130fda06r46fdbcc808195002@mail.gmail.com>
Subject: Re: Difference between atomic operations and memory barriers
From: "Leonidas ." <leonidas137@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Noah Watkins <noah@noahdesu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 12:24 AM, Chris Friesen <cfriesen@nortel.com> wrote:
> On 10/26/2009 12:22 PM, Leonidas . wrote:
>> On Mon, Oct 26, 2009 at 11:49 PM, Noah Watkins <noah@noahdesu.com> wrote:
>>>> Trying to understand difference between atomic ops and memory barriers.
>>>>
>>> There is a bit of info in:
>>>    Documentation/atomic_ops.txt
>
>> Thanks for the pointer, there are no atomic operations for pointers, right?
>> I guess barrier is what we need in that case.
>
> You need barriers for the atomics too, at least in some cases.  From
> that document:
>
> *** WARNING: atomic_read() and atomic_set() DO NOT IMPLY BARRIERS! ***
>
>
> For simple assignments, I'm fairly sure linux assumes that writes to
> individual variables are atomic.  ie, if you're assigning to an int you
> won't get half of the assignment completed while the other half isn't.
>
> What the atomic ops buy you is the ability to do increment-and-test,
> compare-and-exchange, etc. in an atomic fashion.
>
> Barriers are needed to make sure that operations are visible on other
> cpus in the correct order, and to ensure that the compiler doesn't
> reorder the operations.
>
> If you use the normal locking mechanisms (mutexes, spinlocks, etc.) the
> barriers are implicit in the lock.
>
> Chris
>

This takes it a step further ! Thanks for the info.

But locks are expensive for simpler assignments like integer assignment thats
why there are atomic counter parts, but there is no such things for
pointers right?

So we can safely assume that pointer assignment will be done in an
atomic manner?

-Leo.
