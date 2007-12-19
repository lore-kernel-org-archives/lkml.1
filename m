Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbXLSOY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbXLSOY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 09:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbXLSOYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 09:24:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59880 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbXLSOYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 09:24:13 -0500
Subject: Re: [patch 17/20] non-reclaimable mlocked pages
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <20071219084534.4fee8718@bree.surriel.com>
References: <20071218211539.250334036@redhat.com>
	 <20071218211550.186819416@redhat.com>
	 <200712191156.48507.nickpiggin@yahoo.com.au>
	 <20071219084534.4fee8718@bree.surriel.com>
Content-Type: text/plain
Date: Wed, 19 Dec 2007 15:24:07 +0100
Message-Id: <1198074247.6484.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-12-19 at 08:45 -0500, Rik van Riel wrote:
> On Wed, 19 Dec 2007 11:56:48 +1100
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > On Wednesday 19 December 2007 08:15, Rik van Riel wrote:
> > 
> > > Rework of a patch by Nick Piggin -- part 1 of 2.
> > >
> > > This patch:
> > >
> > > 1) defines the [CONFIG_]NORECLAIM_MLOCK sub-option and the
> > >    stub version of the mlock/noreclaim APIs when it's
> > >    not configured.  Depends on [CONFIG_]NORECLAIM.
> 
> > Hmm, I still don't know (or forgot) why you don't just use the
> > old scheme of having an mlock count in the LRU bit, and removing
> > the mlocked page from the LRU completely.
> 
> How do we detect those pages reliably in the lumpy reclaim code?
>  
> > These mlocked pages don't need to be on a non-reclaimable list,
> > because we can find them again via the ptes when they become
> > unlocked, and there is no point background scanning them, because
> > they're always going to be locked while they're mlocked.

I thought Lee had patches that moved pages with long rmap chains (both
anon and file) out onto the non-reclaim list, for those a slow
background scan does make sense.


