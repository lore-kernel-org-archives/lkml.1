Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZEDTHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZEDTHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZEDTHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:07:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551AbZEDTHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:07:05 -0400
Date: Mon, 4 May 2009 12:01:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Message-Id: <20090504120103.c516ad18.akpm@linux-foundation.org>
In-Reply-To: <200905041702.23291.rjw@sisk.pl>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<200905040210.10153.rjw@sisk.pl>
	<alpine.DEB.2.00.0905031734190.24114@chino.kir.corp.google.com>
	<200905041702.23291.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009 17:02:22 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday 04 May 2009, David Rientjes wrote:
> > On Mon, 4 May 2009, Rafael J. Wysocki wrote:
> > 
> > > Index: linux-2.6/mm/page_alloc.c
> > > ===================================================================
> > > --- linux-2.6.orig/mm/page_alloc.c
> > > +++ linux-2.6/mm/page_alloc.c
> > > @@ -1620,7 +1620,8 @@ nofail_alloc:
> > >  		}
> > >  
> > >  		/* The OOM killer will not help higher order allocs so fail */
> > > -		if (order > PAGE_ALLOC_COSTLY_ORDER) {
> > > +		if (order > PAGE_ALLOC_COSTLY_ORDER ||
> > > +				(gfp_mask & __GFP_NO_OOM_KILL)) {
> > >  			clear_zonelist_oom(zonelist, gfp_mask);
> > >  			goto nopage;
> > >  		}
> > 
> > This is inconsistent because __GFP_NO_OOM_KILL now implies __GFP_NORETRY 
> > (the "goto nopage" above), but only for allocations with __GFP_FS set and 
> > __GFP_NORETRY clear.
> 
> Well, what would you suggest?
> 

Did you check whether the existing __GFP_NORETRY will work as-is for
this requirement?
