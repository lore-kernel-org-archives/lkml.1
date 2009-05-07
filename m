Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbZEGRVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbZEGRVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761027AbZEGRVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:21:12 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:36356 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759215AbZEGRVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:21:10 -0400
X-BigFish: VPS-26(z3b68lz1432R98dR14ffO1805Mzz1202hzzz2fh6bh43j)
X-FB-SS: 5,
Message-ID: <4A03181D.50900@am.sony.com>
Date: Thu, 7 May 2009 10:19:25 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to use a different sched_clock() for ftrace on omap?
References: <cyZbZ-7Eg-9@gated-at.bofh.it> <8763gdt37p.fsf@deeprootsystems.com>
In-Reply-To: <8763gdt37p.fsf@deeprootsystems.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2009 17:19:25.0863 (UTC) FILETIME=[F8A73B70:01C9CF37]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hilman wrote:
> Tim Bird <tim.bird@am.sony.com> writes:
> 
>> Hi all,
>>
>> I've worked up a replacement sched_clock for ftrace on my omap platform.
>> The current sched_clock, based on the 32K timer, has low resolution and
>> doesn't provide very useful results.
>>
>> Unfortunately, I'm not sure the best way to use my special one, in place
>> of a common one in arch/arm/plat-omap/common.c
> 
> Hi Tim,
> 
> If you're comiling mach-omap1/time.c than you've enabled the
> higher-resolution MPU timer with CONFIG_OMAP_MPU_TIMER, right?

Yes.

> In that case, you could make the one in plat-omap/common.c inside and
> #ifndef CONFIG_OMAP_MPU_TIMER and put the new one in the MPU_TIMER
> code.
> 
> To be complete, you should add the same to the mach-omap2/timer-gp.c
> as well.

I was trying to avoid using #ifdefs, but maybe in this case it
makes sense.  There are tradeoffs in using the different timers
(nicely described in plat-omap/Kconfig help entries), so IMHO it
would be good to make this a config preference.

I'll work up a patch in this style and send it along.
 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

