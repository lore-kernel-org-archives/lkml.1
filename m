Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYH1RWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYH1RWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYH1RWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:22:08 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:39353 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYH1RWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:22:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MmDHIa6MvhZkxAeLTNDvpvjttfBXs2q5Xde0iOOu9k7CAbss+kFSiioBPN36V9YRRM
         AlA2ccKJS+3cxJ6kl8HPvXIKxK0z3Hn7S7oWLkCCcT6MxcYJgpjLIXdm43T2rPDBkyQL
         6fUBiPZtu1FyQff9E6nS54n1Nbpq0nWpI23yM=
Message-ID: <520f0cf10808281022l33ee09d1i8785764ebceb3622@mail.gmail.com>
Date: Thu, 28 Aug 2008 19:22:04 +0200
From: "John Kacur" <jkacur@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Stefani Seibold" <stefani@seibold.net>,
       "Dario Faggioli" <raistlin@linux.it>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Max Krasnyansky" <maxk@qualcomm.com>
In-Reply-To: <48B6D353.6040001@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080819103301.787700742@chello.nl>
	 <20080828141513.GC31444@goodmis.org> <20080828143042.GA12644@elte.hu>
	 <200808290036.35817.nickpiggin@yahoo.com.au>
	 <48B6D353.6040001@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 6:33 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
> Nick Piggin wrote:
>>
>> On Friday 29 August 2008 00:30, Ingo Molnar wrote:
>>>
>>> * Steven Rostedt <rostedt@goodmis.org> wrote:
>>>>
>>>> For this, if this time limit does kick in, we should at the very least
>>>> print something out to let the user know this happened. After all,
>>>> this is more of a safety net anyway, and if we are hitting the limit,
>>>> the user should be notified. Perhaps even tell the user that if this
>>>> behaviour is expected, to up the sysctl <var> by more.
>>>
>>> yeah, agreed, this is a reasonable suggestion. Peter, do you agree?
>>
>> Seems reasonable. But I still think it should be disabled by default
>> (it might not get caught in testing for example).
>
> I cannot believe you guys are still arguing about this and calling each
> other stupid/incompetent/braindead and such (not this particular email but
> all the stuff before) :)
>
> Seems to me like leaving RT throttling disabled by default is a reasonable
> compromise. Several people suggested that and the advantage is that it does
> not change the definition of SCHED_FIFO/RR by default.
>
> I personally do not care that much what the default is. If Fedora, for
> example, starts enabling it by default I'll still have to change it. So it's
> not much different from enabled by default in the kernel.
>
> Max
>

I'm rather surprised at this whole conversation. I think it is pretty
simple that.
1. The kernel should not set policy but provide capabilities.
a.) It would be more appropriate for a distro to set the policy -. but
even here, the default policy should match the expectation of what
SCHED_FIFO is and standards such as POSIX unless there is a really
really good reason to show why the standard is wrong. (and I haven't
heard it here)
b.) The fact that it is possible to change the settings is an
excellent feature, but that cannot be used as an argument to change
the default settings to something unexpected. Rather, the feature can
be used to change what the standard default is.

2. SCHED_FIFO doesn't have limitations to it, even if the application
programmer can abuse it. That to me seems to be the whole purpose of
SCHED_FIFO - it does let you do things if you have the proper
privileges that a standard kernel protects against, but if the kernel
sets a limitation on it, then it simply isn't SCHED_FIFO anymore, it's
something else. I really dislike this talk about what a good
application programmer should do anyway, I like that we can be
surprised at human creativity and how things can be used in unexpected
ways, so I don't see why that should be throttled. And this argument
about false kernel lock-ups seems bogus to me too.

John
