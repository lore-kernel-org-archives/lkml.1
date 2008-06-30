Return-Path: <linux-kernel-owner+w=401wt.eu-S1761061AbYF3TVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061AbYF3TVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbYF3TVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:21:00 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:58546 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYF3TU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:20:59 -0400
Date: Mon, 30 Jun 2008 20:19:36 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splitlru: memcg swapbacked pages active
In-Reply-To: <20080630114439.da792361.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0806302010230.27080@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
 <Pine.LNX.4.64.0806290120270.21758@blonde.site>
 <20080630114439.da792361.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, KAMEZAWA Hiroyuki wrote:
> On Sun, 29 Jun 2008 01:22:22 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> > 
> > --- mmotm/mm/memcontrol.c	2008-06-27 13:39:20.000000000 +0100
> > +++ linux/mm/memcontrol.c	2008-06-27 17:32:29.000000000 +0100
> > @@ -560,6 +560,8 @@ static int mem_cgroup_charge_common(stru
> >  		pc->flags = PAGE_CGROUP_FLAG_CACHE;
> >  		if (page_is_file_cache(page))
> >  			pc->flags |= PAGE_CGROUP_FLAG_FILE;
> > +		else
> > +			pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
> >  	} else
> >  		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
> >  
>
> Hmm, maybe no trouble but we'll have to care shmem's page is not marked as
> PAGE_CGROUP_FLAG_CACHE but charged by mem_cgroup_charge_cache_page(). 
> (I think why shmem is charged as cache is because shmem is used for tmpfs)
> 
> pc->flags |= PAGE_CGROUP_FLAG_FILE |  PAGE_CGROUP_FLAG_ACTIVE;
> 
> is bad ? (or not work ? I can't catch yet.)

Sorry, I've tried several times to understand you here, but still don't.

I thought shmem's page is marked as PAGE_CGROUP_FLAG_CACHE, and is
charged by mem_cgroup_charge_cache_page(), and that's what memcg wants?

It is a bit weird that PAGE_CGROUP_FLAG_CACHE and PAGE_CGROUP_FLAG_FILE
diverge, I'm not thrilled with that: that's an aspect of splitlru
treating shmem/tmpfs pages as not-file pages, which I'm unhappy with.

Hugh
