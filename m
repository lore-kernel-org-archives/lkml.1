Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYDUITR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYDUITR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYDUITF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:19:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39967 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbYDUITE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:19:04 -0400
Message-ID: <480C4DF1.2030204@garzik.org>
Date: Mon, 21 Apr 2008 04:18:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, kernel@wantstofly.org,
       linux-arm-kernel@lists.arm.linux.org.uk, galak@kernel.crashing.org,
       David Miller <davem@davemloft.net>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, cooloney@kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git patches] minor irq handler cleanups
References: <20080421013551.GA25960@havoc.gtf.org> <20080421074240.GA1938@flint.arm.linux.org.uk>
In-Reply-To: <20080421074240.GA1938@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Sun, Apr 20, 2008 at 09:35:51PM -0400, Jeff Garzik wrote:
>> diff --git a/arch/arm/mach-integrator/time.c b/arch/arm/mach-integrator/time.c
>> index 5278f58..5235f64 100644
>> --- a/arch/arm/mach-integrator/time.c
>> +++ b/arch/arm/mach-integrator/time.c
>> @@ -125,7 +125,7 @@ static int rtc_probe(struct amba_device *dev, void *id)
>>  	xtime.tv_sec = __raw_readl(rtc_base + RTC_DR);
>>  
>>  	ret = request_irq(dev->irq[0], arm_rtc_interrupt, IRQF_DISABLED,
>> -			  "rtc-pl030", dev);
>> +			  "rtc-pl030", NULL);
>>  	if (ret)
>>  		goto map_out;
>>  
> 
> BTW, if you're removing the dev_id argument from request_irq(), that
> also needs to happen for the corresponding free_irq() calls.
> arch/arm/mach-integrator/time.c does:
> 
>         free_irq(dev->irq[0], dev);
> 
> and these are untouched.

hrm, good point.  I re-reviewed specifically for this issue, just now, 
and it looks like there is another case of this as well, outside ARM.

If this hasn't been pulled, I'll redo the commit, otherwise I'll fix.

	Jeff



