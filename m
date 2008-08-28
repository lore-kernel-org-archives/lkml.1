Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYH1SKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYH1SKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbYH1SKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:10:31 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:13777 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbYH1SKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:10:30 -0400
Message-ID: <e17d46420808281110h4d4718d6ud0dd21d743923b47@mail.gmail.com>
Date: Thu, 28 Aug 2008 11:10:28 -0700
From: "Darren Hart" <darren@dvhart.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stefani Seibold" <stefani@seibold.net>,
       "Dario Faggioli" <raistlin@linux.it>,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0808281356010.6278@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080819103301.787700742@chello.nl>
	 <200808290036.35817.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com>
	 <200808290134.35093.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com>
	 <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0808281356010.6278@gandalf.stny.rr.com>
X-Google-Sender-Auth: 7b3d0ab6ef584411
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 11:04 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 28 Aug 2008, Linus Torvalds wrote:
>
>>
>>
>> On Thu, 28 Aug 2008, Steven Rostedt wrote:
>> >
>> > I've always thought that the policy settings belong in the distro, and the
>> > kernel should never enforce a policy (by setting this as default, it is
>> > enforcing a policy, even though an RT user can change it).
>>
>> The kernel has always done a certain amount of "default policy".
>>
>> What do you think things like "swappiness" etc are? Or things like
>> oevrcommit settings? They're all policies, and there is always a default
>> one. So in that sense the kernel always has - and fundamentally _must_ -
>> set some kind of policy.
>>
>> And the default policy should generally be the one that makes sense for
>> most people. Quite frankly, if it's an issue where all normal distros
>> would basically be expected to set a value, then that value should _be_
>> the default policy, and none of the normal distros should ever need to
>> worry.
>>
>> Whether this case is one such, I dunno. Quite frankly, I don't think it's
>> even _nearly_ important enough to get this kind of noise.
>
> I guess the reason that this is getting so much noise over other default
> policies, is that this default policy is changing a well known definition:
> The meaning of FIFO.
>
> By making the default policy limit the time an RT task runs, we have, in
> essence, changed a user API. Applications that expect to be able to run
> uninterrupted by SCHED_OTHER tasks, will now break.
>
> No one is arguing that this new feature is not useful. The argument is,
> should the kernel set the default policy of an old well known scheduling
> policy to something different than what is expected?
>
> Distros set SE Linux on by default, should the kernel do that too?
>
> -- Steve
>

A lot of people I have an immense amount of respect for with vastly differing
opinions.  There was mention of a user poll so I'll share my .000000002 USD
here.

I have accepted in my dealings with real-time that it is a special programming
paradigm.  The developer has much greater control and must exercise it
responsibly.  From this, I have accepted that I can bring my system to it's
knees rather easily if I'm not careful.  I agree with Nick and Max that this
default behavior should be preserved.  I like Steven's suggested of disabling
the throttling in the upstream kernel, and leaving it to the distros to
safe-gaurd the user from themselves should they choose to.  There is already
some precedent for this with the updated default kernel thread priorities and
realtime group and pam limits.conf settings in Red Hat's MRG product.  When
doing real-time application development, I use various mechanisms to ensure
debugability, and it varies based on what I'm doing and how I access the
machine.  Sometimes I need special watchdog application, sometimes I need to
boost all the kernel threads related to networking or serial consoles and the
respective login apps (ssh, agetty, etc.).  It seems reasonable to consider
this throttling as another _optional_ tool in my debugging toolkit.

--
Darren Hart
