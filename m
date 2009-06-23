Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbZFWWG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbZFWWG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbZFWWGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:06:49 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:53899 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757619AbZFWWGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:06:48 -0400
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
In-Reply-To: <4A414F55.2040808@redhat.com>
References: <20090623093459.2204.A69D9226@jp.fujitsu.com>
	 <1245732411.18339.6.camel@alok-dev1>
	 <20090623135017.220D.A69D9226@jp.fujitsu.com>
	 <20090623141147.8f2cef18.kamezawa.hiroyu@jp.fujitsu.com>
	 <1245736441.18339.21.camel@alok-dev1>  <4A41481D.1060607@redhat.com>
	 <1245793331.24110.33.camel@alok-dev1>  <4A414F55.2040808@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 23 Jun 2009 15:06:51 -0700
Message-Id: <1245794811.24110.41.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-06-23 at 14:55 -0700, Rik van Riel wrote:
> Alok Kataria wrote:
> > On Tue, 2009-06-23 at 14:24 -0700, Rik van Riel wrote:
> 
> >> I can see something reasonable on both sides of this
> >> particular debate.  However, even with this patch the
> >> "unevictable" statistic does not reclaim the total
> >> number of pages that are unevictable pages from a
> >> zone, so I am not sure how it helps you achieve your
> >> goal.
> > 
> > Yes but most of the other memory (page table and others) which is
> > unevictable is actually static in nature.  IOW, the amount of this other
> > kind of kernel unevictable pages can be actually interpolated from the
> > amount of physical memory on the system. 
> 
> That would be a fair argument, if it were true.
> 
> Things like page tables and dentry/inode caches vary
> according to the use case and are allocated as needed.
> They are in no way "static in nature".
> 

Maybe static was the wrong word to use here. 
What i meant was that you could always calculate the *maximum* amount of
memory that is going to be used by page table and can also determine the
% of memory that will be used by slab caches. 
So that ways you should be statically able to tell that no more than 'X'
amount of memory is going to be locked here.
Will again like to stress that "X" is not the exact amount that is
locked here but the one which can be. 

OTOH, for hugepages and mlocked pages you need to read the exact counts
as this can change according to user selection. 

Thanks,
Alok


