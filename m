Return-Path: <linux-kernel-owner+w=401wt.eu-S933650AbXHFTMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650AbXHFTMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762067AbXHFTMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:12:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47704 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760715AbXHFTMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:12:13 -0400
Date: Mon, 6 Aug 2007 12:10:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 03/10] mm: tag reseve pages
Message-Id: <20070806121053.baed9691.akpm@linux-foundation.org>
In-Reply-To: <20070806185926.GB22499@one.firstfloor.org>
References: <20070806102922.907530000@chello.nl>
	<20070806103658.356795000@chello.nl>
	<Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com>
	<p73r6mglaog.fsf@bingen.suse.de>
	<Pine.LNX.4.64.0708061143050.3152@schroedinger.engr.sgi.com>
	<1186426079.11797.88.camel@lappy>
	<20070806185926.GB22499@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007 20:59:26 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> > precious page flag
> 
> I always cringe when I hear that. It's really more than node/sparsemem
> use too many bits. If we get rid of 32bit NUMA that problem would be
> gone for the node at least because it could be moved into the mostly
> unused upper 32bit part on 64bit architectures.

Removing 32-bit NUMA is attractive - NUMAQ we can probably live without,
not sure about summit.  But superh is starting to use NUMA now, due to
varying access times of various sorts of memory, and one can envisage other
embedded setups doing that.

Plus I don't think there are many flags left in the upper 32-bits.  ia64
swooped in and gobbled lots of them, although it's not immediately clear
how many were consumed.

> The alternative would be to investigate again what it does to the
> kernel to just use different lookup methods for this.

That's cringeworthy too, I expect.
