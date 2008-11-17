Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYKQAKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYKQAKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 19:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYKQAKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 19:10:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57995 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYKQAKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 19:10:20 -0500
Date: Mon, 17 Nov 2008 09:09:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] memcontrol: use simple_malloc()/simple_free()
Message-Id: <20081117090938.0cdb531e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081116045404.GC24624@x200.localdomain>
References: <491FA2AA.6060706@cn.fujitsu.com>
	<20081116045128.GB24624@x200.localdomain>
	<20081116045404.GC24624@x200.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 07:54:04 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sun, Nov 16, 2008 at 07:51:28AM +0300, Alexey Dobriyan wrote:
> > On Sun, Nov 16, 2008 at 12:33:46PM +0800, Lai Jiangshan wrote:
> > > use simple_malloc()/simple_free() instead of current codes.
> > 
> > struct mem_cgroup can't reach the size when kmalloc starts failing.
> 
> Or it probably can with big NR_CPUS.
> 
> 	struct mem_cgroup_stat {
>   	      struct mem_cgroup_stat_cpu cpustat[NR_CPUS];
> 	};

It's now changed. see mmotm.

Thanks,
-Kame
> 
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -1062,11 +1062,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
> > >  {
> > >  	struct mem_cgroup *mem;
> > >  
> > > -	if (sizeof(*mem) < PAGE_SIZE)
> > > -		mem = kmalloc(sizeof(*mem), GFP_KERNEL);
> > > -	else
> > > -		mem = vmalloc(sizeof(*mem));
> > > -
> > > +	mem = simple_malloc(sizeof(*mem));
> > >  	if (mem)
> > >  		memset(mem, 0, sizeof(*mem));
> > >  	return mem;
> > > @@ -1074,10 +1070,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
> > >  
> > >  static void mem_cgroup_free(struct mem_cgroup *mem)
> > >  {
> > > -	if (sizeof(*mem) < PAGE_SIZE)
> > > -		kfree(mem);
> > > -	else
> > > -		vfree(mem);
> > > +	simple_free(mem);
> > >  }
> 

