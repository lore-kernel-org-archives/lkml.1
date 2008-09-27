Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbYI0DTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbYI0DTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 23:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYI0DSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 23:18:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59006 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYI0DSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 23:18:54 -0400
Date: Sat, 27 Sep 2008 12:25:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
Message-Id: <20080927122530.29e02ba8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080926104336.d96ab5bd.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com>
	<20080926100022.8bfb8d4d.nishimura@mxp.nes.nec.co.jp>
	<20080926104336.d96ab5bd.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008 10:43:36 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > > -	VM_BUG_ON(pc->page != page);
> > > +	pc = lookup_page_cgroup(page);
> > > +	if (unlikely(!pc || !PageCgroupUsed(pc)))
> > > +		return;
> > > +	preempt_disable();
> > > +	lock_page_cgroup(pc);
> > > +	if (unlikely(page_mapped(page))) {
> > > +		unlock_page_cgroup(pc);
> > > +		preempt_enable();
> > > +		return;
> > > +	}
> > Just for clarification, in what sequence will the page be mapped here?
> > mem_cgroup_uncharge_page checks whether the page is mapped.
> > 

I think I saw page_mapped() case (in your shmem/page test.)
I'll check what cause this if I have time.

Thanks,
-Kame

