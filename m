Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYKGEUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYKGEUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 23:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYKGETx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 23:19:53 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:58705 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750806AbYKGETw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 23:19:52 -0500
Date: Fri, 07 Nov 2008 13:19:49 +0900 (JST)
Message-Id: <20081107.131949.106618398.taka@valinux.co.jp>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       ryov@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       riel@redhat.com, fernando@oss.ntt.co.jp, jmoyer@redhat.com,
       menage@google.com, ngupta@google.com, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [patch 2/4] io controller: biocgroup implementation
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20081107115030.7ccf3f07.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081106153022.215696930@redhat.com>
	<20081106153135.790621895@redhat.com>
	<20081107115030.7ccf3f07.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm going to release a new version of bio_cgroup soon, which doesn't
have "struct list_head blist" anymore and whose overhead is minimized.

> > o biocgroup functionality.
> > o Implemented new controller "bio"
> > o Most of it picked from dm-ioband biocgroup implementation patches.
> > 
> page_cgroup implementation is changed and most of this patch needs rework.
> please see the latest one. (I think most of new characteristics are useful
> for you.)
> 
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
> Maybe dm-ioband people will post his own new one. just making use of it is an idea.
> 
> Thanks,
> -Kame
> 
> 
