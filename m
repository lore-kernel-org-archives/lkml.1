Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZE2Gz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZE2Gz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 02:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZE2GzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 02:55:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54796 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZE2GzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 02:55:15 -0400
Date: Fri, 29 May 2009 15:53:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] add swap cache interface for swap reference v2
 (updated)
Message-Id: <20090529155342.7fcead51.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090529150525.cbbb4be1.nishimura@mxp.nes.nec.co.jp>
References: <20090528135455.0c83bedc.kamezawa.hiroyu@jp.fujitsu.com>
	<20090528141049.cc45a116.kamezawa.hiroyu@jp.fujitsu.com>
	<20090529132153.3a72f2c3.nishimura@mxp.nes.nec.co.jp>
	<20090529140832.1f4b288b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090529143758.4c3db3eb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090529150525.cbbb4be1.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 15:05:25 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Fri, 29 May 2009 14:37:58 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Fri, 29 May 2009 14:08:32 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > IIUC, swap_free() at the end of shmem_writepage() should also be changed to swapcache_free().
> > > > 
> > > Hmm!. Oh, yes. shmem_writepage()'s error path. Thank you. It will be fixed.
> > > 
> > here. 
> > 
> Looks good to me.
> 
> 	Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> 
> BTW, I'm now testing(with swap-in/out and swap-on/off) [2/4] of this patch set.
> I think this patch set would work well, but it's a big change to swap,
> so we should test them very carefully.
> 
Indeed. 

BTW, even we ignores memcg, they are necessary change for us. ([2/4] and [3/4])

IIUC, I remember a NEC man had a story like below.

1. create 2 cpusets. A and B.
2. At first, tons of swaps are created by "A".
3. After size of applications in A shrinks, pages swapped out by "A" is now on-memory.
4. When running program in B, B can't use enough swaps because "A" uses tons of
   cache-only swaps.

Why swap_entries are not reclaimed in "4" is because cpuset divides the LRU.

I think patch [3/4] can be a sliver bullet to this problem.

Thanks,
-Kame

