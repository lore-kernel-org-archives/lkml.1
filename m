Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbYGEPPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbYGEPPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 11:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYGEPPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 11:15:15 -0400
Received: from mail.ccur.com ([12.192.68.12]:59393 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbYGEPPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 11:15:14 -0400
Message-ID: <486F9009.5070607@ccur.com>
Date: Sat, 5 Jul 2008 11:15:21 -0400
From: John Blackwood <john.blackwood@ccur.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "andi-suse@firstfloor.org" <andi-suse@firstfloor.org>,
       "Allen, Todd" <todd.allen@ccur.com>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] node meminfo Active & Inactive pages to Kbytes
References: <486CE3CD.7090907@ccur.com> <20080703154230.17263a19.akpm@linux-foundation.org>
In-Reply-To: <20080703154230.17263a19.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 3 Jul 2008 10:35:57 -0400
> John Blackwood <john.blackwood@ccur.com> wrote:
> 
>> Hi Andrew and Andi,
>>
>> We found a minor bug in the output of
>> /sys/devices/system/node/node[n]/meminfo
>> where the Active and Inactive values are in pages instead of Kbytes.
>>
>> Looks like this occurred back in 2.6.20 when the code was changed
>> over to use node_page_state().
>>
>> Thanks.
>>
>> --- linux.2.6.26-rc8/drivers/base/node.c      2008-07-03 09:26:01.000000000 -0400
>> +++ new/drivers/base/node.c   2008-07-03 09:25:45.000000000 -0400
>> @@ -84,8 +84,8 @@ static ssize_t node_read_meminfo(struct
>>                      nid, K(i.totalram),
>>                      nid, K(i.freeram),
>>                      nid, K(i.totalram - i.freeram),
>> -                    nid, node_page_state(nid, NR_ACTIVE),
>> -                    nid, node_page_state(nid, NR_INACTIVE),
>> +                    nid, K(node_page_state(nid, NR_ACTIVE)),
>> +                    nid, K(node_page_state(nid, NR_INACTIVE)),
>>   #ifdef CONFIG_HIGHMEM
>>                      nid, K(i.totalhigh),
>>                      nid, K(i.freehigh),
> 
> ug.  After all that time there might be applications out there which
> use the existing numbers and work around the kernel bug.  Which we'll
> break if we fix it.

true.  our tool that looks at these numbers is going to be changed to 
optionally multiply the values by 4 based on the kernel revision/version 
number once this change makes it into the main tree.

> otoh, who the heck cares about the per-node active and inactive page
> counts?

   :-)


> I guess we just fix this, backport the fix as far as we can and
> apologise for any fallout.  Not that there's likely to be any.
> 
o.k. Thanks.

> Please do remember to add a Signed-off-by: for kernel patches.
> 

o.k. Sorry about that.
