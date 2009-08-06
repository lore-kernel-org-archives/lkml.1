Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZHFHUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZHFHUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZHFHUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:20:09 -0400
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:40614 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbZHFHUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:20:08 -0400
Message-ID: <4A7A8454.7040905@gefanuc.com>
Date: Thu, 06 Aug 2009 08:20:52 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2] Staging: Correct tsi-148 VME interrupt free routine
References: <20090805163219.4903.43629.stgit@ES-J7S4D2J.amer.consind.ge.com> <20090805163802.28044.91999.stgit@ES-J7S4D2J.amer.consind.ge.com> <4A79FF57.50902@gmail.com>
In-Reply-To: <4A79FF57.50902@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 08/05/2009 06:38 PM, Martyn Welch wrote:
>   
>>  	if (tsi148_bridge->irq[level - 1].count == 0) {
>> -		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEO);
>> -		tmp &= ~TSI148_LCSR_INTEO_IRQEO[level - 1];
>> -		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEO);
>> -
>>  		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEN);
>>  		tmp &= ~TSI148_LCSR_INTEN_IRQEN[level - 1];
>>  		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEN);
>> +
>> +		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEO);
>> +		tmp &= ~TSI148_LCSR_INTEO_IRQEO[level - 1];
>> +		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEO);
>>     
>
> I have no idea what the registers do and I suppose it's behind some PCI
> bridge anywhere. If it is not true, ignore the further.
>
> Is it OK that the second write to INTEO doesn't reach the device before
> you set func to NULL? I mean, is it enough to prevent the interrupt
> raising only by twiddling INTEN? Otherwise you need to put some read
> right here to push non-completed writes on bridges (flush posted
> writes). (I mentioned this in the former mail too.)
>   

Yes, this is fine:

TSI148_LCSR_INTEN = Interrupt Enable
TSI148_LCSR_INTEO = Interrupt Output Enable

If an interrupt source is completely disabled, it doesn't matter whether or not it is stopped from generating a PCI interrupt.

Martyn

-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
