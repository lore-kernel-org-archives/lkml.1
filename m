Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbXD2D0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbXD2D0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbXD2D0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:26:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754424AbXD2D0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:26:22 -0400
Date: Sat, 28 Apr 2007 20:25:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: bbpetkov@yahoo.de, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized
 spinlock. was: Re: 2.6.21-rc7-mm2
Message-Id: <20070428202527.d52470aa.akpm@linux-foundation.org>
In-Reply-To: <4633DD55.1020006@shadowen.org>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<20070426182519.GA4532@gollum.tnic>
	<20070427172230.94b82829.akpm@linux-foundation.org>
	<4633DD55.1020006@shadowen.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 00:48:37 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> > +++ a/mm/memory.c
> > @@ -1455,7 +1455,7 @@ static int apply_to_pte_range(struct mm_
> >  	pte_t *pte;
> >  	int err;
> >  	struct page *pmd_page;
> > -	spinlock_t *ptl;
> > +	spinlock_t *ptl = ptl;		/* Suppress gcc warning */
> >  
> >  	pte = (mm == &init_mm) ?
> >  		pte_alloc_kernel(pmd, addr) :
> > _
> > 
> 
> Perhaps we should have some kind definition helper.
> 
> #define suppress_unused(x) x = x
> 
> 	spinlock_t *suppress_unused(ptl);
> 
> Perhaps?

I think so.  It makes it clear what's happening and it allows us to change
the implementation later on if the present trick stops working in later
gcc.  It also allows people to suppress the suppression (some have
expressed concern that it can hide real bugs).

But I lost (or didn't pursue) the bunfight^Wdiscussion last time this came
around.

