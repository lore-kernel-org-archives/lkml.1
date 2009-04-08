Return-Path: <linux-kernel-owner+w=401wt.eu-S1762117AbZDHHMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762117AbZDHHMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZDHHLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:11:50 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39927 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZDHHLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:11:49 -0400
Date: Wed, 8 Apr 2009 12:41:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       Rik van Riel <riel@surriel.com>, Bharata B Rao <bharata.rao@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFI] Shared accounting for memory resource controller
Message-ID: <20090408071115.GD7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090407063722.GQ7082@balbir.in.ibm.com> <20090407160014.8c545c3c.kamezawa.hiroyu@jp.fujitsu.com> <20090407071825.GR7082@balbir.in.ibm.com> <20090407163331.8e577170.kamezawa.hiroyu@jp.fujitsu.com> <20090407080355.GS7082@balbir.in.ibm.com> <20090407172419.a5f318b9.kamezawa.hiroyu@jp.fujitsu.com> <20090408052904.GY7082@balbir.in.ibm.com> <20090408151529.fd6626c2.kamezawa.hiroyu@jp.fujitsu.com> <20090408070401.GC7082@balbir.in.ibm.com> <20090408160733.4813cb8d.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090408160733.4813cb8d.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-08 16:07:33]:

> On Wed, 8 Apr 2009 12:34:01 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-08 15:15:29]:
> > 
> > > On Wed, 8 Apr 2009 10:59:04 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > 
> > > > > no serious intention.
> > > > > Just because you wrote "expect the user to account all cached pages as shared" ;)
> > > > >
> > > > 
> > > > OK, I noticed another thing, our RSS accounting is not RSS per-se, it
> > > > includes only anon RSS, file backed pages are accounted as cached.
> > > > I'll send out a patch to see if we can include anon RSS as well.
> > > >  
> > > 
> > > I think we can't do it in memcg layer without new-hook because file caches
> > > are added to radix-tree before mapped.
> > > 
> > > mm struct has anon_rss and file_rss coutners. Then, you can show
> > > sum of total maps of file pages. maybe.
> > >
> > 
> > Yes, correct and that is a hook worth adding, IMHO. Better statistics
> > are critical and it will also help us with the shared memory
> > accounting. Without that we can't account for file rss in the memory
> > cgroup. 
> > 
> Finally, you'll be asked  "is it necessary ?", if the cost is big.
> >From my point of view, I can't see what new information it will give us.
> But maybe useful because the user can avoid some calculation.

OK, here is what I see

1. First our rss in memory.stat is confusing, we should call it anon
RSS
2. We need to add file rss, this is sort of inline with the
information we export per process file_rss and anon_rss
3. Using the above, we can then try to (using an algorithm you
proposed), try to do some work for figuring out the shared percentage.

-- 
	Balbir
