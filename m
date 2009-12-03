Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZLCCUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZLCCUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 21:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZLCCU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 21:20:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:16088 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbZLCCU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 21:20:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="218208815"
Date: Thu, 3 Dec 2009 10:20:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, Nick Piggin <npiggin@suse.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/24] HWPOISON: add memory cgroup filter
Message-ID: <20091203022032.GB13587@localhost>
References: <20091202031231.735876003@intel.com> <20091202043046.519053333@intel.com> <20091202124446.GA18989@one.firstfloor.org> <20091202125842.GA13277@localhost> <4B171F35.1010908@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B171F35.1010908@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 10:15:17AM +0800, Li Zefan wrote:
> > +#ifdef	CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> > +u32 hwpoison_filter_memcg;
> > +static int hwpoison_filter_task(struct page *p)
> > +{
> > +	struct mem_cgroup *mem;
> > +	struct cgroup_subsys_state *css;
> > +
> > +	if (!hwpoison_filter_memcg)
> > +		return 0;
> > +
> > +	mem = try_get_mem_cgroup_from_page(p);
> > +	if (!mem)
> > +		return -EINVAL;
> > +
> > +	css = mem_cgroup_css(mem);
> > +	if (!css)
> > +		return -EINVAL;
> > +
> 
> Here, if mem != NULL, then css won't be NULL.

Good catch, thank you!

> > +	css_put(css);
> > +	return 0;
> > +}
