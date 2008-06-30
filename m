Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbYF3B5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbYF3B5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 21:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYF3B5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 21:57:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34200 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYF3B5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 21:57:31 -0400
Date: Mon, 30 Jun 2008 11:02:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC 0/5] Memory controller soft limit introduction (v3)
Message-Id: <20080630110241.82bdd5b0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080630105006.a7bb6529.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080627151808.31664.36047.sendpatchset@balbir-laptop>
	<20080628133615.a5fa16cf.kamezawa.hiroyu@jp.fujitsu.com>
	<4867174B.3090005@linux.vnet.ibm.com>
	<20080630102054.ee214765.kamezawa.hiroyu@jp.fujitsu.com>
	<20080630105006.a7bb6529.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 10:50:06 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:


> ==
>                 if (scan_global_lru(sc)) {
>                         if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
>                                 continue;
>                         note_zone_scanning_priority(zone, priority);
> 
>                         if (zone_is_all_unreclaimable(zone) &&
>                                                 priority != DEF_PRIORITY)
>                                 continue;       /* Let kswapd poll it */
>                         sc->all_unreclaimable = 0;
>                 } else {
>                         /*
>                          * Ignore cpuset limitation here. We just want to reduce
>                          * # of used pages by us regardless of memory shortage.
>                          */
>                         sc->all_unreclaimable = 0;
>                         mem_cgroup_note_reclaim_priority(sc->mem_cgroup,
>                                                         priority);
>                 }
> ==
> 
> First point is (maybe) my mistake. We have to add cpuset hardwall check to memcg
> part. (I will write a patch soon.)
> 

I found my comment seems to say some correct thing..
==
 /*
  * Ignore cpuset limitation here. We just want to reduce
  * # of used pages by us regardless of memory shortage.
  */
==
When we handle memory shortage, we'll have to change this mind.

But I can think of another example easily...
==
  MemcgA: limit=1G
  CpusetX: mem=0
  CpusetY: mem=1
  taskP = MemcgA+CpusetX
  taskQ = MemcgA+CpusetY
==
In this case, we just want to reduce the usage of memory....nonsense ?

Hmm..I should refresh my brain and revisit this later.
Any inputs are welcome.

Thanks,
-Kame




