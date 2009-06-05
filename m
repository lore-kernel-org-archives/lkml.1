Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbZFEAwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbZFEAwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZFEAwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:52:40 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:38563 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZFEAwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:52:39 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 19:52:34 -0500
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041529.49997.lkml@morethan.org> <4A2867C1.90408@gmail.com>
In-Reply-To: <4A2867C1.90408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041952.39569.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, Robert Hancock wrote:
> Michael S. Zick wrote:
> > On Thu June 4 2009, Andi Kleen wrote:
> >> Harald Welte <HaraldWelte@viatech.com> writes:
> >>> why would it matter on UP? as indicated, I'm not the expert here, but I thought
> >>> memory ordering issues only arise in SMP systems [or possibly with regard to
> >>> DMA, but as we already explored much earlier in this thread, drivers that access
> >>> DMA buffers whil the hardware owns them are buggy and need to be fixed]
> >> Sorry we didn't establish that. Accessing data structures that are
> >> also accessed by DMA hardware is pretty common in fact and memory
> >> ordering issues also come up regularly (e.g. all the infamous PCI
> >> posting bugs)
> >>
> >> What we established is that the drivers don't use LOCK for it
> >> (or at least we think that's very unlikely)
> >>
> > 
> > It was a real headache in the pa-risc port - -
> > Even went so far as to build some experimental kernels where all
> > the spin-lock structures where in a separate loader section.
> > 
> > That was to avoid in-direct interference - I.E: Both DMA and
> > the processor handling the locking **both** invalidating the
> > same cache line at the same time (only one can win).
> > 
> > Things might get that deep with this processor/chip-set combination;
> > but pa-risc has some very unusual hardware in some older models.
> 
> That sort of thing should be architecturally impossible on x86. In order 
> for something to invalidate the cache line, it first has to own it 
> (except maybe for some unusual cases like Memory Write and Invalidate 
> where the writer promises to overwrite the entire cache line).
> 
> 

VIA has not publicly published sufficient technical information to presume
that the cache coherency control protocols are the same as Intel's.

These are cpu/chipset pairs - Think System On 2 Chips. SoS2C.

Mike
Mike
