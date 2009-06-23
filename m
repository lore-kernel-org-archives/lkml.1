Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbZFWVm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbZFWVm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758914AbZFWVmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:42:11 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:39531 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758247AbZFWVmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:42:10 -0400
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
In-Reply-To: <4A41481D.1060607@redhat.com>
References: <20090623093459.2204.A69D9226@jp.fujitsu.com>
	 <1245732411.18339.6.camel@alok-dev1>
	 <20090623135017.220D.A69D9226@jp.fujitsu.com>
	 <20090623141147.8f2cef18.kamezawa.hiroyu@jp.fujitsu.com>
	 <1245736441.18339.21.camel@alok-dev1>  <4A41481D.1060607@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 23 Jun 2009 14:42:11 -0700
Message-Id: <1245793331.24110.33.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-06-23 at 14:24 -0700, Rik van Riel wrote:
> Alok Kataria wrote:
> 
> > Both, while working on an module I noticed that there is no way direct
> > way to get any information regarding the total number of unrecliamable
> > (unevictable) pages in the system. While reading through the kernel
> > sources i came across this unevictalbe LRU framework and thought that
> > this should actually work towards providing  total unevictalbe pages in
> > the system irrespective of where they reside.
> 
> The unevictable count tells you how many _userspace_
> pages are not evictable.
> 
> There are countless accounted and unaccounted kernel
> allocations that show up (or not) in other fields in
> /proc/meminfo.
> 

> I can see something reasonable on both sides of this
> particular debate.  However, even with this patch the
> "unevictable" statistic does not reclaim the total
> number of pages that are unevictable pages from a
> zone, so I am not sure how it helps you achieve your
> goal.
> 

Yes but most of the other memory (page table and others) which is
unevictable is actually static in nature.  IOW, the amount of this other
kind of kernel unevictable pages can be actually interpolated from the
amount of physical memory on the system. 

One thing that i forgot to mention earlier is that, I just need a way to
provide a hint about the total locked memory  on the system and it
doesn't need to be the exact number at that point in time.

Lee, due to this reason lazy culling of unevictable pages is fine too. 

Hugepages, similar to mlocked pages, are special because the user could
specify how much memory it wants to reserve for this purpose. So that
needs to be taken into consideration i.e it cannot be calculated in some
way. 

Thanks,
Alok


