Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbZEGOOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbZEGOOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbZEGOOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:14:04 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:48587 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbZEGOOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:14:01 -0400
To: Kim Kyuwon <chammoru@gmail.com>
Cc: Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	<87y6tb3x6r.fsf@deeprootsystems.com>
	<871vr22upr.fsf@deeprootsystems.com> <200905062318.23572.rjw@sisk.pl>
	<87zldpu5rt.fsf@deeprootsystems.com>
	<d6200be20905061818h58145d5fie5c55ceaf900a196@mail.gmail.com>
	<4d34a0a70905061828l3e35a954k76967b30c1a241ab@mail.gmail.com>
	<d6200be20905061844q8a4945y83daa86b336dc49a@mail.gmail.com>
	<4d34a0a70905061904w338457efna8a3cbb80537e0c9@mail.gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 07 May 2009 07:13:55 -0700
In-Reply-To: <4d34a0a70905061904w338457efna8a3cbb80537e0c9@mail.gmail.com> (Kim Kyuwon's message of "Thu\, 7 May 2009 11\:04\:06 +0900")
Message-ID: <87ws8trof0.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kim Kyuwon <chammoru@gmail.com> writes:

> 2009/5/7 Arve Hjønnevåg <arve@android.com>:
>> 2009/5/6 Kim Kyuwon <chammoru@gmail.com>:
>>> 2009/5/7 Arve Hjønnevåg <arve@android.com>:
>>>> On Wed, May 6, 2009 at 5:16 PM, Kevin Hilman
>>>> <khilman@deeprootsystems.com> wrote:
>>>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>>>>
>>>>>> On Wednesday 06 May 2009, Kevin Hilman wrote:
>>>>>>> Kevin Hilman <khilman@deeprootsystems.com> writes:
>>>>
>>>>> There is at least one problem with that which is why Kyuwon Kim added
>>>>> the ->disable hook to OMAP's irq_chip.  The problem is with drivers
>>>>> that call disable_irq() in their suspend hook, usually done to prevent
>>>>> the device from waking the system since on OMAP, any IRQ can be
>>>>> configured to wake the system.
>>>>>
>>>>
>>>> This does not sound correct. disable_irq_wake should be used for this.
>>>> A driver may need to mask its interrupt before suspending but this
>>>> should not also disable it as a wakeup source.
>>>
>>> I wish I could use disable_irq_wake(), but it doesn't work in OMAP.
>>
>> This does not sound like a hardware problem.
>
> We may need advices of TI engineers.
> However, as far as I know, It is impossible to disable 'interrupt
> wake-up' with interrupt enabled. Because an interrupt itself generate
> a system wake-up event in OMAP3430 (Hardware level).

Interrupt wakeups can be disabled at the PRCM level.  Or more simply
we can keep a mask of wakeup-enable interrupts and use that.

I will experiment with getting disable_irq_wake() working.

Kevin

