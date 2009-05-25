Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZEYHDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZEYHDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZEYHC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:02:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51922 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbZEYHC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:02:57 -0400
Date: Mon, 25 May 2009 16:02:47 +0900
From: Kim Kyuwon <q1.kim@samsung.com>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
In-reply-to: <200905232214.57186.rjw@sisk.pl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kim Kyuwon <chammoru@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Kyungmin Park <kyungmin.park@samsung.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>
Message-id: <4A1A4297.50809@samsung.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
 <200905230029.18279.rjw@sisk.pl>
 <4d34a0a70905221603g785f5b78h330249ff258dbfdd@mail.gmail.com>
 <200905232214.57186.rjw@sisk.pl>
X-OriginalArrivalTime: 25 May 2009 07:02:48.0237 (UTC)
 FILETIME=[CFC905D0:01C9DD06]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday 23 May 2009, Kim Kyuwon wrote:
>> On Sat, May 23, 2009 at 7:29 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> On Saturday 23 May 2009, Kim Kyuwon wrote:
> [--snip--]
>>>> You changed the really important part of Linux, which may affect most
>>>> processor architectures. I think you should be careful. If some of
>>>> architectures can't take care of it (they can implement
>>>> disable_irq_wake correctly in H/W level, will you revert your changes?
>>> No, the changes are not going to be reverted.  In fact things should have been
>>> done like this already much earlier.
>>>
>>> Now, do you have any particular example of a problem related to these changes
>>> or is it only a theoretical issue?
>> I'd CCing you when I'm sending a mail for this particular example of a example.
>> http://markmail.org/thread/fvt7d62arofon5xx
> 
> Well, as I said above, reverting the changes that introduced
> [suspend|resume]_device_irqs() is not an option, becuase it was the only sane
> way to achieve the goal they were added for.  So, we need to fix the wake-up
> problem on your platform with the assumption that
> [suspend|resume]_device_irqs() are going to stay.
> 
> For starters, would it be possible to teach the 'disable' hook of your
> platform's interrupt controller not to mask the IRQs that have both
> IRQ_WAKEUP and IRQ_SUSPENDED set?  That apparently would work around the
> wake-up interrupts problem.

Thank you for considering this issue and spending your time. In order to 
make your idea work, we need to add a dummy 'set_wake' hook which 
returns always zero. Anyway, IMO, I think your idea is good to work 
around this problem. But Kevin Hilman(OMAP PM Maintainer) would make 
final decision.

Buy the way, how can you handle the problem that a few interrupt are 
discarded in a small window? I can be sure they are discarded, because I 
have debugged defects which generate in sleep/resume state hundreds of 
times on ARM Processors(PXA310, S3C6410, OMAP3430). Wake-up interrupts 
are generated as soon as arch_suspend_enable_irqs() invoked.

Regards,
Kyuwon
