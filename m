Return-Path: <linux-kernel-owner+w=401wt.eu-S1763907AbXKPD3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763907AbXKPD3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbXKPD2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:28:53 -0500
Received: from [222.73.24.84] ([222.73.24.84]:61508 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756810AbXKPD2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:28:52 -0500
Message-ID: <473D0DD9.3000600@cn.fujitsu.com>
Date: Fri, 16 Nov 2007 11:26:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dan Aloni <da-x@monatomic.org>
CC: Aristeu Rozanski <aris@ruivo.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: fix a deadlock in set_rtc_mmss()
References: <20071115165528.GA25520@localdomain> <20071115183046.GD8068@cathedrallabs.org>
In-Reply-To: <20071115183046.GD8068@cathedrallabs.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aristeu Rozanski wrote:
> Hello Dan,
>> Patch is valid only for 2.6.23.x, guessing from the recent arch/ changes 
>> in 2.6.24-rc.
>>
>> set_rtc_mmss() was used to be called from interrupt context in 2.6.22,
>> however in 2.6.23, it is called from a timer context, where interrupts
>> are enabled. This patch ensures that rtc_interrupt() won't dead-lock 
>> with set_rtc_mmss().
> 
>> diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
>> index 6241b50..8414236 100644
>> --- a/arch/x86_64/kernel/time.c
>> +++ b/arch/x86_64/kernel/time.c
>> @@ -87,13 +87,14 @@ static int set_rtc_mmss(unsigned long nowtime)
>>  	int retval = 0;
>>  	int real_seconds, real_minutes, cmos_minutes;
>>  	unsigned char control, freq_select;
>> +	unsigned long flags;
>>  
>>  /*
>>   * IRQs are disabled when we're called from the timer interrupt,
>>   * no need for spin_lock_irqsave()
>>   */
>>  
>> -	spin_lock(&rtc_lock);
>> +	spin_lock_irqsave(&rtc_lock, flags);
> I think it's a good idea to update or just remove the comment above.
> 

David P. Reed has sent a patch to fix this bug before you.

http://lkml.org/lkml/2007/11/14/435


Li Zefan
