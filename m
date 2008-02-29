Return-Path: <linux-kernel-owner+w=401wt.eu-S932512AbYB2SiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbYB2SiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756690AbYB2SiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:38:06 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44186 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337AbYB2SiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:38:03 -0500
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs()
	interface
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Michael Ellerman <michael@ellerman.id.au>, akepner@sgi.com,
       Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080229182504.GA18102@colo.lackof.org>
References: <20080228032448.GS11012@sgi.com>
	 <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com>
	 <20080229182504.GA18102@colo.lackof.org>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 12:37:56 -0600
Message-Id: <1204310276.4003.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-29 at 11:25 -0700, Grant Grundler wrote:
> On Fri, Feb 29, 2008 at 01:45:46PM +1100, Michael Ellerman wrote:
> > On Thu, Feb 28, 2008 at 2:24 PM,  <akepner@sgi.com> wrote:
> > >
> > >  Document the new dma_{un}map_{single|sg}_attrs() functions.
> > >
> > >  diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
> > >  index e69de29..36baea5 100644
> > >  --- a/Documentation/DMA-attributes.txt
> > >  +++ b/Documentation/DMA-attributes.txt
> > >  @@ -0,0 +1,29 @@
> > >  +                       DMA attributes
> > >  +                       ==============
> > >  +
> > >  +This document describes the semantics of the DMA attributes that are
> > >  +defined in linux/dma-attrs.h.
> > >  +
> > >  +
> > >  +DMA_ATTR_SYNC_ON_WRITE
> > >  +----------------------
> > >  +
> > >  +DMA_ATTR_SYNC_ON_WRITE is used on the IA64_SGI_SN2 architecture.
> > >  +It provides a mechanism for devices to explicitly order their DMA
> > >  +writes.
> > >  +
> > >  +On IA64_SGI_SN2 machines, DMA may be reordered within the NUMA
> > >  +interconnect. Allowing reordering improves performance, but in some
> > >  +situations it may be necessary to ensure that one DMA write is
> > >  +complete before another is visible. For example, if the device does
> > >  +a DMA write to indicate that data is available in memory, DMA of the
> > >  +"completion indication" can race with DMA of data.
> > >  +
> > >  +When a memory region is mapped with the DMA_ATTR_SYNC_ON_WRITE attribute,
> > >  +a write to that region causes all in-flight DMA to be flushed to memory.
> > >  +Any pending DMA will complete and be visible in memory before the write
> > >  +to the region with the DMA_ATTR_SYNC_ON_WRITE attribute becomes visible.
> > 
> > 
> > I'm not clear how this is all meant to work. Your intial patch says
> > this is an interface to pass "architecture-specific
> > attributes" from drivers through to the DMA mapping code, which is
> > fair enough - we want to do something similar.
> > 
> > But it's not clear that DMA_ATTR_SYNC_ON_WRITE is architecture
> > specific. If I was a driver writer might assume it works on all
> > platforms.
> 
> That would be a fair assumption. But it is required to be a NOP on
> platforms that don't need the "hint" ("attr" or whatever you want
> to call it). Specific architectures (SN2 in this case) will need
> to implement something.

To be honest, I still don't like the name.  SYNC_ON_WRITE is the SN2
implementation.  What it's actually doing is implementing strict
ordering semantics.  I think it should really be
DMA_ATTR_STRICT_ORDERING (with a corresponding
DMA_ATTR_RELAXED_ORDERING).

This means that if ever anyone sets a PCIe bridge to relaxed ordering by
default, this attribute will also work for them.

James


