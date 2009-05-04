Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZEDPDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZEDPDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZEDPDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:03:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42186 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZEDPDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:03:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Mon, 4 May 2009 17:02:22 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905040210.10153.rjw@sisk.pl> <alpine.DEB.2.00.0905031734190.24114@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905031734190.24114@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905041702.23291.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 May 2009, David Rientjes wrote:
> On Mon, 4 May 2009, Rafael J. Wysocki wrote:
> 
> > Index: linux-2.6/mm/page_alloc.c
> > ===================================================================
> > --- linux-2.6.orig/mm/page_alloc.c
> > +++ linux-2.6/mm/page_alloc.c
> > @@ -1620,7 +1620,8 @@ nofail_alloc:
> >  		}
> >  
> >  		/* The OOM killer will not help higher order allocs so fail */
> > -		if (order > PAGE_ALLOC_COSTLY_ORDER) {
> > +		if (order > PAGE_ALLOC_COSTLY_ORDER ||
> > +				(gfp_mask & __GFP_NO_OOM_KILL)) {
> >  			clear_zonelist_oom(zonelist, gfp_mask);
> >  			goto nopage;
> >  		}
> 
> This is inconsistent because __GFP_NO_OOM_KILL now implies __GFP_NORETRY 
> (the "goto nopage" above), but only for allocations with __GFP_FS set and 
> __GFP_NORETRY clear.

Well, what would you suggest?

Rafael
