Return-Path: <linux-kernel-owner+w=401wt.eu-S1751363AbZKCGEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbZKCGEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 01:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZKCGEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 01:04:48 -0500
Received: from smtp.nokia.com ([192.100.122.230]:50196 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZKCGEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 01:04:47 -0500
Message-ID: <4AEFC7CF.1020909@nokia.com>
Date: Tue, 03 Nov 2009 08:03:59 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "ext John W. Linville" <linville@tuxdriver.com>
CC: "Valo Kalle (Nokia-D/Tampere)" <Kalle.Valo@nokia.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for November 2 (wireless/wl1271)
References: <20091102173845.210d1c57.sfr@canb.auug.org.au> <4AEF1E7F.50306@oracle.com> <20091102184449.GJ14046@tuxdriver.com> <20091102184843.GK14046@tuxdriver.com> <4AEF4ACB.5040302@nokia.com>
In-Reply-To: <4AEF4ACB.5040302@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2009 06:04:21.0603 (UTC) FILETIME=[7C96A330:01CA5C4B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coelho Luciano (Nokia-D/Helsinki) wrote:
> ext John W. Linville wrote:
>> Helps if I actually Cc: Luca...
> 
> Yes, it does. :) I would see this at some point but CCing me speed things up 
> quite a lot.


BTW, I think we need this for wl1251 as well.  CC'ing Kalle too.


>> On Mon, Nov 02, 2009 at 01:44:49PM -0500, John W. Linville wrote:
>>> On Mon, Nov 02, 2009 at 10:01:35AM -0800, Randy Dunlap wrote:
>>>> Stephen Rothwell wrote:
>>>>> Hi all,
>>>>>
>>>>> Changes since 20091030:
>>>> wl1271 build fails when CONFIG_INET=n.
>>>> Should this driver depend on INET?
>>>>
>>>> Why does this driver, unlike all other wireless drivers,
>>>> want to use register_inetaddr_notifier()?
>>>>
>>>> wl1271_main.c:(.text+0x271052): undefined reference to `unregister_inetaddr_notifier'
>>>> wl1271_main.c:(.text+0x2714d7): undefined reference to `register_inetaddr_notifier'
>>> Yeah, that driver is doing some filtering based on IPv4.
>>>
>>> Luca, is that necessary?  If so, then we need a patch like the one below...?
> 
> Yes, this is necessary.  We are doing ARP filtering according to the IP address 
> of the interface, as you have realized.  Our implementation is rather ugly at 
> the moment, so the plan is to try to get rid of this dependency on INET, but we 
> need it for now.
> 
> Thanks Randy for finding this and thanks John for fixing it.
> 
>>> From ba823accfad68151d80503ff5fb04c049c9eadc2 Mon Sep 17 00:00:00 2001
>>> From: John W. Linville <linville@tuxdriver.com>
>>> Date: Mon, 2 Nov 2009 13:43:32 -0500
>>> Subject: [PATCH] wl1271: depend on INET
>>>
>>> wl1271_main.c:(.text+0x271052): undefined reference to `unregister_inetaddr_notifier'
>>> wl1271_main.c:(.text+0x2714d7): undefined reference to `register_inetaddr_notifier'
>>>
>>> Driver is doing some filtering based on IP addresses...
>>>
>>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>> ---
>>>  drivers/net/wireless/wl12xx/Kconfig |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
>>> index 33de7fa..785e024 100644
>>> --- a/drivers/net/wireless/wl12xx/Kconfig
>>> +++ b/drivers/net/wireless/wl12xx/Kconfig
>>> @@ -42,6 +42,7 @@ config WL1251_SDIO
>>>  config WL1271
>>>  	tristate "TI wl1271 support"
>>>  	depends on WL12XX && SPI_MASTER && GENERIC_HARDIRQS
>>> +	depends on INET
>>>  	select FW_LOADER
>>>  	select CRC7
>>>  	---help---
>>> -- 
>>> 1.6.2.5
> 
> Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
> 


-- 
Cheers,
Luca.
