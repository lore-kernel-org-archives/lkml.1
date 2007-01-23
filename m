Return-Path: <linux-kernel-owner+w=401wt.eu-S932999AbXAWFLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbXAWFLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933002AbXAWFLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:11:14 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:53925 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999AbXAWFLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:11:13 -0500
Message-ID: <45B59322.1070603@in.ibm.com>
Date: Tue, 23 Jan 2007 10:16:26 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrea Arcangeli <andrea@suse.de>, Niki Hammler <mailinglists@nobaq.net>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com> <45B58C5C.8010900@yahoo.com.au>
In-Reply-To: <45B58C5C.8010900@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Balbir Singh wrote:
> 
>> This makes me wonder if it makes sense to split up the LRU into page
>> cache LRU and mapped pages LRU. I see two benefits
>>
>> 1. Currently based on swappiness, we might walk an entire list
>>    searching for page cache pages or mapped pages. With these
>>    lists separated, it should get easier and faster to implement
>>    this scheme
>> 2. There is another parallel thread on implementing page cache
>>    limits. If the lists split out, we need not scan the entire
>>    list to find page cache pages to evict them.
>>
>> Of course I might be missing something (some piece of history)
> 
> I actually had patches to do "split active lists" a while back.
> 
> They worked by lazily moving the page at reclaim-time, based on
> whether or not it is mapped. This isn't too much worse than the
> kernel's current idea of what a mapped page is.
> 
> They actually got a noticable speedup of the swapping kbuild
> workload, but at this stage there were some more basic
> improvements needed, so the difference could be smaller today.
> 
> The other nice thing about it was that it didn't have a hard
> cutoff that the current reclaim_mapped toggle does -- you could
> opt to scan the mapped list at a lower ratio than the unmapped
> one. Of course, it also has some downsides too, and would
> require retuning...
> 

Thanks, I am motivated to experiment with the idea. I guess I need
to (re)discover the downsides for myself :-)

-- 
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
