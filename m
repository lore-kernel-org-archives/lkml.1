Return-Path: <linux-kernel-owner+w=401wt.eu-S933392AbYCADM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392AbYCADM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 22:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbYCADMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 22:12:19 -0500
Received: from outbound-mail-37.bluehost.com ([69.89.20.191]:49779 "HELO
	outbound-mail-37.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750909AbYCADMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 22:12:18 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs() interface
Date: Fri, 29 Feb 2008 19:11:32 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>, akepner@sgi.com,
       Tony Luck <tony.luck@intel.com>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
References: <20080228032448.GS11012@sgi.com> <1204310276.4003.48.camel@localhost.localdomain> <1204340204.15052.452.camel@pasglop>
In-Reply-To: <1204340204.15052.452.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802291911.33646.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 29, 2008 6:56 pm Benjamin Herrenschmidt wrote:
> On Fri, 2008-02-29 at 12:37 -0600, James Bottomley wrote:
> > To be honest, I still don't like the name.  SYNC_ON_WRITE is the SN2
> > implementation.  What it's actually doing is implementing strict
> > ordering semantics.  I think it should really be
> > DMA_ATTR_STRICT_ORDERING (with a corresponding
> > DMA_ATTR_RELAXED_ORDERING).
> >
> > This means that if ever anyone sets a PCIe bridge to relaxed ordering
> > by
> > default, this attribute will also work for them.
>
> But that would be asking for trouble no ? I would expect pretty much
> everything to break appart with relaxed by default no ? Or I don't fully
> understand what your arch calls "relaxed"...

Depends on how the device completes commands and what the driver does to check 
for completion.  It would probably work fine in many cases.

> I do agree that we should aim for simple semantics, they should cover
> 99% of the needs, and leave some bit space or attribute space for archs
> to define private ones when really needed.
>
> In our case, I suspect that the two main thing we could define here for
> DMA that would be useful generally would be relaxed ordering (strict
> being the default) and maybe read prefetching (though that would be the
> default, maybe no prefetch). We -might- have use of separating relaxed
> ordering for read vs. writes, but that's pretty much it.

Sounds about right.  I've got to poke the PCIe 3.0 folks again about some of 
the potential ordering changes there; hopefully we can cover that stuff too 
with Arthur's approach.

Jesse
