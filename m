Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZCLDrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZCLDrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 23:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZCLDrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 23:47:00 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55890 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZCLDrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:47:00 -0400
Date: Thu, 12 Mar 2009 09:16:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/5] memcg softlimit (Another one) v4
Message-ID: <20090312034647.GA23583@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 09:52:47]:

> Hi, this is a patch for implemnt softlimit to memcg.
> 
> I did some clean up and bug fixes. 
> 
> Anyway I have to look into details of "LRU scan algorithm" after this.
> 
> How this works:
> 
>  (1) Set softlimit threshold to memcg.
>      #echo 400M > /cgroups/my_group/memory.softlimit_in_bytes.
> 
>  (2) Define priority as victim.
>      #echo 3 > /cgroups/my_group/memory.softlimit_priority.
>      0 is the lowest, 8 is the highest.
>      If "8", softlimit feature ignore this group.
>      default value is "8".
> 
>  (3) Add some memory pressure and make kswapd() work.
>      kswapd will reclaim memory from victims paying regard to priority.
> 
> Simple test on my 2cpu 86-64 box with 1.6Gbytes of memory (...vmware)
> 
>   While a process malloc 800MB of memory and touch it and sleep in a group,
>   run kernel make -j 16 under a victim cgroup with softlimit=300M, priority=3.
> 
>   Without softlimit => 400MB of malloc'ed memory are swapped out.
>   With softlimit    =>  80MB of malloc'ed memory are swapped out. 
> 
> I think 80MB of swap is from direct memory reclaim path. And this
> seems not to be terrible result.
> 
> I'll do more test on other hosts. Any comments are welcome.
>

I've tested so far by

Creating two cgroups and then 

a. Assigning limits of 1G and 2G and run memory allocation and touch
test
b. Same as (a) with 1G and 1G
c. Same as (a) with 0 and 1G
d. Same as (a) with 0 and 0

More comments in induvidual patches.

-- 
	Balbir
