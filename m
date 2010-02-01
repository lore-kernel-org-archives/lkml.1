Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0BAGlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 01:41:10 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:38406 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab0BAGlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 01:41:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B262BVMakNBznjxBNPRKbBY78aAZ7OnX/Hh87t0rWwF0/XW00CFnR10kaIOqMSLZLf
         ycIcS9wo8L2bvZBq38sbybbU9adHeIAWfpbSmq7Ao33wpWG2yAVU2Uo/nAlb1XiND+Ty
         0emsmElnvH55mmegSClbSTdtRdTTkOsoGw+Fc=
MIME-Version: 1.0
In-Reply-To: <4B666F41.9080302@windriver.com>
References: <1264631124-4837-1-git-send-email-jason.wessel@windriver.com>
	 <1264631124-4837-2-git-send-email-jason.wessel@windriver.com>
	 <20100129080706.GJ14636@elte.hu> <4B62F5F6.3040401@windriver.com>
	 <ce2c83091001312153u280c0035j9ef53fb3e8d9068d@mail.gmail.com>
	 <4B666F41.9080302@windriver.com>
Date: Mon, 1 Feb 2010 14:41:01 +0800
Message-ID: <ce2c83091001312241u89d71fwe4789066684d083a@mail.gmail.com>
Subject: Re: [PATCH 1/3] softlockup: add sched_clock_tick() to avoid kernel 
	warning on kgdb resume
From: Dongdong Deng <libfetion@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       "Deng, Dongdong" <Dongdong.Deng@windriver.com>, peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 2:05 PM, Jason Wessel <jason.wessel@windriver.com> wrote:
> Dongdong Deng wrote:
>> On Fri, Jan 29, 2010 at 10:51 PM, Jason Wessel
>> <jason.wessel@windriver.com> wrote:
>>
>>> echo 3 > /proc/sys/kernel/softlockup_thresh
>>>
>>> And then some kernel code in a thread like:
>>>        local_irq_disable();
>>>        printk("Disable local irq for 11 seconds\n");
>>>        mdelay(11000);
>>>        local_irq_enable();
>>>
>>
>> Hi Jason,
>>
>> Maybe this problem was fixed by
>> commit baf48f6577e581a9adb8fe849dc80e24b21d171d - "softlock: fix false
>> panic which can occur if softlockup_thresh is reduced".
>>
>
>
> That is not the same problem.   The fix you referenced is a corner case
> where you end up with the stack trace at the point in time you reduce
> the threshold.  The only reason I reduce the threshold in the first
> place is just to shorten the amount of time it takes to observe the problem.

Thanks for your nice explanation. :)

Dongdong

> You can just change the numbers for the mdelay and use the default
> softlockup threshold values and still see the problem I reported.
>
> Jason.
>
