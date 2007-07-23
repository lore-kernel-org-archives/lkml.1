Return-Path: <linux-kernel-owner+w=401wt.eu-S1764295AbXGWVhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764295AbXGWVhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbXGWVhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:37:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51672 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754486AbXGWVhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:37:24 -0400
Date: Mon, 23 Jul 2007 14:37:24 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] fix slub krealloc()
Message-ID: <20070723143724.1d0b26eb@schroedinger.engr.sgi.com>
In-Reply-To: <20070723134713.2b1218bd.akpm@linux-foundation.org>
References: <1184773331.4002.4.camel@johannes.berg>
	<20070723133206.2220db7e@schroedinger.engr.sgi.com>
	<20070723134713.2b1218bd.akpm@linux-foundation.org>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 13:47:13 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:


> > Right. We need to fix util.c. ksize should not be called with a NULL
> > parameter.
> > Index: linux-2.6/mm/util.c
> > ===================================================================
> > --- linux-2.6.orig/mm/util.c	2007-07-23 13:29:42.000000000
> > -0700 +++ linux-2.6/mm/util.c	2007-07-23 13:31:28.000000000
> > -0700 @@ -88,7 +88,11 @@ void *krealloc(const void *p, size_t new
> >  		return ZERO_SIZE_PTR;
> >  	}
> >  
> > -	ks = ksize(p);
> > +	if (p)
> > +		ks = ksize(p);
> > +	else
> > +		ks = 0;
> > +
> >  	if (ks >= new_size)
> >  		return (void *)p;
> >  
> 
> I think we already fixed this?
> 
> commit 1d4ec7b1d6f130818f9b62dea3411d9ee2ff6ff6
> Author: Roland Dreier <rdreier@cisco.com>
> Date:   Fri Jul 20 12:13:20 2007 -0700
> 
>     Fix ZERO_OR_NULL_PTR(ZERO_SIZE_PTR)

There is no use of ZERO_OR_NULL ptr in krealloc. Linus added a check to
ksize() instead so that ksize(NULL) returns 0 instead of failing.


