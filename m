Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbYLPDxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbYLPDxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 22:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYLPDxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 22:53:00 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:55744 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYLPDw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 22:52:59 -0500
Date: Tue, 16 Dec 2008 09:22:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Subject: Re: [BUG][PANIC] cgroup panics with mmotm for 2.6.28-rc7
Message-ID: <20081216035253.GC25456@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Li Zefan <lizf@cn.fujitsu.com>,
	Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
	Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	Sudhir Kumar <skumar@linux.vnet.ibm.com>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Bharata B Rao <bharata.rao@in.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	libcg-devel <libcg-devel@lists.sourceforge.net>
References: <20081215113253.GL18403@balbir.in.ibm.com> <6599ad830812151757t5362ae16y81b469b06022135c@mail.gmail.com> <49471540.8090304@cn.fujitsu.com> <4947183C.6010606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4947183C.6010606@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> [2008-12-16 10:53:48]:

> Li Zefan wrote:
> > Paul Menage wrote:
> >> That implies that we ran out of css_set objects when moving the task
> >> into the new cgroup.
> >>
> >> Did you have all of the configured controllers mounted, or just a subset?
> >>
> >> What date was this mmotm? Was it after Li's patch fixes went in on 8th Dec?
> >>
> > 
> > It is probably my fault. :( I'm looking into this problem.
> > 
> > There are 2 related cleanup patches in -mm:
> > 
> > cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch (and -fix.patch)
> > cgroups-introduce-link_css_set-to-remove-duplicate-code.patch (and -fix.patch)
> > 
> > If the bug is reproducable, could you revert the above patches and seee if the
> > bug is still there.
> > 
> >> Paul
> >>
> >> On Mon, Dec 15, 2008 at 3:32 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >>> Hi, Paul,
> >>>
> >>> I see the following stack trace when I run my tests. I've not yet
> >>> investigated the problem.
> >>>
> >>> ------------[ cut here ]------------
> >>> kernel BUG at kernel/cgroup.c:392!
> 
> In latest -mm, this BUG_ON is line 398, and before the below 2 fixlet patches,
> the BUG_ON is line 392, so I guess you were using older -mm:
> 
> cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
> cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
> 
> Could you try the latest -mm kernel, or apply
> cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch ?
> 
> diff -puN kernel/cgroup.c~cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix kernel/cgroup.c
> --- a/kernel/cgroup.c~cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix
> +++ a/kernel/cgroup.c
> @@ -2521,7 +2521,7 @@ static void __init cgroup_init_subsys(st
>  	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
> 
>  	/* Create the top cgroup state for this subsystem */
> -	list_add(&ss->sibling, &rootnode.root_list);
> +	list_add(&ss->sibling, &rootnode.subsys_list);
>  	ss->root = &rootnode;
>  	css = ss->create(ss, dummytop);
>  	/* We don't handle early failures gracefully */
>

I'll move to the latest mm and make sure your fix is present. 

-- 
	Balbir
