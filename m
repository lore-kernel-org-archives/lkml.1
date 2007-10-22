Return-Path: <linux-kernel-owner+w=401wt.eu-S1751777AbXJVJtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbXJVJtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXJVJtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:49:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38784 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbXJVJtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:49:05 -0400
Date: Mon, 22 Oct 2007 11:49:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?B?QsO4Z2Vza292?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071022094901.GA28174@one.firstfloor.org>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <p731wbw4t3h.fsf@bingen.suse.de> <200710160056.47458.nickpiggin@yahoo.com.au> <20071015110735.GA11748@one.firstfloor.org> <1193004961.6745.42.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193004961.6745.42.camel@pasglop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 08:16:01AM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2007-10-15 at 13:07 +0200, Andi Kleen wrote:
> > On Tue, Oct 16, 2007 at 12:56:46AM +1000, Nick Piggin wrote:
> > > Is this true even if you don't write through those old mappings?
> > 
> > I think it happened for reads too.  It is a little counter intuitive
> > because in theory the CPU doesn't need to write back non dirty lines,
> > but in the one case which took so long to debug exactly this happened
> > somehow.
> 
> The problem exist also on ppc, and afaik, is due to the line being in
> the cache at all (either dirty (write) or not (read)), thus causing the
> snoop logic to hit, that is what's causing the problem vs. non cached
> accesses.

That makes sense. Snoop can effectively turn a read into a write.

> Also, on some processors, the simple fact of having the page mapped can
> cause the CPU to prefetch from it even if it's not actually accessed
> (speculative prefetch can cross page boundaries if things are mapped).

Exactly that happens on x86. Normally prefetches stop on TLB miss,
but the CPU can do speculative TLB fetches too.

Also even without any prefetching the CPU does speculative execution
and that can lead to random addresses being followed.

-Andi
