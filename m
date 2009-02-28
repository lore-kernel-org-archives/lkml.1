Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZB1DyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZB1DyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 22:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZB1DyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 22:54:12 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:14328 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbZB1DyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 22:54:10 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0902271221360.3111@localhost.localdomain>
References: <Pine.LNX.4.44L0.0902270948540.2926-100000@iolanthe.rowland.org>
	 <alpine.LFD.2.00.0902271221360.3111@localhost.localdomain>
Date: Fri, 27 Feb 2009 19:54:08 -0800
Message-ID: <d6200be20902271954q16697282ia056d4f40ab49184@mail.gmail.com>
Subject: Re: [linux-pm] [RFC][PATCH 2/2] PM: Rework handling of interrupts 
	during suspend-resume
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 12:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 27 Feb 2009, Alan Stern wrote:
>>
>> Perhaps these aren't all the sort of usage you're talking about, but I
>> bet most of them are.  It certainly looks like more than just ARM.
>> Maybe not all that much more, but definitely more.  And the number will
>> only grow in the future.
>
> Are you really sure? Because it can't be x86. I'm pretty sure that that is
> simply not how x86 wake events _work_ - they're not interrupts.

They are not interrupts on every arm platform that implements set_wake
either, but it is useful to pretend that they are. If the platform
code reads the wakeup status and marks the corresponding interrupt
pending, the driver does not need to know if the event occurred before
or after the system entered the low power state. I don't know if this
can be implemented on x86, but it might be worth looking into.

>
> And that's the big point that people seem to be missing here: the whole
> "wake up interrupt" thing is not some generic model in the first place. I
> strongly suspect that it literally only works on certain architectures.

My point was that it was not specific to our platform. I don't have a
problem fixing our platform if this patch is merged, but this is case
where a change to the generic code breaks some platforms. I don't
think there is a good reason to make the fix arm specific, trivial or
not, since any platform implementing set_wake may run into the race
condition that this patch introduced. If the platform does not
implement set_wake, IRQ_WAKEUP never gets set, and the fix should not
have any effect.

-- 
Arve Hjønnevåg
