Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbZBDF0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbZBDF0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbZBDF0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:26:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51724 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZBDF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:26:12 -0500
Date: Wed, 4 Feb 2009 14:24:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM (v3)
Message-Id: <20090204142455.83c38ad6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090204033750.GB4456@balbir.in.ibm.com>
References: <20090203172135.GF918@balbir.in.ibm.com>
	<4988E727.8030807@cn.fujitsu.com>
	<20090204033750.GB4456@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 09:07:50 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > > +}
> > > +
> > >  #endif /* CONFIG_CGROUP_MEM_CONT */
> > >  
> > 
> > > +void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
> > > +{
> > > +	struct cgroup *task_cgrp;
> > > +	struct cgroup *mem_cgrp;
> > > +	/*
> > > +	 * Need a buffer on stack, can't rely on allocations. The code relies
> > 
> > I think it's in .bss section, but not on stack, and it's better to explain why
> > the static buffer is safe in the comment.
> >
> 
> Yes, it is no longer on stack, in the original patch it was. I'll send
> an updated patch 
> 
In the newest mmotm, OOM kill message is following.
==
Feb  4 13:16:28 localhost kernel: [  249.338911] malloc2 invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Feb  4 13:16:28 localhost kernel: [  249.339018] malloc2 cpuset=/ mems_allowed=0
Feb  4 13:16:28 localhost kernel: [  249.339023] Pid: 3459, comm: malloc2 Not tainted 2.6.29-rc3-mm1 #1
Feb  4 13:16:28 localhost kernel: [  249.339185] Call Trace:
Feb  4 13:16:28 localhost kernel: [  249.339202]  [<ffffffff8148dda6>] ? _spin_unlock+0x26/0x2a
Feb  4 13:16:28 localhost kernel: [  249.339210]  [<ffffffff8108d48d>] oom_kill_process+0x99/0x272
Feb  4 13:16:28 localhost kernel: [  249.339214]  [<ffffffff8108d918>] ? select_bad_process+0x9d/0xfa
Feb  4 13:16:28 localhost kernel: [  249.339219]  [<ffffffff8108dc8f>] mem_cgroup_out_of_memory+0x65/0x82
Feb  4 13:16:28 localhost kernel: [  249.339224]  [<ffffffff810bd457>] __mem_cgroup_try_charge+0x14c/0x196
Feb  4 13:16:28 localhost kernel: [  249.339229]  [<ffffffff810bdffa>] mem_cgroup_charge_common+0x47/0x72
Feb  4 13:16:28 localhost kernel: [  249.339234]  [<ffffffff810be063>] mem_cgroup_newpage_charge+0x3e/0x4f
Feb  4 13:16:28 localhost kernel: [  249.339239]  [<ffffffff810a05f9>] handle_mm_fault+0x214/0x761
Feb  4 13:16:28 localhost kernel: [  249.339244]  [<ffffffff8149062d>] do_page_fault+0x248/0x25f
Feb  4 13:16:28 localhost kernel: [  249.339249]  [<ffffffff8148e64f>] page_fault+0x1f/0x30
Feb  4 13:16:28 localhost kernel: [  249.339260] Task in /group_A/01 killed as a result of limit of /group_A
Feb  4 13:16:28 localhost kernel: [  249.339264] memory: usage 39168kB, limit 40960kB, failcnt 1
Feb  4 13:16:28 localhost kernel: [  249.339266] memory+swap: usage 40960kB, limit 40960kB, failcnt 15
==
Task in /group_A/01 is killed by mem+swap limit of /group_A. 

Yeah, very nice look :) thank you.

BTW, I wonder can't we show the path of mount point ?
/group_A/01 is /cgroup/group_A/01 and /group_A/ is /cgroup/group_A/ on this system.
Very difficult ?

Thanks,
-Kame







