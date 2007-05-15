Return-Path: <linux-kernel-owner+w=401wt.eu-S1761164AbXEOXph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761164AbXEOXph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760792AbXEOXpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:45:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38862 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760748AbXEOXpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:45:22 -0400
Date: Tue, 15 May 2007 16:45:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: mroos@linux.ee, David Miller <davem@davemloft.net>,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
In-Reply-To: <20070515163321.744e2388.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705151642530.3886@schroedinger.engr.sgi.com>
References: <Pine.SOC.4.64.0705142133190.17204@math>
 <20070514.151148.45744375.davem@davemloft.net>
 <Pine.LNX.4.64.0705141642350.13606@schroedinger.engr.sgi.com>
 <20070515163321.744e2388.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007, Andrew Morton wrote:

> On Mon, 14 May 2007 16:46:17 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > @@ -86,6 +87,9 @@ static inline int kmalloc_index(int size
> >  	 */
> >  	WARN_ON_ONCE(size == 0);
> >  
> > +	if (size >= (1UL << KMALLOC_SHIFT_HIGH))
> > +		return -1;
> > +
> 
> I don't quite understand why we did this.  The subsequent logic in
> kmalloc_index() should return -1 for this `size' anyway.  If it doesn't,
> it's bust, isn't it?

KMALLOC_SHIFT_HIGH is not a constant but may be less than 25.

> Also, afaict kmalloc_slab() will totally mishandle the -1 return value and
> will return a garbage kmem_cache*, via
> 
>         return &kmalloc_caches[index];

It does an

if (index < 0)

before getting to that statement.
 
> Could you double-check it all please?

It was already checked.


 
