Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbXAWDSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbXAWDSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 22:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXAWDSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 22:18:52 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:58183 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXAWDSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 22:18:52 -0500
Message-ID: <45B57E73.3000307@in.ibm.com>
Date: Tue, 23 Jan 2007 08:48:11 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrea Arcangeli <andrea@suse.de>, Niki Hammler <mailinglists@nobaq.net>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com> <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 23 Jan 2007, Balbir Singh wrote:
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
> This means page cache = unmapped file backed page right? Otherwise this
> would not work. I always thought that the page cache were all file backed
> pages both mapped and unmapped.
> 

Yes, unfortunately my terminology was not clear. I mean unmapped file
backed pages.

> With the proposed schemd you would have to move pages between lists if
> they are mapped and unmapped by a process. Terminating a process could
> lead to lots of pages moving to the unnmapped list.
> 

When you unmap or map, you need to touch the pte entries and know the
pages involved, so shouldn't be equivalent to a list_del and list_add
for each page impacted by the map/unmap operation?

-- 
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
