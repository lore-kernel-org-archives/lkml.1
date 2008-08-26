Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYHZXAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYHZXAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 19:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYHZXAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 19:00:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33157 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYHZXAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 19:00:24 -0400
Date: Tue, 26 Aug 2008 19:00:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Hounschell <markh@compro.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080826230021.GB31444@goodmis.org>
References: <20080819103301.787700742@chello.nl> <200808261900.07383.nickpiggin@yahoo.com.au> <20080826093059.GA471@elte.hu> <200808261954.47987.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808261219050.3243@apollo.tec.linutronix.de> <48B40975.7080803@compro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B40975.7080803@compro.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 09:47:33AM -0400, Mark Hounschell wrote:
> Thomas Gleixner wrote:
>> On Tue, 26 Aug 2008, Nick Piggin wrote:
>>
>>> On Tuesday 26 August 2008 19:30, Ingo Molnar wrote:
>>>> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>>>>> So... no reply to this? I'm really wondering how it's OK to break
>>>>> documented standards and previous Linux behaviour by default for
>>>>> something that it is trivial to solve in userspace? [...]
>>>> I disagree
>>> Your arguments were along the line of:
>>>
>>> * It probably doesn't break anything (except we had somebody report
>>>   that it breaks their app)
>>
>> I'm a real-time oldtimer. An application which hogs the CPU for 9.9
>> seconds with SCHED_FIFO priority is just broken. It's broken beyond
>> all limits, whether POSIX allows to do that or Linux obeyed the
>> request of the braindamaged application design.
>>
>
> Well, I've been working on RT hardware (mostly) and software since 1977.
> With all due respect, thats crapola. I for one have this requirement and
> there is _no_ way around it in my world. In fact it's the kernel thats broke
> by stealing precious usecs from me.

I'm sorry, but I need to agree with this. I've been focused more on RT
and in military apps since 1991 (not as long as 77 though :-)

There's two issues here.

1) What FIFO means

2) Protecting the 99% of the users


What most real RT centric folks will want is the true meaning of FIFO.
That is, a FIFO task can run as long as it wants using as much CPU as it
wants until a) a higher RT task preempts it, or b) it voluntarily
releases the CPU.

This change, without doubt, breaks the definition of what a FIFO task
is. This is the kernel imposing policy onto userspace.

What Thomas Gleixner and Ingo Molnar are doing, is focusing on 2 above.
(protecting the 99% of users).  This is reasonable, since thats who will
bug them the most when things break.

The problem I have, is that this is breaking a defined user API. A
default that is well known within the RT community. The simple
definition of FIFO.

What I would suggest is this.

1) Keep the default as the infinite for those that know what they are
   doing.

2) Change the sysctl scripts in the distros to set the default to a sane
  time that will protect the users.

An RT app that would break the 10s limit would probably be using busybox
anyway, so the default for that would be what the kernel comes up with.

The default the 99% of users would have, is what the distro set it to
for them.

This seems like a sane solution to satisfy both camps.

-- Steve

