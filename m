Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZGHUWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZGHUWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZGHUW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:22:27 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45712 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbZGHUW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:22:26 -0400
Message-ID: <4A54FFFE.10306@petalogix.com>
Date: Wed, 08 Jul 2009 22:22:22 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@elte.hu,
       arnd@arndb.de, lethal@linux-sh.org, ltp-list@lists.sourceforge.net
Subject: Re: mmap hw behavior
References: <4A54D14F.9090101@petalogix.com>	<20090708.103520.193697491.davem@davemloft.net>	<4A54DF6F.1010405@petalogix.com> <20090708.110624.104984745.davem@davemloft.net>
In-Reply-To: <20090708.110624.104984745.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Michal Simek <michal.simek@petalogix.com>
> Date: Wed, 08 Jul 2009 20:03:27 +0200
>
>   
>> David Miller wrote:
>>     
>>> From: Michal Simek <michal.simek@petalogix.com>
>>> Date: Wed, 08 Jul 2009 19:03:11 +0200
>>>
>>>   
>>>       
>>>> When I call mmap for that open file with pointer to calloc place
>>>> (first parameter, + length zero) it should be one tlb invalidation
>>>> for calloc and new tlb which connect open file.  We check it and we
>>>> don't have any tlb invalidation that's why I think that kernel do
>>>> different thigs.  Or is it there any copying? Or anything different?
>>>>     
>>>>         
>>> There is no need to tlb flush the calloc area unless that memory area
>>> is actually touched by the user application and thus the page is
>>> faulted in.
>>>   
>>>       
>> That calloc area is filled by any value (in that test). Is it mean that
>> for this case when calloc area is touched
>> there must be tlb invalidation + remapping?
>>     
>
> Yes, if the calloc area is written to by the application, there
> should be a tlb flush when the mmap() overrides that virtual region
> with a different mapping.
>   
Can you please point me to any code which exactly do this? (for example
file mm/mmap.c line from ... to ... )

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

