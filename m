Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZLKNwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZLKNwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbZLKNwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:52:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202AbZLKNwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:52:24 -0500
Message-ID: <4B224E7A.2060708@redhat.com>
Date: Fri, 11 Dec 2009 08:51:54 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: lwoodman@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091210185626.26f9828a@cuia.bos.redhat.com>	 <28c262360912101803i7b43db78se8cf9ec61d92ee0f@mail.gmail.com>	 <4B2235F0.4080606@redhat.com> <28c262360912110541m2839e151hc9d49b0c251e1b67@mail.gmail.com>
In-Reply-To: <28c262360912110541m2839e151hc9d49b0c251e1b67@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2009 08:41 AM, Minchan Kim wrote:
> Hi, Larry.
>
> On Fri, Dec 11, 2009 at 9:07 PM, Larry Woodman<lwoodman@redhat.com>  wrote:
>> Minchan Kim wrote:
>>>
>>> I like this. but why do you select default value as constant 8?
>>> Do you have any reason?
>>>
>>> I think it would be better to select the number proportional to NR_CPU.
>>> ex) NR_CPU * 2 or something.
>>>
>>> Otherwise looks good to me.
>>>
>>> Reviewed-by: Minchan Kim<minchan.kim@gmail.com>
>>>
>>>
>>
>> This is a per-zone count so perhaps a reasonable default is the number of
>> CPUs on the
>> NUMA node that the zone resides on ?
>
> For example, It assume one CPU per node.
> It means your default value is 1.
> On the CPU, process A try to reclaim HIGH zone.
> Process B want to reclaim NORMAL zone.
> But Process B can't enter reclaim path sincev throttle default value is 1
> Even kswap can't reclaim.

1) the value is per zone, so process B can go ahead

2) kswapd is always excempt from this limit, since
    there is only 1 kswapd per node anyway

-- 
All rights reversed.
