Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYFJOez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYFJOez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYFJOer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:34:47 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:58058 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbYFJOeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:34:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Date: Tue, 10 Jun 2008 16:34:21 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Miles Lane" <miles.lane@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
References: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com> <200806101623.34082.mb@bu3sch.de> <19f34abd0806100729h7a060012h91e81248c9c7cdca@mail.gmail.com>
In-Reply-To: <19f34abd0806100729h7a060012h91e81248c9c7cdca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101634.21576.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 16:29:17 Vegard Nossum wrote:
> On Tue, Jun 10, 2008 at 4:23 PM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Tuesday 10 June 2008 16:09:37 Miles Lane wrote:
> >> BUG: unable to handle kernel NULL pointer dereference at 00000000
> >> IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
> >
> >
> > It seems to crash at
> >  60 extern const struct dma_mapping_ops *dma_ops;
> >  61
> >  62 static inline int dma_mapping_error(dma_addr_t dma_addr)
> >  63 {
> >  64         if (dma_ops->mapping_error)
> >  65                 return dma_ops->mapping_error(dma_addr);
> >  66
> >  67         return (dma_addr == bad_dma_address);
> >  68 }
> 
> No, this is wrong.
> 
> /* Check if a DMA mapping address is invalid. */
> static bool b43_dma_mapping_error(struct b43_dmaring *ring,
>                                   dma_addr_t addr,
>                                   size_t buffersize, bool dma_to_device)
> {
>         if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
> 
> It crashes on this line ---^

Which calls dma_mapping_error(), correct?

But you are right. I see the bug now.
ring->dev is assigned after the call.
I wonder why it works reliably on all of my machines.

-- 
Greetings Michael.
