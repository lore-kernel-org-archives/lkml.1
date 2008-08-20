Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYHTDpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYHTDpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 23:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYHTDpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 23:45:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51031 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbYHTDpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 23:45:41 -0400
Date: Wed, 20 Aug 2008 12:51:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp
Subject: Re: [PATCH -mm][preview] memcg: a patch series for next [0/9]
Message-Id: <20080820125152.84f3409a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48AB8FEA.8000006@linux.vnet.ibm.com>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
	<48AB8FEA.8000006@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 09:00:50 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > Hi, 
> > 
> > This post is for showing what I'm trying now.
> > 
> > This patch set is for memory resource controller.
> > 4 purposes here.
> >   - improve performance of memcg.
> >   - remove lock_page_cgroup()
> >   - making page_cgroup->flags to be atomic_ops.
> >   - support mem+swap controller.
> > 
> > But this is still under test and the series is not well organised.
> > and base tree is old. (2.6.27-rc1-mm1) I'll rebase this set to newer mmtom tree.
> > 
> > Maybe this set have some troubles/objections but I think the direction is not bad.
> > 
> > Patch description. (patch ordering is bad. I'll fix in the next post.)
> > 
> > [1/9] ... private_counter ...replace res_counter with my own counter.
> >           This is for supporting mem+swap controller.
> >           (And I think memcg has a bit different characteristics from other
> >            users of res_counter....)
> > 
> > [2/9] ... change-order-uncharge ...
> >           This patch is for making it easy to handle swap-cache.
> > 
> > [3/9] ... atomic_flags
> >           This patch changes operations for page_cgroup->flags to be atomic_ops.
> > 
> > [4/9] ... delayed freeing.
> >           delaying to free page_cgroup at uncharge.
> > 
> > [5/9] ... RCU freeing of page_cgroup
> >           free page_cgroup by RCU.
> > 
> > [6/9] ... lockress page cgroup.
> >           remove lock_page_cgroup() and use RCU semantics.
> > 
> > [7/9] ... add preftech
> >           add prefetch() macro
> > 
> > [8/9] ... mem+swap controller base.
> >           introduce mem+swap controller. A bit big patch....but have tons of TODO.
> >           and have troubles. (it seems it's difficult to cause OOM killer.)
> > 
> > [9/9] ... mem+swap controller control files.
> >           add mem+swap controller's control files.
> > 
> > I'd like to push patch [2,3,4,5,6,7] first.
> > 
> 
> I took a quick look at the patches, patch 1 seemed not so clear, why can't we
> enhance or fix resource counters? I'll review/test the patches tonight.
> 
patch 1 is for patch 8. (patch order is too bad.)
please ignore this version. this is just a preview.(Sorry)

I'm now writing easier-to-read one,

thanks,
-kame





> -- 
> 	Balbir
> 

