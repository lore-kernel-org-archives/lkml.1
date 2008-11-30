Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYK3QJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYK3QJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 11:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYK3QJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 11:09:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55317 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbYK3QJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 11:09:08 -0500
Message-ID: <4932BA80.3060708@redhat.com>
Date: Sun, 30 Nov 2008 11:08:32 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 04/09] memcg: make zone_reclaim_stat
References: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081130195731.8151.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081130195731.8151.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> @@ -172,6 +173,10 @@ void activate_page(struct page *page)
>  
>  		reclaim_stat->recent_rotated[!!file]++;
>  		reclaim_stat->recent_scanned[!!file]++;
> +
> +		memcg_reclaim_stat = mem_cgroup_get_reclaim_stat_by_page(page);
> +		memcg_reclaim_stat->recent_rotated[!!file]++;
> +		memcg_reclaim_stat->recent_scanned[!!file]++;

Also, manipulation of the zone based reclaim_stats happens
under the lru lock.

What protects the memcg reclaim stat?

-- 
All rights reversed.
