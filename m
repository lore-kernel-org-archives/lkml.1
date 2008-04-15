Return-Path: <linux-kernel-owner+w=401wt.eu-S1764315AbYDODTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764315AbYDODTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 23:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762022AbYDODTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 23:19:31 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35316 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761823AbYDODTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 23:19:30 -0400
Date: Tue, 15 Apr 2008 12:22:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>, menage@google.com,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use vmalloc for mem_cgroup allocation. v2
Message-Id: <20080415122220.748834b7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48041D90.2040702@cn.fujitsu.com>
References: <20080415105434.3044afb6.kamezawa.hiroyu@jp.fujitsu.com>
	<20080415111038.ffac0e12.kamezawa.hiroyu@jp.fujitsu.com>
	<20080414191730.7d13e619.akpm@linux-foundation.org>
	<20080415121617.16127623.kamezawa.hiroyu@jp.fujitsu.com>
	<48041D90.2040702@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 11:14:24 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Mon, 14 Apr 2008 19:17:30 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >> Well...  vmalloced memory is of course a little slower to use - additional
> >> TLB pressure.
> >>
> >> Do you think the memcgroup is accessed frequently enough to use vmalloc()
> >> only on those architectures which actually need it?
> >>
> >> Because it'd be pretty simple to implement:
> >>
> >> 	if (sizeof(struct mem_group) > PAGE_SIZE)
> >> 		vmalloc()
> >> 	else
> >> 		kmalloc()
> >>
> >> 	...
> >>
> >> 	if (sizeof(struct mem_group) > PAGE_SIZE)
> >> 		vfree()
> >> 	else
> >> 		kfree()
> >>
> >> the compiler will optimise away the `if'.
> >>
> > 
> > Hmm, ok. I'll rewrite one to do that.
> > 
> 
> It will be better to use wrappers for these: mem_cgroup_alloc() and mem_cgroup_free()
> 
yes. will do

-Kame
> > Thanks,
> > -Kame
> > 
> > 
> > 
> 

