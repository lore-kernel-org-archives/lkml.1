Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZDXMZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZDXMZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbZDXMZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:25:35 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:44824 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZDXMZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:25:34 -0400
Date: Fri, 24 Apr 2009 17:54:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/9] memcg soft limit v2 (new design)
Message-ID: <20090424122441.GD3944@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-03 17:08:35]:

> Hi,
> 
> Memory cgroup's soft limit feature is a feature to tell global LRU 
> "please reclaim from this memcg at memory shortage".
> 
> This is v2. Fixed some troubles under hierarchy. and increase soft limit
> update hooks to proper places.
> 
> This patch is on to
>   mmotom-Mar23 + memcg-cleanup-cache_charge.patch
>   + vmscan-fix-it-to-take-care-of-nodemask.patch
> 
> So, not for wide use ;)
> 
> This patch tries to avoid to use existing memcg's reclaim routine and
> just tell "Hints" to global LRU. This patch is briefly tested and shows
> good result to me. (But may not to you. plz brame me.)
> 
> Major characteristic is.
>  - memcg will be inserted to softlimit-queue at charge() if usage excess
>    soft limit.
>  - softlimit-queue is a queue with priority. priority is detemined by size
>    of excessing usage.
>  - memcg's soft limit hooks is called by shrink_xxx_list() to show hints.
>  - Behavior is affected by vm.swappiness and LRU scan rate is determined by
>    global LRU's status.
> 
> In this v2.
>  - problems under use_hierarchy=1 case are fixed.
>  - more hooks are added.
>  - codes are cleaned up.
>

The results seem good so far with some basic tests I've been doing.
I'll come back with more feedback, I would like to see this feature in
-mm soon.

-- 
	Balbir
