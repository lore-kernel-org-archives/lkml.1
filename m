Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbZFWGIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbZFWGIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZFWGIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:08:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40772 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbZFWGIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:08:06 -0400
Date: Tue, 23 Jun 2009 15:06:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: akataria@vmware.com
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] Hugepages should be accounted as unevictable pages.
Message-Id: <20090623150630.31c0dff5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1245736441.18339.21.camel@alok-dev1>
References: <20090623093459.2204.A69D9226@jp.fujitsu.com>
	<1245732411.18339.6.camel@alok-dev1>
	<20090623135017.220D.A69D9226@jp.fujitsu.com>
	<20090623141147.8f2cef18.kamezawa.hiroyu@jp.fujitsu.com>
	<1245736441.18339.21.camel@alok-dev1>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 22:54:01 -0700
Alok Kataria <akataria@vmware.com> wrote:

> > > 
> > > I don't have any strong oppose reason, but I also don't have any strong
> > > agree reason.
> > > 
> > I think "don't include Hugepage" is sane. Hugepage is something _special_, now.
> > 
> Kamezawa-san, 
> 
> I agree that hugepages are special in the sense that they are
> implemented specially and don't actually reside on the LRU like any
> other locked memory. But, both of these memory types (mlocked and
> hugepages) are actually unevictable and can't be reclaimed back, so i
> don't see a reason why should accounting not reflect that.
> 

I bet we should rename "Unevictable" to "Mlocked" or "Pinned" rather than
take nr_hugepages into account. I think this "Unevictable" in meminfo means
- pages which are evictable in their nature (because in LRU) but a user pinned it -

How about rename "Unevictable" to "Pinned" or "Locked" ?
(Mlocked + locked shmem's + ramfs?)

We have other "unevictable" pages other than Hugepage anyway.
 - page table
 - some slab
 - kernel's page
 - anon pages in swapless system
 etc...

BTW, I use following calculation for quick check if I want all "Unevicatable" pages.

Unevictable = Total - (Active+Inactive) + (50-70%? of slab)

This # of is not-reclaimable memory.

Thanks,
-Kame


> Thanks,
> Alok
> 
> > Thanks,
> > -Kame
> > 
> 
> 

