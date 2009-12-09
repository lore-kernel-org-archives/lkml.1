Return-Path: <linux-kernel-owner+w=401wt.eu-S1751435AbZLIFJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbZLIFJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZLIFJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:09:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43184 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZLIFJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:09:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Dec 2009 14:06:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, kosaki.motohiro@jp.fujitsu.com,
       hugh.dickins@tiscali.co.uk, nishimura@mxp.nes.nec.co.jp,
       balbir@linux.vnet.ibm.com, menage@google.com, npiggin@suse.de,
       fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [23/31] HWPOISON: add memory cgroup filter
Message-Id: <20091209140620.79785cf9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4B1F2FC6.7040406@cn.fujitsu.com>
References: <200912081016.198135742@firstfloor.org>
	<20091208211639.8499FB151F@basil.firstfloor.org>
	<4B1F2FC6.7040406@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Dec 2009 13:04:06 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> > +#ifdef	CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> > +u64 hwpoison_filter_memcg;
> > +EXPORT_SYMBOL_GPL(hwpoison_filter_memcg);
> > +static int hwpoison_filter_task(struct page *p)
> > +{
> > +	struct mem_cgroup *mem;
> > +	struct cgroup_subsys_state *css;
> > +	unsigned long ino;
> > +
> > +	if (!hwpoison_filter_memcg)
> > +		return 0;
> > +
> > +	mem = try_get_mem_cgroup_from_page(p);
> > +	if (!mem)
> > +		return -EINVAL;
> > +
> > +	css = mem_cgroup_css(mem);
> > +	ino = css->cgroup->dentry->d_inode->i_ino;
> 
> I have a question, can try_get_mem_cgroup_from_page() return
> root_mem_cgroup?
> 
yes.

> if it can, then css->cgroup->dentry is NULL, if memcg is
> not mounted and there is no subdir in memcg. Because the root
> cgroup of an inactive subsystem has no dentry.
> 

Nice catch. It sounds possible. That should be handled.

Regards,
-Kame

