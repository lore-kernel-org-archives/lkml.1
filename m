Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYEWOng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYEWOng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYEWOn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:43:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:51357 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYEWOn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GkMA8CTSQ521YaTi3wAyXJrgn3kGD7rs9ltCs90+cICmEKZzo7g+kRnMksbnl4YfFIdwhIh0eLeUr3MNjDuzrGac3TM6rwRBObLKMpWhBOJHbtB8rWc+ikdRrSWMO+9oMkD29kbA1CRZW0tpg+NyZIqiiSHk2POawChQ/ZycBDQ=
Message-ID: <19f34abd0805230743m36c400afy7f4e3e05252383c3@mail.gmail.com>
Date: Fri, 23 May 2008 16:43:23 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: initialization of static per-cpu variables
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>
In-Reply-To: <20080523142904.GB28257@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0805211128r29fa437fm9e9e4c3d3c196f62@mail.gmail.com>
	 <200805221820.07290.rusty@rustcorp.com.au>
	 <20080523142904.GB28257@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 4:29 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Thu, May 22, 2008 at 06:20:06PM +1000, Rusty Russell wrote:
>> On Thursday 22 May 2008 04:28:02 Vegard Nossum wrote:
>> > Hi,
>> >
>> > I encountered this comment in kernel/softirq.c:
>> >
>> > /* Some compilers disobey section attribute on statics when not
>> >    initialized -- RR */
>> > static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec) = { NULL };
>> > static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec) = { NULL };
>> >
>> > So I assume it's the combination of static and whatever section
>> > DFINE_PER_CPU puts the variable in which is the problem.
>> >
>> > However, there's a LOT of these "static DEFINE_PER_CPU" without any
>> > initializer in the rest of the code, e.g.:
>>
>> Yep, it was an old toolchain used by Sparc: DaveM found this one.  As you say,
>> it's ancient: I'm happy to queue a cleanup patch now everyone is on a modern
>> compiler.
>
> The commit says:
>
>    [PATCH] softirq.c per_cpu fix
>
>    GCC3.1 apparently gets confused about uninitialized sections
>
>
> We do still support gcc 3.2 (which is the same as 3.1 except for a C++
> ABI change) as a compiler for the kernel.

Ah, thanks for looking that up!

The question is then whether 3.1/3.2 will _ever_ do the right thing,
when you consider the number of places in the kernel that *don't*
initialize static per-cpu variables. (Or maybe: What makes this
variable so special that it breaks the kernel?)

Maybe it was fixed by accident in the kernel at some point later (e.g.
by change of the linker script) or maybe the commit message/original
reason was wrong and it was really something else?

Or maybe it is time to deprecate gcc 3.1/3.2 support?

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
