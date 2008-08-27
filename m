Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbYH0Q6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbYH0Q6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbYH0Q6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:58:24 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:10154 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758960AbYH0Q6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:58:22 -0400
Message-ID: <48B58792.5080501@hp.com>
Date: Wed, 27 Aug 2008 09:57:54 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Eric Dumazet <dada1@cosmosbay.com>,
       Denys Fedoryshchenko <denys@visp.net.lb>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
References: <200808220457.40892.denys@visp.net.lb>	<20080826201406.GA24827@2ka.mipt.ru>	<48B46B48.7030609@cosmosbay.com>	<20080826205158.GA15266@2ka.mipt.ru>	<87vdxmr53f.fsf@basil.nowhere.org> <48B57BD3.5050206@hp.com>	<20080827162735.GW26610@one.firstfloor.org>	<48B58586.3080806@hp.com> <20080827165635.GY26610@one.firstfloor.org>
In-Reply-To: <20080827165635.GY26610@one.firstfloor.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, Aug 27, 2008 at 09:49:10AM -0700, Rick Jones wrote:
> 
>>Andi Kleen wrote:
>>
>>>>Those banks really want to crank down on latency - to the point they 
>>>>start disabling interrupt coalescing.  I bet they'd toss anything out 
>>>>they could to shave another microsecond.
>>>
>>>
>>>This change would actually likely lower their latency.
>>
>>I'm guessing you mean increase their latency?  I agree, it could - 
>>depends entirely on the PPS in production I suspect.
> 
> 
> No, moving the time stamps into the socket decreases latency
> for all packets that don't need time stamps. And they likely 
> have some packets which don't need time stamps too.

Ah, since that part of the discussion wasn't in the quoted text I 
assumed you were talking about the disabling of interrupt coalescing.

rick jones

> 
> As a secondary effect if they use a RT kernel it might
> be also beneficial to do the (depending on the platform)
> costly time stamp in the lower priority socket context
> than in the high priority interrupt thread.
> 
> -Andi

