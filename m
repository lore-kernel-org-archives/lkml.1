Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYB0FJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYB0FJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 00:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYB0FJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 00:09:25 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:47868 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbYB0FJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 00:09:25 -0500
Message-ID: <47C4EF2D.90508@linux.vnet.ibm.com>
Date: Wed, 27 Feb 2008 10:33:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20071129)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
References: <20080227133850.4249.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080227140042.66abb805.kamezawa.hiroyu@jp.fujitsu.com> <20080227140221.424C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080227140221.424C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
> 
>>> I don't think so.
>>> all modern many cpu machine stand on NUMA.
>>> it mean following,
>>>  - if cpu increases, then zone increases, too.
>>>
>>> if default value increase by #cpus, lock contension dramatically increase
>>> on large numa.
>>>
>>> Have I overlooked anything?
>>>
>> How about adding something like..
>> == 
>> CONFIG_SIMULTANEOUS_PAGE_RECLAIMERS 
>> int
>> default 3
>> depends on DEBUG
>> help
>>   This value determines the number of threads which can do page reclaim
>>   in a zone simultaneously. If this is too big, performance under heavy memory
>>   pressure will decrease.
>>   If unsure, use default.
>> ==
>>
>> Then, you can get performance reports from people interested in this
>> feature in test cycle.
> 
> hm, intersting.
> but sysctl parameter is more better, i think.
> 
> OK, I'll add it at next post.

I think sysctl should be interesting. The config option provides good
documentation, but it is static in nature (requires reboot to change). I wish we
could have the best of both worlds.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
