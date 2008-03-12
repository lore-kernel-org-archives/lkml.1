Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbYCLJFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbYCLJFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 05:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYCLJFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 05:05:03 -0400
Received: from sacred.ru ([62.205.161.221]:56724 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbYCLJFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 05:05:00 -0400
Message-ID: <47D79CA4.5090102@openvz.org>
Date: Wed, 12 Mar 2008 12:04:36 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add the max_usage member on the res_counter
References: <47D69D72.5040304@openvz.org> <20080311214034.d2cae354.akpm@linux-foundation.org>
In-Reply-To: <20080311214034.d2cae354.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 12 Mar 2008 12:04:37 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 11 Mar 2008 17:55:46 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> This field is the maximal value of the usage one since the counter
>> creation (or since the latest reset).
>>
>> To reset this to the usage value simply write anything to the
>> appropriate cgroup file.
> 
> What is the justification for making this change?  Why do we need it? 

The max_usage value is useful when gathering a statistical information
about the particular group, as it shows the actual memory requirements 
for a particular group, not just some usage snapshot.

E.g. this value can be used to quickly tune the group. OpenVZ users often
set the limits to maximal values and either load the container with a common
patterns or leave one for a while. After this the max_usage value shows the 
amount of memory the container would require during its common activity. 
Setting the limit a bit above this value gives a pretty good configuration, 
that works in the most cases.

But, please see my second comment.

> Please provide this information for all patches where it is not obvious.
> 
>>  	{
>> +		.name = "max_usage_in_bytes",
>> +		.private = RES_MAX_USAGE,
>> +		.write = mem_cgroup_max_reset,
>> +		.read_u64 = mem_cgroup_read,
>> +	},
> 
> Documentation/controllers/memory.txt needs updating.
> 

I'm preparing the Documentation/controllers/resource_counter.txt file
that will describe this abstraction. Since this one can be used for
many other resources (swap, kernel memory, networking, etc) this will
also eliminate all the possible future duplications in the appropriate
docs.

The above explanation of the max_usage attribute will be included in
this doc. Should it still be included in the previous patch's comment or
in the patch _as_a_ comment?
