Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbXJHN6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbXJHN6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 09:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbXJHN6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 09:58:40 -0400
Received: from n6.bullet.mud.yahoo.com ([216.252.100.57]:29329 "HELO
	n6.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751370AbXJHN6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 09:58:39 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 86414.39089.bm@omp105.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=zWL3Bv8aPMxsYEpXcvgJVbyUyTKfLiHMelCx6s0gyx0GdusxEQZGbSOWHa7uWVTRttVzcoslZfpJkxFZ/vwIO/DouxPOj1BvBCoz9zuZHZrxQOwsUbSf2PqXVEeMdwctGazCHTkQgbsnfD68dztvncRV/uC0K84SbinIS8K14PY=;
X-YMail-OSG: o.WehNUVM1nCqtNo2s_FEJxt3stXJhD4Xp27Yc9bA1mQfkb2hN2WldYED82ZO_LlKoJ7uzMeiDsm4REqm5x97a4PFTKXfb_biPwZLzQg.II.oH8BplM7fL0BbQ--
Date: Mon, 8 Oct 2007 14:58:31 +0100 (BST)
From: veerasena reddy <veerasena_b@yahoo.co.in>
Subject: Re: linux cache routines for Write-back cache policy on  MIPS24KE
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071003105751.GD29244@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <953878.89810.qm@web8402.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf,

thanks for the detailed information.
> Anyway, it would be much easier to help you if we
> knew what you are trying
> to achieve with these functions.

Basically our target has a MIPS24KE host processor on
which Linux runs and a networking processor (NP) which
sits between the EMAC contoller and the host processor
to receive/transmit the data/packets.

This peripheral networking processor uses the physical
addresses only. We are using write-back caching policy
on MIPS24KE. So,
1. when we want to transmit the packet from the host
to peripheral processor, we need to convert packet
buffer into physical address (CPHYSADDR) and put it
into the NP's Tx queue, which will be sent to EMAC.
Before converting into physical address we need to
flush the corresponding cache entries.
Which API should be used to achieve the above
functionlaity in Linux-2.6.18 kernel?

2.Similarly in receivng path, the peripheral processor
gives the physical address of the buffer containing
the received packet. So, on host we need to convert
this physical address into cached address (KSEG0ADDR).
Before converting to cached address we need to
invalidate the corresponding cache entries.

Which API should be used to achieve the above
functionlaity in Linux-2.6.18 kernel?

currently we are using dma_cache_wback_inv() to
achieve above two functionalities. 
Could you please suggest us the right API to be used?

Thanks in advance.

Regards,
Veerasena.

--- Ralf Baechle <ralf@linux-mips.org> wrote:

> On Mon, Oct 01, 2007 at 01:10:59PM +0100, veerasena
> reddy wrote:
> 
> > Is there any problem if we use the below API's in
> > linxu-2.6.18 
> >   - dma_cache_wback_inv()
> >   - dma_cache_wback()
> >   - dma_cache_inv()
> > 
> > functionality wise, especially in r4k.c i dont see
> any
> > difference between the implementation of these
> APIs.
> > 
> > Can we apply the 2.6.24 patch to kill these APIs
> on
> > 2.6.18 kernel? In this case what APIs i can use
> for
> > writeback, invalidation or both?
> > 
> > I couldn't find any info. related to the above API
> in
> > DMA-API.txt. Could you please give some pointers
> on
> > the usage/working of these APIs.
> 
> dma_cache_* were never documented.  They respresent
> the earliest attempt
> at coming up with an API that enables portable
> drivers and it has a few
> shortcomings and like so many early things it was
> never formally documented,
> so don't expect any well defined semantics.  The
> functions never got
> formally retired probably because it somehow managed
> to stay under the
> radar.
> 
> Any drivers should use the APIs documented in
> Documentation/DMA-API.txt
> only.  The almost equivalent operation for
> dma_cache_* would be
> dma_sync_single and dma_sync_sg.
> 
> Don't even dream about using dma_cache_* for
> anything but DMA coherency.
> They're all internal low level APIs which know
> nothing about Linux's
> virtual memory system.
> 
> Anyway, it would be much easier to help you if we
> knew what you are trying
> to achieve with these functions.
> 
>   Ralf
> 



      Chat on a cool, new interface. No download required. Go to http://in.messenger.yahoo.com/webmessengerpromo.php

