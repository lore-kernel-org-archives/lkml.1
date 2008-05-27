Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbYE0WCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbYE0WCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759154AbYE0WCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:02:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759091AbYE0WCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:02:33 -0400
Date: Tue, 27 May 2008 15:02:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <20080527215328.GB22636@parisc-linux.org>
Message-ID: <alpine.LFD.1.10.0805271459550.2958@woody.linux-foundation.org>
References: <1211852026.3286.36.camel@pasglop> <20080526.184047.88207142.davem@davemloft.net> <1211854540.3286.42.camel@pasglop> <20080526.192812.184590464.davem@davemloft.net> <1211859542.3286.46.camel@pasglop> <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
 <1211922621.3286.80.camel@pasglop> <alpine.LFD.1.10.0805271421570.2958@woody.linux-foundation.org> <20080527223822.57306677@core> <20080527215328.GB22636@parisc-linux.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 May 2008, Matthew Wilcox wrote:

> On Tue, May 27, 2008 at 10:38:22PM +0100, Alan Cox wrote:
> > > re-ordering, even though I doubt it will be visible in practice. So if you 
> > > use the "__" versions, you'd better have barriers even on x86!
> > 
> > Are we also going to have __ioread*/__iowrite* ?
> 
> Didn't we already define ioread*() to have loose semantics?

They are supposed to have the same semantics as readl/writel.

And yes, it's "loose", but only when compared to inb/outb (which are 
really very strict, if you want to emulate x86 - an "outb" basically is 
not only ordered, it doesn't even post the write, and waits until it has 
hit the bus!)

		Linus
