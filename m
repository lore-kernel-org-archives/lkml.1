Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbXEAXUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbXEAXUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXEAXUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:20:31 -0400
Received: from waste.org ([66.93.16.53]:33256 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854AbXEAXUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:20:30 -0400
Date: Tue, 1 May 2007 18:15:48 -0500
From: Matt Mackall <mpm@selenic.com>
To: Bill Irwin <bill.irwin@oracle.com>, Christoph Hellwig <hch@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2/6] add config option to vmalloc stacks (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070501231548.GF11115@waste.org>
References: <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174310.GE19966@holomorphy.com> <20070430181104.GB14739@infradead.org> <20070430190952.GP31925@holomorphy.com> <20070430191511.GA25318@infradead.org> <20070501223606.GQ11166@waste.org> <20070501225125.GU26598@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501225125.GU26598@holomorphy.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 03:51:25PM -0700, Bill Irwin wrote:
> On Mon, Apr 30, 2007 at 08:15:11PM +0100, Christoph Hellwig wrote:
> >> So if you want to invest some time into getting this into mergeable
> >> shape I'd suggest you redo the patch series in the following way:
> >>  patch 1: dynamic allocated irq stacks
> 
> On Tue, May 01, 2007 at 05:36:06PM -0500, Matt Mackall wrote:
> > Can we register them lazily at request_irq time?
> 
> These IRQ stacks are per-cpu, not per-IRQ. It may make sense to
> implement per-IRQ stacks, in which case dynamic allocation at the time
> of request_irq() will make sense.
> 
> Would you like me to implement per-IRQ IRQ stacks?

It's probably the "right" thing to do, but it does have higher
overhead for most systems.

But it also gives a very obvious migration path to -rt's irq threads.

-- 
Mathematics is the supreme nostalgia of our time.
