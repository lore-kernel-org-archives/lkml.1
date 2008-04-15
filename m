Return-Path: <linux-kernel-owner+w=401wt.eu-S1764491AbYDODX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764491AbYDODX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 23:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762237AbYDODXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 23:23:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43818 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762162AbYDODXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 23:23:49 -0400
Date: Tue, 15 Apr 2008 12:12:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>, menage@google.com,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use vmalloc for mem_cgroup allocation. v2
Message-Id: <20080415121248.c1318b1b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080414192042.c50d8d58.akpm@linux-foundation.org>
References: <20080415105434.3044afb6.kamezawa.hiroyu@jp.fujitsu.com>
	<20080415111038.ffac0e12.kamezawa.hiroyu@jp.fujitsu.com>
	<48040E19.2090007@cn.fujitsu.com>
	<20080414192042.c50d8d58.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 19:20:42 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 15 Apr 2008 10:08:25 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > > @@ -992,8 +993,10 @@ mem_cgroup_create(struct cgroup_subsys *
> > >  	if (unlikely((cont->parent) == NULL)) {
> > >  		mem = &init_mem_cgroup;
> > >  		page_cgroup_cache = KMEM_CACHE(page_cgroup, SLAB_PANIC);
> > > -	} else
> > > -		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
> > > +	} else {
> > > +		mem = vmalloc(sizeof(struct mem_cgroup));
> > > +		memset(mem, 0, sizeof(*mem));
> > 
> > what if mem == NULL. ;)
> > 
> > > +	}
> > >  
> > >  	if (mem == NULL)
> > >  		return ERR_PTR(-ENOMEM);
> > 
> > So we can move this NULL check to the above else branch, in the if brach,
> > mem won't be NULL.
> 
> err, yes.
> 
> So I have:
> 
> 	if (unlikely((cont->parent) == NULL)) {
> 		mem = &init_mem_cgroup;
> 		page_cgroup_cache = KMEM_CACHE(page_cgroup, SLAB_PANIC);
> 	} else {
> 		mem = vmalloc(sizeof(struct mem_cgroup));
> 		if (mem == NULL)
> 			return ERR_PTR(-ENOMEM);
> 		memset(mem, 0, sizeof(*mem));
> 	}
> 
Sorry for poor patch....
And thank you for catching.

Thanks,
-Kame


