Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYGGHFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYGGHFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 03:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbYGGHFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 03:05:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:33386 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYGGHFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 03:05:45 -0400
Date: Mon, 7 Jul 2008 00:05:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Dave Airlie <airlied@gmail.com>,
       Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kmap_atomic_pfn for PCI BAR access?
Message-ID: <20080707000528.09518481@infradead.org>
In-Reply-To: <200807071653.55094.nickpiggin@yahoo.com.au>
References: <1214242487.11887.35.camel@koto.keithp.com>
	<21d7e9970806251823q3405e192q13d4944bd0cc3291@mail.gmail.com>
	<486308C9.5070709@goop.org>
	<200807071653.55094.nickpiggin@yahoo.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008 16:53:54 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Thursday 26 June 2008 13:11, Jeremy Fitzhardinge wrote:
> > Dave Airlie wrote:
> 
> > > doing tlb flush for iounmap is slow as all hell if you do it a
> > > lot, and we can't afford to mmap the whole aperture it can 1GB.
> >
> > Maybe Nick's vmap reimplementation would help here.  It effectively
> > allows you to map stuff into the vmalloc space, and do lazy tlb
> > flushes to mitigate the cost of map/unmap.  He posted the patches
> > week or so ago.
> 
> Yeah, it can _really_ help. I'd posted some performance numbers with
> the patch which might prompt you to take another look at ioremap.
> 
> One thing I still haven't implemented in that patch are CPU-local
> mappings (which only require a local flush to flush)... I found that
> after the improvements I did implement, they didn't help much for
> my workloads, so I suspect you might find the same thing... 

just to complicate things with ioremap() you have to deal with the
various caching-coherency requirements.. making things lazy and per CPU
complicates that a ton (and I suspect won't actually make things
cheaper)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
