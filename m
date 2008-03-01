Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbYCAHSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbYCAHSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 02:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYCAHSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 02:18:38 -0500
Received: from colo.lackof.org ([198.49.126.79]:43621 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYCAHSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 02:18:38 -0500
Date: Sat, 1 Mar 2008 00:18:24 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>, akepner@sgi.com,
       Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs()
	interface
Message-ID: <20080301071824.GC9373@colo.lackof.org>
References: <20080228032448.GS11012@sgi.com> <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com> <20080229182504.GA18102@colo.lackof.org> <1204310276.4003.48.camel@localhost.localdomain> <1204340204.15052.452.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204340204.15052.452.camel@pasglop>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 01:56:44PM +1100, Benjamin Herrenschmidt wrote:
...
> > This means that if ever anyone sets a PCIe bridge to relaxed ordering
> > by default, this attribute will also work for them.

Is this the same "relaxed ordering" defined in PCIe 1.0 specs?
If so, as explained before, use of "RO" bit in the DMA transactions
is up the the device and it MUST send a DMA transaction without
RO bit set to flush in-flight writes to the device. The host OS
does not have control over individual transactions, just the
general enablement of the feature. And "RO" bit should be
transperent to current applications including RDMA.

It's a very different issue than the SN2 node interconnect where
ALL transactions can be re-ordered by default and we have to do
something special to force ordering whene DMA writes are issued
to specific memory regions. The PCI device has no control over
this (unlike RO-bit discussed above).

hth,
grant

> But that would be asking for trouble no ? I would expect pretty much
> everything to break appart with relaxed by default no ? Or I don't fully
> understand what your arch calls "relaxed"...
> 
> I do agree that we should aim for simple semantics, they should cover
> 99% of the needs, and leave some bit space or attribute space for archs
> to define private ones when really needed.
> 
> In our case, I suspect that the two main thing we could define here for
> DMA that would be useful generally would be relaxed ordering (strict
> being the default) and maybe read prefetching (though that would be the
> default, maybe no prefetch). We -might- have use of separating relaxed
> ordering for read vs. writes, but that's pretty much it.
> 
> Cheers,
> Ben.
> 
