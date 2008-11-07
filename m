Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYKGOru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYKGOru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYKGOrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:47:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33421 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbYKGOrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:47:41 -0500
Date: Fri, 7 Nov 2008 09:44:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, Rik van Riel <riel@redhat.com>,
       fernando@oss.ntt.co.jp, Jeff Moyer <jmoyer@redhat.com>,
       menage@google.com, ngupta@google.com,
       Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com
Subject: Re: [patch 2/4] io controller: biocgroup implementation
Message-ID: <20081107144417.GE21884@redhat.com>
References: <20081106153022.215696930@redhat.com> <20081106153135.790621895@redhat.com> <20081107115030.7ccf3f07.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107115030.7ccf3f07.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 11:50:30AM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 06 Nov 2008 10:30:24 -0500
> vgoyal@redhat.com wrote:
> 
> > 
> > o biocgroup functionality.
> > o Implemented new controller "bio"
> > o Most of it picked from dm-ioband biocgroup implementation patches.
> > 
> page_cgroup implementation is changed and most of this patch needs rework.
> please see the latest one. (I think most of new characteristics are useful
> for you.)
> 

Sure I will have a look.

> One comment from me is
> ==
> > +struct page_cgroup {
> > +	struct list_head lru;		/* per cgroup LRU list */
> > +	struct page *page;
> > +	struct mem_cgroup *mem_cgroup;
> > +	int flags;
> > +#ifdef CONFIG_CGROUP_BIO
> > +	struct list_head blist;		/* for bio_cgroup page list */
> > +	struct bio_cgroup *bio_cgroup;
> > +#endif
> > +};
> ==
> 
> this blist is too bad. please keep this object small...
> 

This is just another connecting element so that page_cgroup can be on another
list also. It is useful in making sure that IO on all the pages of a bio
group has completed beofer that bio cgroup is deleted.

> Maybe dm-ioband people will post his own new one. just making use of it is an idea.

Sure, I will have a look when dm-ioband people post new version of patch
and how they have optimized it further.

Thanks
Vivek
