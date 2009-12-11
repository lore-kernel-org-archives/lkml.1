Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbZLKOIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbZLKOIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbZLKOIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:08:36 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:38258 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbZLKOIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h8SgwxG7lfSupjHs7dMufkBzkHKeGWX52NPB0Xhf7lO+Oq1RZhjm4HukRWZOl9g/VX
         HKColnlaIwtUP5uinCxLB3uRttiiNOc9GOwNYcS+oEiD+jTRdqfPSg+MPje6FW89G6Ly
         PVnABhz6rTc4LOOpV/7UEKBpuJP1EL0XMejZw=
MIME-Version: 1.0
In-Reply-To: <4B224E7A.2060708@redhat.com>
References: <20091210185626.26f9828a@cuia.bos.redhat.com>
	 <28c262360912101803i7b43db78se8cf9ec61d92ee0f@mail.gmail.com>
	 <4B2235F0.4080606@redhat.com>
	 <28c262360912110541m2839e151hc9d49b0c251e1b67@mail.gmail.com>
	 <4B224E7A.2060708@redhat.com>
Date: Fri, 11 Dec 2009 23:08:42 +0900
Message-ID: <28c262360912110608y13c76af0g4acff99d39173493@mail.gmail.com>
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: lwoodman@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 10:51 PM, Rik van Riel <riel@redhat.com> wrote:
> On 12/11/2009 08:41 AM, Minchan Kim wrote:
>>
>> Hi, Larry.
>>
>> On Fri, Dec 11, 2009 at 9:07 PM, Larry Woodman<lwoodman@redhat.com>
>>  wrote:
>>>
>>> Minchan Kim wrote:
>>>>
>>>> I like this. but why do you select default value as constant 8?
>>>> Do you have any reason?
>>>>
>>>> I think it would be better to select the number proportional to NR_CPU.
>>>> ex) NR_CPU * 2 or something.
>>>>
>>>> Otherwise looks good to me.
>>>>
>>>> Reviewed-by: Minchan Kim<minchan.kim@gmail.com>
>>>>
>>>>
>>>
>>> This is a per-zone count so perhaps a reasonable default is the number of
>>> CPUs on the
>>> NUMA node that the zone resides on ?
>>
>> For example, It assume one CPU per node.
>> It means your default value is 1.
>> On the CPU, process A try to reclaim HIGH zone.
>> Process B want to reclaim NORMAL zone.
>> But Process B can't enter reclaim path sincev throttle default value is 1
>> Even kswap can't reclaim.
>
> 1) the value is per zone, so process B can go ahead

Sorry. I misunderstood Larry's point.
I though Larry mentioned global limit not per zone.

> 2) kswapd is always excempt from this limit, since
>   there is only 1 kswapd per node anyway

Larry could test with Rik's patch for what's good default value.
If it proves NR_CPU on node is proper as default value,
We can change default value with it.


> --
> All rights reversed.
>



-- 
Kind regards,
Minchan Kim
