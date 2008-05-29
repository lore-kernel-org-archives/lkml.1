Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYE2CcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYE2CcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 22:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYE2CcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 22:32:08 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:47126 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbYE2CcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 22:32:07 -0400
Message-ID: <483E155E.9050300@linux.vnet.ibm.com>
Date: Thu, 29 May 2008 08:00:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] No Reclaim LRU Infrastructure enhancement for memcgroup
References: <1211903642.7283.16.camel@lts-notebook> <20080528101229.f14e0f09.kamezawa.hiroyu@jp.fujitsu.com> <20080528155809.9CD0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080528155809.9CD0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
> 
>> In my understanding, 2 checks we have to do.
>>
>> 1. When memcg finds PG_noreclaim page in its LRU, move it to noreclaim list of
>>    memcg.
>> 2. When PG_noreclaim page is moved back to generic LRU, memcg should move
>>    it on its list. (we have to add a hook somewhere.)
>>
>> But this may break current 'loose' synchronization between global LRU and
>> memcg's LRU. When PG_noreclaim page is put back into active/inactive LRU ?
>>
>> concerns are
>> A. how to implement '2'
> 
> I tried to implement it today.
> this patch is made against "[PATCH -mm 13/16] No Reclaim LRU Infrastructure"
> 
> 
>> B. race condtions.
> 
> don't worry :)
> it isn't big problem.
> 
> global lru is reclaimbale and memcg lru is noreclaimable
> 	-> we can repair at move lru of shrink_[in]active_page().
> 
> global lru is noreclaimbale and memcg lru is reclaimable
> 	-> we can repair mem_cgroup_isolate_pages()
> 
> 

I've tried these patches and I still get OOM killed. I'll investigate a bit more.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
