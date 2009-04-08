Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbZDHHFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbZDHHFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761143AbZDHHEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:04:46 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:60635 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761066AbZDHHEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:04:45 -0400
Date: Wed, 8 Apr 2009 12:34:01 +0530
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
Message-ID: <20090408070401.GC7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090407063722.GQ7082@balbir.in.ibm.com> <20090407160014.8c545c3c.kamezawa.hiroyu@jp.fujitsu.com> <20090407071825.GR7082@balbir.in.ibm.com> <20090407163331.8e577170.kamezawa.hiroyu@jp.fujitsu.com> <20090407080355.GS7082@balbir.in.ibm.com> <20090407172419.a5f318b9.kamezawa.hiroyu@jp.fujitsu.com> <20090408052904.GY7082@balbir.in.ibm.com> <20090408151529.fd6626c2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090408151529.fd6626c2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-08 15:15:29]:

> On Wed, 8 Apr 2009 10:59:04 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> 
> > > no serious intention.
> > > Just because you wrote "expect the user to account all cached pages as shared" ;)
> > >
> > 
> > OK, I noticed another thing, our RSS accounting is not RSS per-se, it
> > includes only anon RSS, file backed pages are accounted as cached.
> > I'll send out a patch to see if we can include anon RSS as well.
> >  
> 
> I think we can't do it in memcg layer without new-hook because file caches
> are added to radix-tree before mapped.
> 
> mm struct has anon_rss and file_rss coutners. Then, you can show
> sum of total maps of file pages. maybe.
>

Yes, correct and that is a hook worth adding, IMHO. Better statistics
are critical and it will also help us with the shared memory
accounting. Without that we can't account for file rss in the memory
cgroup. 

-- 
	Balbir
