Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190Ab0AVXZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab0AVXZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149Ab0AVXZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:25:23 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:36783 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab0AVXZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:25:19 -0500
Date: Fri, 22 Jan 2010 18:25:12 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Hang: 2.6.32.4 sky2/DMAR (was [PATCH] sky2: Fix WARNING: at
 lib/dma-debug.c:902 check_sync)
In-reply-to: <20100122230605.GB3105@del.dom.local>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Message-id: <4B5A33D8.90501@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20100120094103.GA6225@ff.dom.local> <4B58B217.8030001@majjas.com>
 <20100121204133.GB3085@del.dom.local> <4B59E7EB.3050605@majjas.com>
 <20100122215304.GA3105@del.dom.local> <4B5A2362.6000306@majjas.com>
 <20100122230605.GB3105@del.dom.local>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/2010 6:06 PM, Jarek Poplawski wrote:
> On Fri, Jan 22, 2010 at 05:14:58PM -0500, Michael Breuer wrote:
>    
>> On 1/22/2010 4:53 PM, Jarek Poplawski wrote:
>>      
>>> On Fri, Jan 22, 2010 at 01:01:15PM -0500, Michael Breuer wrote:
>>>        
>>>> Kernel 2.6.32.4 (git) with the following patches applied:
>>>>
>>>> af_packet.c (tpacket_snd version 3)
>>>> sky2.c pskb_may_pull
>>>> sky2 fix WARNING at lib/dma-debug.c check_sync
>>>>          
>>> I guess, you meant the "sky2.c receive_copy" patch which you tested
>>> earlier, or at least you managed to crash DMAR with that patch
>>> before crashing it with Stephen's "lib/dma-debug.c check_sync" patch,
>>> right?
>>>
>>>        
>> Yes - sorry, correct - all three patches were in the last run.
>> Previously, I've encountered the crash without these patches.
>>      
> OK, thanks for testing - it's really very helpful, and supports
> David's opinion that dmar is a different problem.
> ...
>    
>> Not sure I can do that. Note that based on the log messages, there
>> were no errors/dropped packets involving dhcp. Moving the dhcp
>> server off of the affected machine is not trivial. The dhcp
>> correlation is based on logged messages preceding each crash. I
>> cannot confirm that they're related, however it's really suspicious.
>> If it helps, HP replaced my unmanaged switch with a managed one so I
>> can see whether there were any switch events logged the next time I
>> have a crash.
>>
>> At this point, it seems the following is required to trigger the crash:
>> 1) Uptime of 24-36 hours
>> 2) High RX load on server (cifs traffic is what I've triggered it with).
>> 3) Normal DHCP traffic.
>>      
> Do you mean you got these crashes with the new switch too, and this
> switch doesn't drop DHCP at all? (Otherwise, let's try this switch
> first.)
>
> Jarek P.
>    
Nope - just got the new switch. Crash was old switch. That said, I don't 
think (based on the log messages) that the dhcpoffer packet drop was 
happening prior to the crash. I also can't fathom why a DHCPOFFER packet 
dropped after leaving the server would have any bearing on the issue.
