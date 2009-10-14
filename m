Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbZJNT2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbZJNT2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbZJNT2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:28:21 -0400
Received: from host179-6-static.238-77-b.business.telecomitalia.it ([77.238.6.179]:54964
	"EHLO mail.navynet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbZJNT2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:28:20 -0400
Message-ID: <4AD62626.6010709@navynet.it>
Date: Wed, 14 Oct 2009 21:27:34 +0200
From: Massimo Cetra <mcetra@navynet.it>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Massimo Cetra <ctrixk@navynet.it>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Bug #14378] Problems with net/core/skbuff.c
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>	<r-4Wjt4coy.A.CwC.Wal0KB@chimera> <20091012.034224.64980795.davem@davemloft.net> <4AD44435.3050703@navynet.it> <4AD45447.7030705@gmail.com> <4AD455E4.2070105@navynet.it>
In-Reply-To: <4AD455E4.2070105@navynet.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-auth-from: mcetra@navynet.it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Massimo Cetra ha scritto:
> Eric Dumazet ha scritto:
>> Could you please following patch ?
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 8d00976..54bf091 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -454,7 +454,7 @@ static unsigned int free_old_xmit_skbs(struct 
>> virtnet_info *vi)
>>          vi->dev->stats.tx_bytes += skb->len;
>>          vi->dev->stats.tx_packets++;
>>          tot_sgs += skb_vnet_hdr(skb)->num_sg;
>> -        kfree_skb(skb);
>> +        dev_kfree_skb_any(skb);
>>      }
>>      return tot_sgs;
>>  }
>>
>>
>>   
> Thank you very much.
>
> Compiling.
> It' will be in production in a few minutes.
> I'll let you know if the problem arises again.
> give me a couple of days because this problem is randomly triggered.
> Sometimes it happens multiple times a day, sometimes none.
>
Eric,
thanks for the patch.
The problem didn't arise again and i haven't seen any warning like that 
on both servers where that problem was happening more frequently.

I would say that it's fixed and if it's not, i'll let you know as soon 
as it happens again.

Thanks again,
Max



