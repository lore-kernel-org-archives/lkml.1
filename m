Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbYFJVtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbYFJVtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbYFJVto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:49:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbYFJVtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:49:43 -0400
Date: Tue, 10 Jun 2008 14:49:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 16/25] SHM_LOCKED pages are non-reclaimable
Message-Id: <20080610144906.e8434c80.akpm@linux-foundation.org>
In-Reply-To: <1213132946.6872.27.camel@lts-notebook>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.466929557@redhat.com>
	<20080606180514.93f620ff.akpm@linux-foundation.org>
	<20080610170348.5750491c@cuia.bos.redhat.com>
	<1213132946.6872.27.camel@lts-notebook>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 17:22:26 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> > Or mark it unevictable again if it still is.
> > 
> > > > + * scan_mapping_noreclaim_pages - scan an address space for reclaimable pages
> > > > + * @mapping: struct address_space to scan for reclaimable pages
> > > > + *
> > > > + * Scan all pages in mapping.  Check non-reclaimable pages for
> > > > + * reclaimability and move them to the appropriate zone lru list.
> > > > + */
> > > > +void scan_mapping_noreclaim_pages(struct address_space *mapping)
> > > > +{
> > 
> > > This function can spend fantastically large amounts of time under
> > > spin_lock_irq().
> 
> Yes, if we get a run of pages from the same zone [likely, I think],
> we'll hold the lock over a full "batch" of  PAGEVEC_SIZE [14] pages.  I
> haven't measured the hold time, but can do.

oh.  I misread the code.  Holding spin_lock_irq() across a single
pagevec should be OK.  At least, we do that in lots of other places.

