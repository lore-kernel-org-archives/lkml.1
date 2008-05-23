Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbYEVOZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbYEVOZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 10:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYEVOZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 10:25:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:39878 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbYEVOZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 10:25:27 -0400
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: scottwood@freescale.com, linuxppc-dev@ozlabs.org, tpiepho@freescale.com,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080520.155326.195407196.davem@davemloft.net>
References: <4833524C.3040207@freescale.com>
	 <20080520.153947.84346222.davem@davemloft.net>
	 <4833542E.3040608@freescale.com>
	 <20080520.155326.195407196.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 23 May 2008 00:24:43 -0400
Message-Id: <1211516683.8297.271.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-20 at 15:53 -0700, David Miller wrote:
> From: Scott Wood <scottwood@freescale.com>
> Date: Tue, 20 May 2008 17:43:58 -0500
> 
> > David Miller wrote:
> > > The __volatile__ in the asm construct disallows movement of the
> > > inline asm relative to statements surrounding it.
> > > 
> > > The only reason barrier() in kernel.h needs a memory clobber is
> > > because of a bug in ancient versions of gcc.  In fact, I think
> > > that memory clobber might even be removable.
> > 
> > Current versions of GCC seem quite happy to move non-asm memory accesses 
> > around a volatile asm without a memory clobber; see the test Trent posted.
> 
> Indeed, and even the GCC manual is clear about this.

So what is the scope of that problem ?

IE. Take an x86 version of that test, writing to memory, doing a writel
to some MMIO, then another memory write, can those be re-ordered with
the current x86 version of writel ?

static inline void writel(unsigned int b, volatile void __iomem *addr)
{
	*(volatile unsigned int __force *)addr = b;
}

This is becoming a serious issue...

Ben.

