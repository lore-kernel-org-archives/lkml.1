Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbXJYDNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbXJYDNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXJYDN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:13:28 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:37345 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753337AbXJYDN1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:13:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=N6AaLov+US0tAWUMoncI96+ST7F+mGx5wvpcUI91JuYZBjwYg4+UszdFaxPdAHj51s+VWCGVNFXvgOE51DXZjYdedSna/mMVMhGYxZXzX2uXM9d/CFf2r1PT5Vv0P77nW7INAntQbFd7wY1RLxo1Dly58f5KPLQQvfWP4aL0R7E=  ;
X-YMail-OSG: XQA6_NUVM1mn_i7dZ54QT9HEScnGq1UgAi3l25XdqIXpQPOlhGssJKPMH_SjrbvAQXwUCD8PkQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
Date: Thu, 25 Oct 2007 13:06:38 +1000
User-Agent: KMail/1.9.5
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Mel Gorman <mel@skynet.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
References: <20071023181615.GA10377@martell.zuzino.mipt.ru> <200710251234.01440.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710241941200.30364@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710241941200.30364@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200710251306.39237.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 12:43, Christoph Lameter wrote:
> On Thu, 25 Oct 2007, Nick Piggin wrote:
> > > Ummm... all unreclaimable is set! Are you mlocking the pages in memory?
> > > Or what causes this? All pages under writeback? What is the dirty ratio
> > > set to?
> >
> > Why is SLUB behaving differently, though.
>
> Nore sure. Are we really sure that this does not occur using SLAB?

>From the reports it seems pretty consistent. I guess it could well
be something that may occur with SLAB *if the conditions are a bit
different*...

> > Memory efficiency wouldn't be the reason, would it? I mean, SLUB
> > should be more efficient than SLAB, plus have less data lying around
> > in queues.
>
> SLAB may have data around in queues which (if the stars align the right
> way) may allow it to go longer without having to get a page from the page
> allocator.

But page allocs from slab isn't where the OOMs are occurring, so this
seems unlikely (also, the all_unreclaimable logic now should be pretty
strict, so you have to really run the machine out of memory (1GB of
swap gets fully used, then his DMA32 zone is scanned 8 times without
reclaiming a single page).

That said, parallel kernel compiling can really change a lot in memory
footprint depending on small variations in timing. So it might not be
anything to worry about.
