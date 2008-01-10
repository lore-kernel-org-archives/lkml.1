Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbYAJD1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbYAJD1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 22:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYAJD0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 22:26:52 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:36993 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbYAJD0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 22:26:51 -0500
Date: Thu, 10 Jan 2008 08:56:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080110032631.GE15547@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
References: <20080108205939.323955454@redhat.com> <20080108210002.638347207@redhat.com> <20080109134132.ba7bb33c.kamezawa.hiroyu@jp.fujitsu.com> <20080110022133.GC15547@balbir.in.ibm.com> <20080110113618.f967d215.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080110113618.f967d215.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2008-01-10 11:36:18]:

> On Thu, 10 Jan 2008 07:51:33 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > > >  #define PAGE_CGROUP_FLAG_CACHE	(0x1)	/* charged as cache */
> > > >  #define PAGE_CGROUP_FLAG_ACTIVE (0x2)	/* page is active in this cgroup */
> > > > +#define PAGE_CGROUP_FLAG_FILE	(0x4)	/* page is file system backed */
> > > > 
> > > 
> > > Now, we don't have control_type and a feature for accounting only CACHE.
> > > Balbir-san, do you have some new plan ?
> > >
> > 
> > Hi, KAMEZAWA-San,
> > 
> > The control_type feature is gone. We still have cached page
> > accounting, but we do not allow control of only RSS pages anymore. We
> > need to control both RSS+cached pages. I do not understand your
> > question about new plan? Is it about adding back control_type?
> > 
> Ah, just wanted to confirm that we can drop PAGE_CGROUP_FLAG_CACHE
> if page_file_cache() function and split-LRU is introduced.
> 

Earlier we would have had a problem, since we even accounted for swap
cache with PAGE_CGROUP_FLAG_CACHE and I think page_file_cache() does
not account swap cache pages with page_file_cache(). Our accounting
is based on mapped vs unmapped whereas the new code from Rik accounts
file vs anonymous. I suspect we could live a little while longer
with PAGE_CGROUP_FLAG_CACHE and then if we do not need it at all,
we can mark it down for removal. What do you think?


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
