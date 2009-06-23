Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbZFWX2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbZFWX2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZFWX21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:28:27 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:47768 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754591AbZFWX20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:28:26 -0400
Subject: Re: [PATCH] Hugepages should be accounted as unevictable pages.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <4A415D62.20109@redhat.com>
References: <20090623093459.2204.A69D9226@jp.fujitsu.com>
	 <1245732411.18339.6.camel@alok-dev1>
	 <20090623135017.220D.A69D9226@jp.fujitsu.com>
	 <20090623141147.8f2cef18.kamezawa.hiroyu@jp.fujitsu.com>
	 <1245736441.18339.21.camel@alok-dev1>  <4A41481D.1060607@redhat.com>
	 <1245793331.24110.33.camel@alok-dev1>  <4A414F55.2040808@redhat.com>
	 <1245794811.24110.41.camel@alok-dev1>  <4A415D62.20109@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 23 Jun 2009 16:28:29 -0700
Message-Id: <1245799709.24110.70.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-06-23 at 15:55 -0700, Rik van Riel wrote:
> Alok Kataria wrote:
> > On Tue, 2009-06-23 at 14:55 -0700, Rik van Riel wrote:
> >> Alok Kataria wrote:
> >>> On Tue, 2009-06-23 at 14:24 -0700, Rik van Riel wrote:
> 
> >> Things like page tables and dentry/inode caches vary
> >> according to the use case and are allocated as needed.But I think we should think But I think we should think 
> >> They are in no way "static in nature".
> > 
> > Maybe static was the wrong word to use here. 
> > What i meant was that you could always calculate the *maximum* amount of
> > memory that is going to be used by page table and can also determine the
> > % of memory that will be used by slab caches.
> 
> My point is that you cannot do that.
> 
> We have seen systems with 30% of physical memory in
> page tables,

I see, for some reason I thought that the user process's  page tables
should be swappable, but that doesn't look like what we do.
Though, that count should be available by aggregating the total ACTIVE
and INACTIVE counts, right ? 

Now regarding the patch that I posted, I need a way to get the hugepages
count, there are 2 ways of doing this. 
1. exporting hugetlb_total_pages function for module usage.
2. use NR_UNEVICTABLE to reflect the hugepages count too.

For some reason I think (2) is the correct way to go. NR_UNEVICTABLE
should mean all the locked memory that the user requested to be locked. 

I don't see a reason why NR_UNEVICTABLE should only mean # of pages on
UNEVICTABLE_LRU.

Thanks,
Alok


>  as well as systems with a similar amount
> of memory in the slab cache.
> 
> Yes, these were running legitimate workloads.
> 

