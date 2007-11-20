Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbXKTAfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbXKTAfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbXKTAez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:34:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:58834 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbXKTAey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:34:54 -0500
Subject: Re: SCSI breakage on non-cache coherent architectures
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk
In-Reply-To: <20071119.143115.251022325.davem@davemloft.net>
References: <1195450523.7022.37.camel@pasglop>
	 <20071119.003802.100741794.davem@davemloft.net>
	 <1195501874.6539.5.camel@pasglop>
	 <20071119.143115.251022325.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 11:34:24 +1100
Message-Id: <1195518864.6970.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-11-19 at 14:31 -0800, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Tue, 20 Nov 2007 06:51:14 +1100
> 
> > On Mon, 2007-11-19 at 00:38 -0800, David Miller wrote:
> > > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > Date: Mon, 19 Nov 2007 16:35:23 +1100
> > > 
> > > You could make a ____dma_cacheline_aligned and use that.
> > > It seems pretty reasonable.
> > 
> > I was thinking about that. What archs would need it ? arm, mips, what
> > else ?
> 
> The sparc32 port would need it too.

James preference seem to go for a revert of the patch that removed the
kmalloc of the buffer instead. Sounds definitely like an easier plan
for .24 (and maybe even backport to stable).

I'll produce a patch for that later today or tomorrow.

Do you still think we should introduce this __dma_cacheline_aligned ? Do
you see other cases of drivers where it would be useful ? It tend to
agree with your earlier statement that drivers doing that are broken and
should be using a separate allocator for DMA'ble objects (in fact, on
non-cache coherent archs, kmalloc is just fine).

Cheers,
Ben.


