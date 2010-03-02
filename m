Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0CBP0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:26:10 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:49281 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0CBP0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:26:08 -0500
Date: Tue, 2 Mar 2010 20:56:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Righi <arighi@develer.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [PATCH -mmotm 3/3] memcg: dirty pages instrumentation
Message-ID: <20100302152600.GA16532@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1267478620-5276-1-git-send-email-arighi@develer.com>
 <1267478620-5276-4-git-send-email-arighi@develer.com>
 <1267537736.25158.54.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1267537736.25158.54.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-03-02 14:48:56]:

> This is ugly and broken.. I thought you'd agreed to something like:
> 
>  if (mem_cgroup_has_dirty_limit(cgroup))
>    use mem_cgroup numbers
>  else
>    use global numbers
> 
> That allows for a 0 dirty limit (which should work and basically makes
> all io synchronous).
> 
> Also, I'd put each of those in a separate function, like:
> 
> unsigned long reclaimable_pages(cgroup)
> {
>   if (mem_cgroup_has_dirty_limit(cgroup))
>     return mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);
>   
>   return global_page_state(NR_FILE_DIRTY) + global_page_state(NR_NFS_UNSTABLE);
> }
>

I agree, I should have been more specific about the naming convention,
this is what I meant - along these lines as we do with
zone_nr_lru_pages(), etc.
 
> Which raises another question, you should probably rebase on top of
> Trond's patches, which removes BDI_RECLAIMABLE, suggesting you also
> loose MEMCG_NR_RECLAIM_PAGES in favour of the DIRTY+UNSTABLE split.
> 

-- 
	Three Cheers,
	Balbir
