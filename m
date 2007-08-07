Return-Path: <linux-kernel-owner+w=401wt.eu-S933632AbXHGXzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbXHGXzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbXHGXzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:55:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54994 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbXHGXzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:55:05 -0400
Subject: Re: [RFC][PATCH 3/5] pagemap: remove open-coded sizeof(unsigned
	long)
From: Dave Hansen <haveblue@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com
In-Reply-To: <20070807234027.GE30556@waste.org>
References: <20070807223300.9228E0E0@kernel>
	 <20070807223302.B275F4FC@kernel>  <20070807234027.GE30556@waste.org>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 16:55:02 -0700
Message-Id: <1186530902.22283.77.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 18:40 -0500, Matt Mackall wrote:
> On Tue, Aug 07, 2007 at 03:33:02PM -0700, Dave Hansen wrote:
> > +#define PAGEMAP_ENTRY_SIZE_BYTES sizeof(unsigned long)
> > +
> >  static int add_to_pagemap(unsigned long addr, unsigned long pfn,
> >  			  struct pagemapread *pm)
> >  {
> >  	__put_user(pfn, pm->out);
> >  	pm->out++;
> > -	pm->pos += sizeof(unsigned long);
> > -	pm->count -= sizeof(unsigned long);
> > -	pm->next = addr + PAGE_SIZE;
> > +	pm->pos += PAGEMAP_ENTRY_SIZE_BYTES;
> > +	pm->count -= PAGEMAP_ENTRY_SIZE_BYTES;
> 
> I think deleting ->next is a little premature here?

It is.  I'll fix that up.

-- Dave

