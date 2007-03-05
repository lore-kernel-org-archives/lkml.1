Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbXCEVJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbXCEVJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbXCEVJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:09:49 -0500
Received: from h155.mvista.com ([63.81.120.155]:62328 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752883AbXCEVJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:09:47 -0500
Message-ID: <45EC8713.5060304@ru.mvista.com>
Date: Tue, 06 Mar 2007 00:09:39 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][pata-2.6 tree] pdc202xx_old: rewrite mode programming
 code
References: <200703040149.46186.bzolnier@gmail.com> <45EC53AE.30808@ru.mvista.com> <200703052138.28508.bzolnier@gmail.com> <45EC82BB.8000709@ru.mvista.com>
In-Reply-To: <45EC82BB.8000709@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>> official == same as in the docs and vendor driver :-)

>>>    Erm, those look a bit doubtful...

>> I believe that they are correct - please see explanations below.

>    Yeah, sorry about that. Only SWDMA timings are suspicious.

    Hm, too early to say sorry. I was hasty/distacted and forgot what I was 
going to write... :-)

>>>> Index: b/drivers/ide/pci/pdc202xx_old.c
>>>> ===================================================================
>>>> --- a/drivers/ide/pci/pdc202xx_old.c
>>>> +++ b/drivers/ide/pci/pdc202xx_old.c
>>>
>>> [...]

>>>> @@ -161,7 +95,7 @@ static int pdc202xx_tune_chipset (ide_dr
>>>>         case XFER_UDMA_0:
>>>>         case XFER_MW_DMA_2:    TB = 0x60; TC = 0x03; break;
>>>>         case XFER_MW_DMA_1:    TB = 0x60; TC = 0x04; break;
>>>> -        case XFER_MW_DMA_0:
>>>> +        case XFER_MW_DMA_0:    TB = 0xE0; TC = 0x0F; break;

>>>    This seems even slower than SWDMA0!
>>>    Let's assume that means 7 active cycles and 15 recovery cycles 
>>> (MWDMA1/2 settings seem to confirm this hypothesis) -- this would 
>>> give us 720 ns vs the specified 480. Could you shed some light on 
>>> what these fields mean? :-/

>> The calculations are done in a different way so we get the correct 
>> timings:

>>  7 cycles (== 210 ns) are used for active time

    Ugh, forgot to say: this is overclocked, 215 ns is the minimum active time 
for this mode.

>> 16 cycles (== 480 ns) are used for cycle time

>    Ah, indeed, I've erred in MWDMA1/2 calculations. This makes sense then.

MBR, Sergei
