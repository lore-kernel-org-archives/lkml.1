Return-Path: <linux-kernel-owner+w=401wt.eu-S1765696AbXHQShl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765696AbXHQShl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 14:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXHQSh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 14:37:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52547 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765431AbXHQShZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 14:37:25 -0400
Date: Sat, 18 Aug 2007 00:20:09 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: kfree(0) - ok?
In-Reply-To: <1187375514.2615.0.camel@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.999.0708180019470.3666@enigma.security.iitk.ac.in>
References: <46C233CB.9000602@am.sony.com>  <1187132149.2618.2.camel@laptopd505.fenrus.org>
  <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in> 
 <20070817112253.e6a7cb33.akpm@linux-foundation.org>
 <1187375514.2615.0.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Aug 2007, Arjan van de Ven wrote:

> 
> On Fri, 2007-08-17 at 11:22 -0700, Andrew Morton wrote:
> > On Wed, 15 Aug 2007 05:12:41 +0530 (IST)
> > Satyam Sharma <satyam@infradead.org> wrote:
> > 
> > > [PATCH] {slub, slob}: use unlikely() for kfree(ZERO_OR_NULL_PTR) check
> > > 
> > > Considering kfree(NULL) would normally occur only in error paths and
> > > kfree(ZERO_SIZE_PTR) is uncommon as well, so let's use unlikely() for
> > > the condition check in SLUB's and SLOB's kfree() to optimize for the
> > > common case. SLAB has this already.
> > 
> > I went through my current versions of slab/slub/slub and came up with this:
> > 
> > diff -puN mm/slob.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check mm/slob.c
> > --- a/mm/slob.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check
> > +++ a/mm/slob.c
> > @@ -360,7 +360,7 @@ static void slob_free(void *block, int s
> >  	slobidx_t units;
> >  	unsigned long flags;
> >  
> > -	if (ZERO_OR_NULL_PTR(block))
> > +	if (unlikely(ZERO_OR_NULL_PTR(block)))
> 
> 
> 
> btw this makes NO sense at all; gcc already defaults to assuming
> unlikely if you check a pointer for NULL....

ZERO_OR_NULL_PTR() is not a check for NULL.
