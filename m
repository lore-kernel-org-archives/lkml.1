Return-Path: <linux-kernel-owner+w=401wt.eu-S1759099AbYHEKrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099AbYHEKrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 06:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYHEKq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 06:46:59 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:51567 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYHEKq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 06:46:58 -0400
Message-ID: <48982F9E.2080100@linux.vnet.ibm.com>
Date: Tue, 05 Aug 2008 16:16:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Race condition between putback_lru_page and mem_cgroup_move_list
References: <2f11576a0808040937y70f274e0j32f6b9c98b0f992d@mail.gmail.com> <489741F8.2080104@linux.vnet.ibm.com> <20080805151956.A885.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080805151956.A885.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi Balbir-san,
> 
>>> I also think zone's lru lock is unnecessary.
>>> So, I guess below "it" indicate lock_page_cgroup, not zone lru lock.
>> We need zone LRU lock, since the reclaim paths hold them. Not sure if I
>> understand why you call zone's LRU lock unnecessary, could you elaborate please?
> 
> I tought..
> 
> 1. in general, one data structure should be protected by one lock.

In general yes, but in practice no. We have different paths through which a page
can be reclaimed. Consider the following

1. What happens if a global reclaim is in progress at the same time as memory
cgroup reclaim and they are both looking at the same page?
2. In the shared reclaim infrastructure, we move pages and update statistics for
pages belonging to a particular zone in a particular cgroup.

>> It's on my TODO list. I hope to get to it soon.
> 
> Very good news!

I hope they show the benefit that I expect them too :)

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
