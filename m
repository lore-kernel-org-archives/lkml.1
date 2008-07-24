Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYGXSjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYGXSjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 14:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYGXSja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 14:39:30 -0400
Received: from gw.goop.org ([64.81.55.164]:51057 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbYGXSj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 14:39:29 -0400
Message-ID: <4888CC5D.9030800@goop.org>
Date: Thu, 24 Jul 2008 11:39:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Eduardo Habkost <ehabkost@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, NetDev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] xen-netfront: call netif_start_queue() on xennet_open()
References: <1216912546-6971-1-git-send-email-ehabkost@redhat.com> <1216912546-6971-2-git-send-email-ehabkost@redhat.com> <4888A3B7.8060901@goop.org> <4888CA2A.1060509@garzik.org>
In-Reply-To: <4888CA2A.1060509@garzik.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jeremy Fitzhardinge wrote:
>> Eduardo Habkost wrote:
>>> xen-netfront was waking the queue before calling netif_start_queue(),
>>> triggering the BUG_ON() on __netif_schedule().
>>>
>>> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
>>>   
>> Ok,
>> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> but Ingo, do you want to pick this up?  You're gathering a collection 
>> of these patches anyway, or should we kick it over to Dave/Jeff?
>>
>>    J
>>
>>> ---
>>>  drivers/net/xen-netfront.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
>>> index 902bbe7..c749bdb 100644
>>> --- a/drivers/net/xen-netfront.c
>>> +++ b/drivers/net/xen-netfront.c
>>> @@ -329,7 +329,7 @@ static int xennet_open(struct net_device *dev)
>>>      }
>>>      spin_unlock_bh(&np->rx_lock);
>>>  
>>> -    xennet_maybe_wake_tx(dev);
>>> +    netif_start_queue(dev);
>
> This is clearly a net driver change, it should go this way... 

OK, all your's.

    J

