Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891Ab0AQWfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0AQWfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 17:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384Ab0AQWfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 17:35:09 -0500
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:53546 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0AQWfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 17:35:07 -0500
Date: Sun, 17 Jan 2010 17:34:19 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
In-reply-to: <20100117221746.GA3161@del.dom.local>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-id: <4B53906B.2020608@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B475FF9.7000702@majjas.com> <20100108212923.GA3078@del.dom.local>
 <4B47A81B.5040601@majjas.com> <4B4809EF.1070609@majjas.com>
 <20100109122830.GA4386@del.dom.local> <4B48CC2C.2090403@majjas.com>
 <4B4E2F89.2050606@majjas.com> <20100113210908.GA3065@del.dom.local>
 <4B4E3834.3000609@majjas.com> <4B533A46.9050600@majjas.com>
 <20100117221746.GA3161@del.dom.local>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/2010 5:17 PM, Jarek Poplawski wrote:
> On Sun, Jan 17, 2010 at 11:26:46AM -0500, Michael Breuer wrote:
>    
>> On 01/13/2010 04:16 PM, Michael Breuer wrote:
>>      
>>> On 1/13/2010 4:09 PM, Jarek Poplawski wrote:
>>>        
>>>> On Wed, Jan 13, 2010 at 03:39:37PM -0500, Michael Breuer wrote:
>>>>          
>>>>
>> Update: after leaving the system up for a few days, I hit the DMAR
>> error again.
>>      
> My proposal is to send some summary as a new thread, with dmar in the
> subject, and cc-ed dmar maintainers.
>
>    
Not sure I agree. The symptoms are identical to those I hit without DMAR 
earlier on. Also, as this issue only happens when there is high receive 
load, I'm thinking there's some sort of race between TX and RX within 
the sky2 driver, or hardware. I think that DMAR is correctly catching 
the error.
>> This happened during a scheduled backup from my win7
>> box. A reboot was required to re-enable eth0. After the error, eth0
>> was receiving, but was unable to transmit. For example, the log
>> reported arp bogons; DHCPINFORM/ACK sequences (where the ACK that
>> was logged was not transmitted), etc. The log was filled with sky2
>> eth0: tx timeout messages; as well as disable/enable of eth0.
>>
>> I attempted to get things up again without a reboot, but failed.
>> Even rmmod&  insmod did not fix whatever was broken on the TX side.
>>
>> Note that this is similar to the earlier sky2 errors I had under
>> load with the variety of patches, and with or without DMAR enabled.
>> Just took way longer this time. Note that eth1 remained functional.
>>
>> Unfortunately, with the latest set of patches installed, this is no
>> longer reproducible at will. I'd guess therefore that the patches
>> narrowed some hole, but didn't close it.
>>      
> It would be nice to name those patches each time. Anyway, try this
> again without DMAR.
>
> Thanks,
> Jarek P.
>    
>
My bad: was running with the af_packet.c version 3 patch; and Stephen's 
v4 patch from last week. Both on 2.6.32 from git (so 2.6.32.4). Can't 
move back to head as I've hit two unrelated issues.

