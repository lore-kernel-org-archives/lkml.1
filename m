Return-Path: <linux-kernel-owner+w=401wt.eu-S932558AbYCADBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbYCADBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 22:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYCADBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 22:01:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:43880 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbYCADBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 22:01:14 -0500
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs()
	interface
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>, akepner@sgi.com,
       Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1204310276.4003.48.camel@localhost.localdomain>
References: <20080228032448.GS11012@sgi.com>
	 <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com>
	 <20080229182504.GA18102@colo.lackof.org>
	 <1204310276.4003.48.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 01 Mar 2008 13:56:44 +1100
Message-Id: <1204340204.15052.452.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 12:37 -0600, James Bottomley wrote:
> To be honest, I still don't like the name.  SYNC_ON_WRITE is the SN2
> implementation.  What it's actually doing is implementing strict
> ordering semantics.  I think it should really be
> DMA_ATTR_STRICT_ORDERING (with a corresponding
> DMA_ATTR_RELAXED_ORDERING).
> 
> This means that if ever anyone sets a PCIe bridge to relaxed ordering
> by
> default, this attribute will also work for them.

But that would be asking for trouble no ? I would expect pretty much
everything to break appart with relaxed by default no ? Or I don't fully
understand what your arch calls "relaxed"...

I do agree that we should aim for simple semantics, they should cover
99% of the needs, and leave some bit space or attribute space for archs
to define private ones when really needed.

In our case, I suspect that the two main thing we could define here for
DMA that would be useful generally would be relaxed ordering (strict
being the default) and maybe read prefetching (though that would be the
default, maybe no prefetch). We -might- have use of separating relaxed
ordering for read vs. writes, but that's pretty much it.

Cheers,
Ben.


