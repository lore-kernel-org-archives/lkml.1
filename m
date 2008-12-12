Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbYLLRqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbYLLRqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbYLLRqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:46:42 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:34670 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133AbYLLRql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:46:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=fq9GKxTfYxBvZ4NceBTMa6TsapdSfMVvhuy7xlAp6PYJvYrPlsKKmjot8gvT67774a
         Hy7O3142nRPq/mxyiH0ixzUoTbPiSiUhfc8HKAgIZMcDRRIIJ7y/34WJJoUdGqSio7IU
         la1nRTZBaxzPoBpxurF9FektcgjZh2IyjGdnc=
Message-ID: <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>
Date: Fri, 12 Dec 2008 18:42:22 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [patch] Performance Counters for Linux, v3
Cc: "Vince Weaver" <vince@deater.net>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>, "Paul Mackerras" <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1229073834.12883.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
	 <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
	 <1229073834.12883.41.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Fri, Dec 12, 2008 at 10:23 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> For instance, people have pointed out that your design necessarily implies
>> pulling into the kernel the event table for all PMU models out there. This
>> is not just data, this is also complex algorithms to assign events to counters.
>> The constraints between events can be very tricky to solve. If you get this
>> wrong, this leads to silent errors, and that is really bad.
>
> (well, its not my design - I'm just trying to see how far we can push it
> out of sheer curiosity)
>
> This has to be done anyway, and getting it wrong in userspace is just as
> bad no?
>
No as bad. If a library is bad, then just don't the library. In fact,
I know tools
which do not even need a library. What is important is that there is a way
to avoid the problem. If the kernel controls this, then there is no way out.

To remain in your world, look at the Pentium 4 (Netburst) PMU
description. And you'll see that things are very complicated already there.


> The _ONLY_ technical argument I've seen to do this in userspace is that
> these tables and text segments are unswappable in-kernel - which doesn't
> count too heavily in my book.
>
>> Looking at Intel Core, Nehalem, or AMD64 does not reflect the reality of
>> the complexity of this. Paul pointed out earlier the complexity on Power.
>> I can relate to the complexity on Itanium (I implemented all the code in
>> the user level libpfm for them).  Read the Itanium PMU description and I
>> hope you'll understand.
>
> Again, I appreciate the fact that multi-dimensional constraint solving
> isn't easy. But any which way we turn this thing, it still needs to be
> done.
>

Yes, but you have lots of ways of doing this at the user level. For all I know,
you could even hardcode the values (register, value) pairs in your tool if you
know what you are doing. And don't discount the fact that advanced tools
know what they are doing very precisely.

>> Events constraints are not going away anytime soon, quite the contrary.
>>
>> Furthermore, event tables are not always correct. In fact, they are
>> always bogus.
>> Event semantics varies between steppings. New events shows up, others
>> get removed.
>> Constraints are discovered later on.
>>
>> If you have all of that in the kernel, it means you'll have to
>> generate a kernel patch each
>> time. Even if that can be encapsulated into a kernel module, you will
>> still have problems.
>
> How is updating a kernel module (esp one that only contains constraint
> tables) more difficult than upgrading a user-space library? That just
> doesn't make sense.
>
Go ask end-users what they think of that?

You don't even need a library. All of this could be integrated into the tool.
New processor, just go download the updated version of the tool.
No kernel changes.

>> Furthermore, Linux commercial distribution release cycles do not
>> align well with new processor
>> releases. I can boot my RHEL5 kernel on a Nehalem system and it would
>> be  nice not to have to
>> wait for a new kernel update to get the full Nehalem PMU event table,
>> so I can program more than
>> the basic 6 architected events of Intel X86.
>
> Talking with my community hat on, that is an artificial problem created
> by distributions, tell them to fix it.
>
> All it requires is a new kernel module that describes the new chip,
> surely that can be shipped as easily as a new library.
>

No, because you need tons of versions of that module based on kernel
versions. People do not recompile kernel modules.

>> I know the argument about the fact that you'll have a patch with 24h
>> on kernel.org. The problem
>> is that no end-user runs a kernel.org kernel, nobody. Changing the
>> kernel is not an option for
>> many end-users, it may even require re-certifications for many customers.
>>
>> I believe many people would like to see how you plan on addressing those issues.
>
> You're talking to LKML here - we don't care about stuff older than -git
> (well, only a little, but not much more beyond n-1).
>
That is why you don't always understand the issues of users, unfortunately.

> What we do care about is technical arguments, and last time I checked,
> hardware resource scheduling was an OS level job.
>
Yes, if you get it wrong, applications are screwed.

> But if the PMU control is critical to the enterprise deployment of
> $customer, then he would have to re-certify on the library update too.
>
No, they just download a new version of the tool.

> If its only development phase stuff, then the deployment machines won't
> even load the module so there'd be no problem anyway.
>
This not just development stuff anymore.
