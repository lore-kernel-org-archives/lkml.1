Return-Path: <linux-kernel-owner+w=401wt.eu-S934227AbXHHCBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227AbXHHCBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 22:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbXHHCBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 22:01:03 -0400
Received: from waste.org ([66.93.16.53]:35912 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884AbXHHCBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 22:01:01 -0400
Date: Tue, 7 Aug 2007 21:01:42 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com
Subject: Re: [RFC][PATCH 3/5] pagemap: remove open-coded sizeof(unsigned long)
Message-ID: <20070808020142.GJ30556@waste.org>
References: <20070807223300.9228E0E0@kernel> <20070807223302.B275F4FC@kernel> <20070807234027.GE30556@waste.org> <1186530902.22283.77.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186530902.22283.77.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 04:55:02PM -0700, Dave Hansen wrote:
> On Tue, 2007-08-07 at 18:40 -0500, Matt Mackall wrote:
> > On Tue, Aug 07, 2007 at 03:33:02PM -0700, Dave Hansen wrote:
> > > +#define PAGEMAP_ENTRY_SIZE_BYTES sizeof(unsigned long)
> > > +
> > >  static int add_to_pagemap(unsigned long addr, unsigned long pfn,
> > >  			  struct pagemapread *pm)
> > >  {
> > >  	__put_user(pfn, pm->out);
> > >  	pm->out++;
> > > -	pm->pos += sizeof(unsigned long);
> > > -	pm->count -= sizeof(unsigned long);
> > > -	pm->next = addr + PAGE_SIZE;
> > > +	pm->pos += PAGEMAP_ENTRY_SIZE_BYTES;
> > > +	pm->count -= PAGEMAP_ENTRY_SIZE_BYTES;
> > 
> > I think deleting ->next is a little premature here?
> 
> It is.  I'll fix that up.

While we're at it, it seems a shame to replace the unwieldy typedef
with an even longer define. My poor shift key finger aches just
thinking about typing that. PM_ENTRY_SIZE, perhaps?

-- 
Mathematics is the supreme nostalgia of our time.
