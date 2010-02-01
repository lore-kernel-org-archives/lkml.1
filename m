Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0BAGGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 01:06:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:43765 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab0BAGGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 01:06:18 -0500
Message-ID: <4B666F41.9080302@windriver.com>
Date: Mon, 01 Feb 2010 00:05:53 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dongdong Deng <libfetion@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       "Deng, Dongdong" <Dongdong.Deng@windriver.com>, peterz@infradead.org
Subject: Re: [PATCH 1/3] softlockup: add sched_clock_tick() to avoid kernel
 warning on kgdb resume
References: <1264631124-4837-1-git-send-email-jason.wessel@windriver.com> <1264631124-4837-2-git-send-email-jason.wessel@windriver.com> <20100129080706.GJ14636@elte.hu> <4B62F5F6.3040401@windriver.com> <ce2c83091001312153u280c0035j9ef53fb3e8d9068d@mail.gmail.com>
In-Reply-To: <ce2c83091001312153u280c0035j9ef53fb3e8d9068d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2010 06:05:39.0916 (UTC) FILETIME=[9471C0C0:01CAA304]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongdong Deng wrote:
> On Fri, Jan 29, 2010 at 10:51 PM, Jason Wessel
> <jason.wessel@windriver.com> wrote:
>   
>> echo 3 > /proc/sys/kernel/softlockup_thresh
>>
>> And then some kernel code in a thread like:
>>        local_irq_disable();
>>        printk("Disable local irq for 11 seconds\n");
>>        mdelay(11000);
>>        local_irq_enable();
>>     
>
> Hi Jason,
>
> Maybe this problem was fixed by
> commit baf48f6577e581a9adb8fe849dc80e24b21d171d - "softlock: fix false
> panic which can occur if softlockup_thresh is reduced".
>   


That is not the same problem.   The fix you referenced is a corner case
where you end up with the stack trace at the point in time you reduce
the threshold.  The only reason I reduce the threshold in the first
place is just to shorten the amount of time it takes to observe the problem.

You can just change the numbers for the mdelay and use the default
softlockup threshold values and still see the problem I reported.

Jason.
