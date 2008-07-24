Return-Path: <linux-kernel-owner+w=401wt.eu-S1751684AbYGXBDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbYGXBDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 21:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYGXBDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 21:03:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64331 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbYGXBDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 21:03:08 -0400
Message-ID: <4887D46C.80304@cn.fujitsu.com>
Date: Thu, 24 Jul 2008 09:01:32 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: markus@trippelsdorf.de, ag@alessandroguido.name,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] skge: resolve tx multiqueue bug
References: <20080723101827.GA2236@gentoox2.trippelsdorf.de>	<20080723140347.GA2245@gentoox2.trippelsdorf.de>	<48874C6A.1020604@cn.fujitsu.com> <20080723.153000.172383135.davem@davemloft.net>
In-Reply-To: <20080723.153000.172383135.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller said the following on 2008-7-24 6:30:
> From: Wang Chen <wangchen@cn.fujitsu.com>
> Date: Wed, 23 Jul 2008 23:21:14 +0800
> 
>> Markus Trippelsdorf said the following on 2008-7-23 22:03:
>>> On Wed, Jul 23, 2008 at 12:18:27PM +0200, Markus Trippelsdorf wrote:
>>>> On Wed, Jul 23, 2008 at 04:50:13PM +0800, Wang Chen wrote:
>>>>> Markus Trippelsdorf said the following on 2008-7-23 13:40:
>>>>>> On Tue, Jul 22, 2008 at 11:54:26AM +0200, Alessandro Guido wrote:
>>>>>>> Got a WARNING this morning (2.6.26-05752-g93ded9b) and I think it's related.
>>>>>> Same thing here (latest git):
>>>>>>
>>>>>> skge eth1: enabling interface
>>>>>> skge eth1: disabling interface
>>>>>> ------------[ cut here ]------------
>>>>>> WARNING: at net/core/dev.c:1344 __netif_schedule+0x24/0x6d()
>>>>>> Pid: 1904, comm: ip Not tainted 2.6.26-06077-gc010b2f #33
>>>>>>  [<ffffffff8020b3eb>] system_call_after_swapgs+0x7b/0x80
>>>> ...
>>>>>> ---[ end trace 92936ef183e09876 ]---
>>>>>> skge eth1: enabling interface
>>>>>> skge eth1: Link is up at 100 Mbps, full duplex, flow control both
>>>>>>
>>>>> Markus, please try this.
>>>>>
>>>>> - Add netif_start_queue() in ->open()
>>>>> - netif_carrier_*() is enough, remove netif_*_queue()
>>>> Unfortunately, your patch does not fix this. I still get the same warning.
>>>>
>>> This patch works for me:
>> Your patch works for me too. So I think it's better than mine. :)
>>
>> Tested-by: Wang Chen <wangchen@cn.fujitsu.com>
>>
>> Dave, since Markus and me tested this patch, would you please apply it?
> 
> I can't, it's whitespace damaged.  All the tabs are turned into spaces,
> also there is no signoff from Markus.
> 

OK. So let it be, since you removed the warning from __netif_schedule().
I will wait for your netif_tx_{free,unfreeze}() :)

