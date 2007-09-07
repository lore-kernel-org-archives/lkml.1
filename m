Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbXIGX7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbXIGX7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbXIGX7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:59:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56753 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbXIGX7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:59:42 -0400
Message-ID: <46E1E5E7.4080508@garzik.org>
Date: Fri, 07 Sep 2007 19:59:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, help@myri.com
Subject: Re: 2.6.23-rc4-mm1 myri10ge module link error on x86_64
References: <20070831215822.26e1432b.akpm@linux-foundation.org>	<20070906193751.GA4518@Krystal>	<20070906.134038.85411315.davem@davemloft.net> <20070906.134831.39160997.davem@davemloft.net>
In-Reply-To: <20070906.134831.39160997.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 06 Sep 2007 13:40:38 -0700 (PDT)
> 
>> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>> Date: Thu, 6 Sep 2007 15:37:51 -0400
>>
>>> I got a link error on myri10ge when building 2.6.23-rc4-mm1 on x86_64 :
>>>
>>> ERROR: "lro_flush_all" [drivers/net/myri10ge/myri10ge.ko] undefined!
>>> ERROR: "lro_receive_frags" [drivers/net/myri10ge/myri10ge.ko] undefined!
>>> make[2]: *** [__modpost] Error 1
>>> make[1]: *** [modules] Error 2
>>> make: *** [_all] Error 2
>> myri10ge needs some LRO ifdeffery.
> 
> Actually the fix is even simpler, missing select in Kconfig.
> 
> I've checked the following fix for this into the net-2.6.24
> tree.
> 
> commit 9fd380e892e078b582920325357292c07eeeecc9
> Author: David S. Miller <davem@kimchee.(none)>
> Date:   Thu Sep 6 21:44:36 2007 +0100
> 
>     [MYRI10GE]: Need to select INET_LRO.
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index b92b7dc..7d1a84e 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -2496,6 +2496,7 @@ config MYRI10GE
>  	depends on PCI
>  	select FW_LOADER
>  	select CRC32
> +	select INET_LRO

Yes, that's the correct fix.  ACK.


