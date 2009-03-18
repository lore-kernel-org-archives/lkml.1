Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZCRM2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZCRM2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbZCRM2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:28:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:50392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbZCRM2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:28:24 -0400
Subject: Re: [PATCH 0/3] dma-debug: add additional checks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090318121940.GT6159@amd.com>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com>
	 <20090317120112.GP6159@amd.com> <20090318093847.GC5879@elte.hu>
	 <20090318112324.GB32233@elte.hu> <1237376327.5069.253.camel@laptop>
	 <20090318121940.GT6159@amd.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 13:28:10 +0100
Message-Id: <1237379290.5069.341.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 13:19 +0100, Joerg Roedel wrote:
> On Wed, Mar 18, 2009 at 12:38:47PM +0100, Peter Zijlstra wrote:
> > On Wed, 2009-03-18 at 12:23 +0100, Ingo Molnar wrote:
> > > another -tip testbox started triggering:
> > > 
> > >   BUG: MAX_LOCKDEP_ENTRIES too low!
> > > 
> > > it triggers due to CONFIG_DMA_API_DEBUG=y. Config attached.
> > 
> > 
> > I still have this laying about.. could be we're just at the limit due to
> > lock bloat in the kernel, could be dma_api_debug is doing something
> > all-together iffy
> 
> I had a look and the maximum locking depth in dma-debug code was two.
> Attached patch reduces this to one.
> 
> From d28fc4a308bf66ed98c68e1db18e4e1434206541 Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Wed, 18 Mar 2009 13:15:20 +0100
> Subject: [PATCH] dma-debug: serialize locking in unmap path
> 
> Impact: reduce maximum lockdepth to one
> 
> This patch reduces the maximum spin lock depth from two to one in the
> dma-debug code.

While appreciated, this failure is not about lock depth, but about lock
entries, that is items in the dependency chains.

Of course, these two are not unrelated, deeper lock hierarchies lead to
longer chains -> more entries.

Assuming dma api debug doesn't do anything spectaculary odd, I'd say
we've just lock bloated the kernel and might need to increase this
static array a bit.

