Return-Path: <linux-kernel-owner+w=401wt.eu-S932590Ab0AGIVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab0AGIVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932434Ab0AGIVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:21:53 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45362 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab0AGIVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:21:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xz7d8pzTS4dPkNN9lrStKvh2MrxPzBl3Nx1/06Hv+4B93m6dWr2jpqPgN314sjzbJ7
         PRAGwIFRrVp6xCa0IVJuo2M10A5lN3nZDEYV4dhV5mgKMJ7CeKAXAgTH5ce6ENDh/UVY
         pFuZpD+5ISM1KTLPF7eKohDPAiNuHPkcpvkP0=
Date: Thu, 7 Jan 2010 08:21:40 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100107082140.GB7229@ff.dom.local>
References: <20100106131044.25b4e500@nehalam> <4B451C31.3000309@majjas.com> <4B454A16.3030909@majjas.com> <4B455C62.6030504@majjas.com> <20100106205343.5460d658@nehalam> <4B4571D5.30002@majjas.com> <4B457711.1040008@majjas.com> <4B458B36.6050509@majjas.com> <20100107074756.GB6258@ff.dom.local> <4B459368.2000503@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B459368.2000503@majjas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 02:55:20AM -0500, Michael Breuer wrote:
> On 1/7/2010 2:47 AM, Jarek Poplawski wrote:
>> On Thu, Jan 07, 2010 at 02:20:22AM -0500, Michael Breuer wrote:
>>    
>>> ...
>>> Reapplied a couple of earlier patches - still can't do jumbo frames, but
>>> the rx errors are gone and speed has improved. Too early to assure that
>>> it's stable.
>>>
>>> Patches that seem to fix the rx drops (all from Stephen):
>>> 1) Patch change to tx_init
>>> 2) Patch to lock netif_device_detach
>>> 3) Patch to sky2_tx_complete to add netif_device_present test
>>> Also in the mix: Jarek's alternative 2
>>>      
>> BTW, the main difference between alt. 1 and 2 is error notification:
>> alternative 2 doesn't hide some (most) of drops, so, dependending on
>> app, there might be more and faster retransmits. (I don't know what
>> apps used by you (other than dhcp) can depend so much on this.)
>>
>>    
> Unless I misread the code, I think that in some cases e skb is actually  
> freed if the cfq (among others perhaps) scheduler returns an error on  
> enqueue (flow control perhaps).  Thus with alternative 1, it is possible  
> that the skb is acted upon after being freed - this would be consistent  
> with the DMAR errors I saw.

I can't see your point: could you give some scenario?

Jarek P.
