Return-Path: <linux-kernel-owner+w=401wt.eu-S935582AbYETWnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935582AbYETWnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935282AbYETWjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:39:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56207
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935163AbYETWjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:39:52 -0400
Date: Tue, 20 May 2008 15:39:47 -0700 (PDT)
Message-Id: <20080520.153947.84346222.davem@davemloft.net>
To: scottwood@freescale.com
Cc: alan@lxorguk.ukuu.org.uk, tpiepho@freescale.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
From: David Miller <davem@davemloft.net>
In-Reply-To: <4833524C.3040207@freescale.com>
References: <483344C0.3020703@freescale.com>
	<20080520231516.76b924a2@core>
	<4833524C.3040207@freescale.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Wood <scottwood@freescale.com>
Date: Tue, 20 May 2008 17:35:56 -0500

> Alan Cox wrote:
> >> It looks like we rely on -fno-strict-aliasing to prevent reordering 
> >> ordinary memory accesses (such as to DMA descriptors) past the I/O 
> > 
> > DMA descriptors in main memory are dependant on cache behaviour anyway
> > and the dma_* operators should be the ones enforcing the needed behaviour.
> 
> What about memory obtained from dma_alloc_coherent()?  We still need a 
> sync and a compiler barrier.  The current I/O accessors have the former, 
> but not the latter.

The __volatile__ in the asm construct disallows movement of the
inline asm relative to statements surrounding it.

The only reason barrier() in kernel.h needs a memory clobber is
because of a bug in ancient versions of gcc.  In fact, I think
that memory clobber might even be removable.

