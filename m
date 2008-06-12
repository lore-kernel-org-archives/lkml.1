Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYFLRuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYFLRuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYFLRuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:50:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbYFLRue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:50:34 -0400
Date: Thu, 12 Jun 2008 13:50:14 -0400
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH -mm 14/24] Ramfs and Ram Disk pages are unevictable
Message-ID: <20080612135014.026cc2e3@cuia.bos.redhat.com>
In-Reply-To: <200806130337.57118.nickpiggin@yahoo.com.au>
References: <20080611184214.605110868@redhat.com>
	<200806121054.19253.nickpiggin@yahoo.com.au>
	<20080612132952.568226f6@cuia.bos.redhat.com>
	<200806130337.57118.nickpiggin@yahoo.com.au>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 03:37:56 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > > This isn't the case for brd any longer. It doesn't use the buffer
> > > cache as its backing store, so the buffer cache is reclaimable.

> > I know that pages of files that got paged into the page
> > cache from the ramdisk can be evicted (back to the ram
> > disk), but how do the brd pages themselves behave?
> 
> They are not reclaimable. But they have nothing (directly) to do
> with brd's i_mapping address space, nor are they put on any LRU
> lists.

Ahhhh, doh!

I'm mailing Andrew a patch right now that undoes the
brd.c part of patch 14/24. The ramdisk part is correct
and should stay (afaict).

-- 
All Rights Reversed
