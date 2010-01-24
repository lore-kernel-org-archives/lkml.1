Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032Ab0AXQ1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0AXQ1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 11:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656Ab0AXQ1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 11:27:45 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:39497 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab0AXQ1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 11:27:44 -0500
Message-ID: <4B5C74FB.6030308@gmail.com>
Date: Sun, 24 Jan 2010 17:27:39 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc5 regression] NULL pointer dereference in	vlan_skb_recv
 - probably introduced by commit	9793241fe92f7d9303fb221e43fc598eb065f267
References: <20100123165657.187c11e4@neptune.home> <20100123223132.0e62d8cb@neptune.home> <4B5C4E5E.2010507@gmail.com> <20100124160228.366f4e72@neptune.home> <20100124162549.2b39b222@neptune.home> <20100124162523.GC11037@hack>
In-Reply-To: <20100124162523.GC11037@hack>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 24 Jan 2010 17:27:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/01/2010 17:25, Américo Wang a écrit :
> On Sun, Jan 24, 2010 at 04:25:49PM +0100, Bruno Prémont wrote:
>> On Sun, 24 January 2010 Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> Le 23/01/2010 22:31, Bruno Prémont a écrit :
>>>>> Above part of code did change between 2.6.32 and 2.6.33-rc5 with
>>>>> commit 9793241fe92f7d9303fb221e43fc598eb065f267 (vlan: Precise RX
>>>>> stats accounting)
>>>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9793241fe92f7d9303fb221e43fc598eb065f267
>>>>
>>>> Reverting just that commit gets the system running correctly.
>>>>
>>>> Bruno
>>>
>>> I have no idea how this patch can break vlan networking.
>>>
>>> Your disassembly and .config seems to show your machine is not SMP
>>
>> Exact
>>
>>> Maybe something is broken on UP and alloc_percpu() ?
>>
>> Apparently not, see below and previous mail
>>
>>> Could you add a debug in vlan_dev_init()
>>
>> In addition to previous mail, I'm also dumping the result of
>> vlan_dev_info(dev) shows that the returned pointer is not the same
>> during vlan_dev_init() and vlan_skb_recv() ...
>>
>> diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
>> index b788978..f370ce1 100644
>> --- a/net/8021q/vlan_dev.c
>> +++ b/net/8021q/vlan_dev.c
>> @@ -165,8 +165,11 @@ int vlan_skb_recv(struct sk_buff *skb, struct net_device *dev,
>>
>>        rx_stats = per_cpu_ptr(vlan_dev_info(dev)->vlan_rx_stats,
>>                               smp_processor_id());
> 
> 
> I am thinking if vlan_dev_info(dev) here should be
> vlan_dev_info(skb->dev)...
> 
> 

Yes, I came to same conclusion :)

Thanks
