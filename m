Return-Path: <linux-kernel-owner+w=401wt.eu-S1765516AbZFPGRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765516AbZFPGRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZFPGRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:17:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:33898 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbZFPGRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:17:11 -0400
Date: Tue, 16 Jun 2009 15:16:37 +0900
To: joerg.roedel@amd.com
Cc: stefanr@s5r6.in-berlin.de, ben-linux@fluff.org,
       linux-kernel@vger.kernel.org
Subject: Re: dma-debug: check_for_stack background?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090615081355.GA5139@amd.com>
References: <20090614212018.GD20442@fluff.org.uk>
	<4A356F0E.9020809@s5r6.in-berlin.de>
	<20090615081355.GA5139@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090616151628V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 16 Jun 2009 15:16:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 10:13:55 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Sun, Jun 14, 2009 at 11:43:42PM +0200, Stefan Richter wrote:
> > Ben Dooks wrote:
> >> On Sun, Jun 14, 2009 at 08:56:29PM +0200, Stefan Richter wrote:
> >>> the DMA debug facility warns  about mappings of on-stack memory.  
> >>> What's the problem with that?
> > ...
> >> I'm not sure if it is possible on all architectures, however the
> >> DMA mapping documentation prohibts the use of stack memory.
> >
> > Ah, it has all been documented in plain sight for ages.  Thanks for the  
> > pointer.
> 
> Problem is that the stack might go away or could be otherwise reused
> while the DMA is in-flight. This could cause really hard to debug
> problems.

Not true. Even if you use the stack buffer for DMA synchronously, it
doesn't work (we had the bad code like starting dma and waiting for
the completion).

On some architectures, we can't use the stack buffer for DMA. That's
why the DMA mapping documentation prohibits the use of stack memory
for DMA.
