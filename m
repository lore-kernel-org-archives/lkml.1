Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbZLIFdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbZLIFdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZLIFdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:33:38 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:51957 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZLIFdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:33:37 -0500
Date: Wed, 9 Dec 2009 11:03:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andi Kleen <andi@firstfloor.org>,
       kosaki.motohiro@jp.fujitsu.com, hugh.dickins@tiscali.co.uk,
       nishimura@mxp.nes.nec.co.jp, menage@google.com, npiggin@suse.de,
       fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [23/31] HWPOISON: add memory cgroup filter
Message-ID: <20091209053333.GC3722@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <200912081016.198135742@firstfloor.org>
 <20091208211639.8499FB151F@basil.firstfloor.org>
 <4B1F2FC6.7040406@cn.fujitsu.com>
 <20091209140620.79785cf9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091209140620.79785cf9.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-12-09 14:06:20]:

> On Wed, 09 Dec 2009 13:04:06 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > > +#ifdef	CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> > > +u64 hwpoison_filter_memcg;
> > > +EXPORT_SYMBOL_GPL(hwpoison_filter_memcg);
> > > +static int hwpoison_filter_task(struct page *p)
> > > +{
> > > +	struct mem_cgroup *mem;
> > > +	struct cgroup_subsys_state *css;
> > > +	unsigned long ino;
> > > +
> > > +	if (!hwpoison_filter_memcg)
> > > +		return 0;
> > > +
> > > +	mem = try_get_mem_cgroup_from_page(p);
> > > +	if (!mem)
> > > +		return -EINVAL;
> > > +
> > > +	css = mem_cgroup_css(mem);
> > > +	ino = css->cgroup->dentry->d_inode->i_ino;
> > 
> > I have a question, can try_get_mem_cgroup_from_page() return
> > root_mem_cgroup?
> > 
> yes.
> 
> > if it can, then css->cgroup->dentry is NULL, if memcg is
> > not mounted and there is no subdir in memcg. Because the root
> > cgroup of an inactive subsystem has no dentry.
> > 
> 
> Nice catch. It sounds possible. That should be handled.
> 
> 

Yes, agreed, good catch!

-- 
	Balbir
