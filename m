Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbZFWT3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbZFWT3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZFWT2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:28:53 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:55228 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbZFWT2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:28:53 -0400
Subject: Re: [PATCH] Hugepages should be accounted as unevictable pages.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090623150630.31c0dff5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090623093459.2204.A69D9226@jp.fujitsu.com>
	 <1245732411.18339.6.camel@alok-dev1>
	 <20090623135017.220D.A69D9226@jp.fujitsu.com>
	 <20090623141147.8f2cef18.kamezawa.hiroyu@jp.fujitsu.com>
	 <1245736441.18339.21.camel@alok-dev1>
	 <20090623150630.31c0dff5.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 23 Jun 2009 12:28:55 -0700
Message-Id: <1245785335.24110.19.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-06-22 at 23:06 -0700, KAMEZAWA Hiroyuki wrote:
> On Mon, 22 Jun 2009 22:54:01 -0700
> Alok Kataria <akataria@vmware.com> wrote:
> 
> > > > 
> > > > I don't have any strong oppose reason, but I also don't have any strong
> > > > agree reason.
> > > > 
> > > I think "don't include Hugepage" is sane. Hugepage is something _special_, now.
> > > 
> > Kamezawa-san, 
> > 
> > I agree that hugepages are special in the sense that they are
> > implemented specially and don't actually reside on the LRU like any
> > other locked memory. But, both of these memory types (mlocked and
> > hugepages) are actually unevictable and can't be reclaimed back, so i
> > don't see a reason why should accounting not reflect that.
> > 
> 
> I bet we should rename "Unevictable" to "Mlocked" or "Pinned" rather than
> take nr_hugepages into account. I think this "Unevictable" in meminfo means
> - pages which are evictable in their nature (because in LRU) but a user pinned it -
> 
> How about rename "Unevictable" to "Pinned" or "Locked" ?
> (Mlocked + locked shmem's + ramfs?)
> 

As Lee also pointed out, i don't see why is this # of pages on
unevictable_lru important for the user.
IMO, it doesn't give any useful information, other than confusing us to
believe that only these are unevictable.

Is there something else that I am missing here ?

> We have other "unevictable" pages other than Hugepage anyway.
>  - page table
>  - some slab
>  - kernel's page
>  - anon pages in swapless system
>  etc...

I agree there are these other pages which are unevictable, but they are
pages used by the kernel itself, and they will always be locked/utilized
by the kernel. 
The unevictable pages (hugepages and mlocked and others) on the other
hand are pages which the user explicitly asked to be locked/pinned.

So i think, these other-evictable pages that you mentioned, are
different in a way. 

> 
> BTW, I use following calculation for quick check if I want all "Unevicatable" pages.
> 
> Unevictable = Total - (Active+Inactive) + (50-70%? of slab)
> 
> This # of is not-reclaimable memory.

I don't see how this would get the correct value either, mlocked or
hugepages are not accounted by either of the Active or Inactive regions.


Thanks,
Alok

> 
> Thanks,
> -Kame
> 
> 
> > Thanks,
> > Alok
> > 
> > > Thanks,
> > > -Kame
> > > 
> > 
> > 
> 

