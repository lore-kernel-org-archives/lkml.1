Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0BIGyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 01:54:45 -0500
Received: from mail-qy0-f200.google.com ([209.85.221.200]:57300 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab0BIGyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 01:54:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dxY94WnbFdZTMTXqEsf+T+M6G9DEyJgvDK5Hazunc90kdV+OC6Ddcc4yk17tGS60kP
         ltPlpd8N9WlaMMQfYLML4mmM+uauq7++LE4eNIl3bnNjjqFDO4TYeWagYuux6G+lpZMU
         A3GxLrjg/o7zypOOm+c9p0MOp5cheun7zhv6A=
MIME-Version: 1.0
In-Reply-To: <20100209041739.GA11280@elte.hu>
References: <20100208184504.GB5130@lenovo> <20100209041739.GA11280@elte.hu>
Date: Tue, 9 Feb 2010 09:54:43 +0300
Message-ID: <aa79d98a1002082254v58f2fc0jd157469b13ee9a94@mail.gmail.com>
Subject: Re: [RFC perf,x86] P4 PMU early draft
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/10, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> Hi all,
>>
>> first of all the patches are NOT for any kind of inclusion. It's not ready
>>
>> yet. More likely I'm asking for glance review, ideas, criticism.
>
> A quick question: does the code produce something on a real P4? (possibly
> only running with a single event - but even that would be enough.)

not yet, a few code snippets need to be added into scheduling routine,
hope to finish this today evening

>
>> The main problem in implementing P4 PMU is that it has much more
>> restrictions for event to MSR mapping. [...]
>
> One possibly simpler approach might be to represent the P4 PMU via a maximum
> _two_ generic events only.
>

yeah, good idea!

> Last i looked at the many P4 events, i've noticed that generally you can
> create any two events. (with a few exceptions) Once you start trying to take
> advantage of the more than a dozen seemingly separate counters, additional
> non-trivial constraints apply.
>
> So if we only allowed a maximum of _two_ generic events (like say a simple
> Core2 has, so it's not a big restriction at all), we wouldnt have to map all
> the constraints, we'd only have to encode the specific event-to-MSR details.
> (which alone is quite a bit of work as well.)
>
> We could also use the new constraints code to map them all, of course - it
> will certainly be more complex to implement.
>

i thought about it, but i didn't like the result code ;) will think about it.

> Hm?
>
> 	Ingo
>
