Return-Path: <linux-kernel-owner+w=401wt.eu-S1751435AbZEWEnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbZEWEnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 00:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbZEWEm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 00:42:56 -0400
Received: from mail.candelatech.com ([208.74.158.172]:44188 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZEWEm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 00:42:56 -0400
Message-ID: <4A177ECE.7080508@candelatech.com>
Date: Fri, 22 May 2009 21:42:54 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question on lockdep and sysrq - d
References: <4A1743C5.9020803@candelatech.com> <d82e647a0905221803w487fcdb3k2319bdaa7d9cc559@mail.gmail.com>
In-Reply-To: <d82e647a0905221803w487fcdb3k2319bdaa7d9cc559@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei wrote:
> See http://marc.info/?l=linux-kernel&m=124211522525625&w=2.
>   
That is about some real bug in the official kernel.  I am almost 100%
certain that my own code is at fault here.

I'm just trying to better understand the way lockdep prints out
all of the locks so I can easier debug my issue.

Thanks,
Ben

> thanks.
>
> 2009/5/23 Ben Greear <greearb@candelatech.com>:
>   
>> Hello!
>>
>> I'm trying to debug an apparent deadlock in some code I'm
>> writing.
>>
>> When I do a sysrq 'd', I get a nice dump of locks (I have lockdep enabled).
>>
>> However, the output appears to show multiple processes holding the
>> same locks (rtnl_mutex, for example):
>>
>> Showing all locks held in the system:
>> 3 locks held by events/11/63:
>>  #0:  (events){--..}, at: [<ffffffff8104f71e>] run_workqueue+0xb1/0x216
>>  #1:  ((linkwatch_work).work){--..}, at: [<ffffffff8104f71e>]
>> run_workqueue+0xb1/0x216
>>  #2:  (rtnl_mutex){--..}, at: [<ffffffff8125def1>] rtnl_lock+0x12/0x14
>> 1 lock held by irqbalance/3360:
>>  #0:  (rtnl_mutex){--..}, at: [<ffffffff8125def1>] rtnl_lock+0x12/0x14
>> 1 lock held by hald/3605:
>>  #0:  (rtnl_mutex){--..}, at: [<ffffffff8125def1>] rtnl_lock+0x12/0x14
>> ...
>>
>> Is this merely showing processes that are blocked on trying to acquire these
>> locks?
>>
>> If so, is there any way to tell which processes have fully acquired locks
>> v/s
>> just waiting to acquire them?
>>
>> Thanks,
>> Ben
>>     

-- 
Ben Greear <greearb@candelatech.com> 
Candela Technologies Inc  http://www.candelatech.com


