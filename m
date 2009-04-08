Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbZDHHsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbZDHHsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761797AbZDHHsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:48:43 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:43906 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761765AbZDHHsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:48:41 -0400
Date: Wed, 8 Apr 2009 13:18:09 +0530
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
Message-ID: <20090408074809.GF7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090407071825.GR7082@balbir.in.ibm.com> <20090407163331.8e577170.kamezawa.hiroyu@jp.fujitsu.com> <20090407080355.GS7082@balbir.in.ibm.com> <20090407172419.a5f318b9.kamezawa.hiroyu@jp.fujitsu.com> <20090408052904.GY7082@balbir.in.ibm.com> <20090408151529.fd6626c2.kamezawa.hiroyu@jp.fujitsu.com> <20090408070401.GC7082@balbir.in.ibm.com> <20090408160733.4813cb8d.kamezawa.hiroyu@jp.fujitsu.com> <20090408071115.GD7082@balbir.in.ibm.com> <20090408161824.26f47077.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090408161824.26f47077.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-08 16:18:24]:

> On Wed, 8 Apr 2009 12:41:15 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-08 16:07:33]:
> > 1. First our rss in memory.stat is confusing, we should call it anon
> > RSS
> ok. but ....changing current interface ?
> 

No, lets just a new field called file_rss and make sure the
documentation reflects the correct information.

> > 2. We need to add file rss, this is sort of inline with the
> > information we export per process file_rss and anon_rss
> 
> maybe good. *but* active/incative ratio in lru file cache is good estimation for this.

Active/Inactive tell us about frequently a page is referenced rather
than what is mapped and what is not. We could get very bad results if
we make an assumption.

> 
> > 3. Using the above, we can then try to (using an algorithm you
> > proposed), try to do some work for figuring out the shared percentage.
> > 
> This is the point. At last. Why "# of shared pages" is important ?
> 

I posted this in my motivation yesterday. # of shared pages can help
plan the system better and the size of the cgroup. A cgroup might have
small usage_in_bytes but large number of shared pages. We need a
metric that can help figure out the fair usage of the cgroup.

> I wonder it's better to add new stat file as memory.cacheinfo which helps
> following kind of commands.
> 
>   #cacheinfo /cgroups/memory/group01/
>        /usr/lib/libc.so.1     30pages
>        /var/log/messages      1 pages
>        /tmp/xxxxxx            20 pages
>        .....
>        .....
>

But, what I need at the moment is shared usage information.

-- 
	Balbir
