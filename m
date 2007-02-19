Return-Path: <linux-kernel-owner+w=401wt.eu-S965800AbXBTAtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965800AbXBTAtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965802AbXBTAtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:49:00 -0500
Received: from hqemgate01.nvidia.com ([216.228.112.170]:6071 "EHLO
	HQEMGATE01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965800AbXBTAs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:48:59 -0500
Message-ID: <45D9B4AE.6030006@nvidia.com>
Date: Mon, 19 Feb 2007 09:31:10 -0500
From: Ayaz Abdulla <aabdulla@nvidia.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, David Ford <firefighterblu3@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: forcedeth problems on 2.6.20-rc6-mm3
References: <fa.EU4/Dq38S7AbpiJstT7NwokqTWE@ifi.uio.no> <fa.aMmqbeBS9CpIUWfPrgAtORtlXAQ@ifi.uio.no> <fa.d8YTRl6o0OIk8Vvk1QLpyc+bxQU@ifi.uio.no> <fa.XnyZ7qxKkAZ7Yhrg0DdiDmiy6wg@ifi.uio.no> <fa.s8qbnOGnlEinPfyyhT0PZsqiwwE@ifi.uio.no> <fa.6Uftu56OuKdbN+aI/fzLv4opZ/I@ifi.uio.no> <45DA4327.3010106@shaw.ca>
In-Reply-To: <45DA4327.3010106@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2007 00:48:49.0725 (UTC) FILETIME=[E2980ED0:01C75488]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Robert Hancock wrote:
> Ayaz Abdulla wrote:
> 
>>
>> For all those who are having issues, please try out the attached patch.
>>
>> Ayaz
>>
>>
>> ----------------------------------------------------------------------------------- 
>>
>> This email message is for the sole use of the intended recipient(s) 
>> and may contain
>> confidential information.  Any unauthorized review, use, disclosure or 
>> distribution
>> is prohibited.  If you are not the intended recipient, please contact 
>> the sender by
>> reply email and destroy all copies of the original message.
>> ----------------------------------------------------------------------------------- 
>>
>>
>>
>> ------------------------------------------------------------------------
>>
>> --- orig/drivers/net/forcedeth.c    2007-02-08 21:41:59.000000000 -0500
>> +++ new/drivers/net/forcedeth.c    2007-02-08 21:44:53.000000000 -0500
>> @@ -3104,13 +3104,17 @@
>>      struct fe_priv *np = netdev_priv(dev);
>>      u8 __iomem *base = get_hwbase(dev);
>>      unsigned long flags;
>> +    u32 retcode;
>>  
>> -    if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2)
>> +    if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
>>          pkts = nv_rx_process(dev, limit);
>> -    else
>> +        retcode = nv_alloc_rx(dev);
>> +    } else {
>>          pkts = nv_rx_process_optimized(dev, limit);
>> +        retcode = nv_alloc_rx_optimized(dev);
>> +    }
>>  
>> -    if (nv_alloc_rx(dev)) {
>> +    if (retcode) {
>>          spin_lock_irqsave(&np->lock, flags);
>>          if (!np->in_shutdown)
>>              mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
> 
> 
> Did anyone push this patch into mainline? forcedeth on 2.6.20-git14 is 
> still completely broken without this patch.
> 

I have submitted the patch to netdev mailing list.

