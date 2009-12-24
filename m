Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZLXQ0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZLXQ0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 11:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZLXQ0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 11:26:41 -0500
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:61608 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZLXQ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 11:26:40 -0500
X-Greylist: delayed 945 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Dec 2009 11:26:40 EST
Date: Thu, 24 Dec 2009 11:26:49 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: sky2 panic in 2.6.32.1 under load
In-reply-to: <4B3393C3.7050408@gmail.com>
To: Berck Nash <flyboy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>
Message-id: <4B339649.3020007@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B300A2A.8040305@gmail.com>
 <20091223225855.4a7d00af.akpm@linux-foundation.org>
 <4B339290.60909@majjas.com> <4B3393C3.7050408@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2009 11:16 AM, Berck Nash wrote:
> Michael Breuer wrote:
>    
>>>> Since 2.6.32, I've been getting kernel panics under heavy network load
>>>> (bittorrent usage).
>>>>
>>>>          
>>> Let's cc the right list and developer.
>>>
>>> This is a 2.6.31->2.6.32 regression?
>>>
>>>        
>> I don't think so. I saw this on 2.6.31 - first kernel I put on this
>> system. At the time, I was having issues with intel_iommu and thought
>> that the culprit.
>> The initial reply to this thread from Daniel Hazelton stated that this
>> has been happening since 2.6.25.
>>      
> Your oops appears to be different than mine.  Hazelton did not provide
> any logs, and he said "a version of this" so I don't know if his is the
> same or not.
>    
Actually, I have two different oops, and a couple of crashes without any 
oops at all. All were produced under the same conditions, all pointing 
at sky2. I'd guess at memory corruption under load with subsequent 
divergent manifestations. The real question is whether the bug is in the 
kernel or the NIC firmware. There were similar reports online of this 
behavior affecting Vista, however those were resolved by moving to later 
firmware. I've recreated the crash on the later firmware however.

Summary of conditions that appear to be required for the 
lockup/oops/panic(s):

1. Running at 1Gb.
2. High traffic into the system (out seems ok).
3. For me, the crash only occurs when smbd is the application generating 
the traffic.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>    

