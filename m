Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbYGXSaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbYGXSaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 14:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYGXSal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 14:30:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37794 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbYGXSak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 14:30:40 -0400
Message-ID: <4888CA2A.1060509@garzik.org>
Date: Thu, 24 Jul 2008 14:30:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Eduardo Habkost <ehabkost@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, NetDev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] xen-netfront: call netif_start_queue() on xennet_open()
References: <1216912546-6971-1-git-send-email-ehabkost@redhat.com> <1216912546-6971-2-git-send-email-ehabkost@redhat.com> <4888A3B7.8060901@goop.org>
In-Reply-To: <4888A3B7.8060901@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Eduardo Habkost wrote:
>> xen-netfront was waking the queue before calling netif_start_queue(),
>> triggering the BUG_ON() on __netif_schedule().
>>
>> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
>>   
> Ok,
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> but Ingo, do you want to pick this up?  You're gathering a collection of 
> these patches anyway, or should we kick it over to Dave/Jeff?
> 
>    J
> 
>> ---
>>  drivers/net/xen-netfront.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
>> index 902bbe7..c749bdb 100644
>> --- a/drivers/net/xen-netfront.c
>> +++ b/drivers/net/xen-netfront.c
>> @@ -329,7 +329,7 @@ static int xennet_open(struct net_device *dev)
>>      }
>>      spin_unlock_bh(&np->rx_lock);
>>  
>> -    xennet_maybe_wake_tx(dev);
>> +    netif_start_queue(dev);

This is clearly a net driver change, it should go this way...

	Jeff



