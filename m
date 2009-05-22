Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbZEVSz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbZEVSz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 14:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZEVSzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 14:55:47 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:53451 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZEVSzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 14:55:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=OccwjNP1Wz2yZI4ZqmG0WoCOwjl2k2F4T6U71l+lad/txhRVSX+0IISfNwfSyr/DDg
         XacjdUQe2YLqTecV3kCQQoC8mtvgbotyTkls4FM9j1EOkLKZabMEEWgghxVYSdPLueds
         fMJWsSjNBNk/bbH8+SGEYlkXAQ5FpRcwgZVNI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-m68k@vger.kernel.org
Subject: ->ack_intr in m68k IDE drivers  [was: Re: [PATCH 2/5] ide: ->ide_dma_clear_irq() -> ->clear_irq()]
Date: Fri, 22 May 2009 20:44:42 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200808192031.40288.bzolnier@gmail.com> <48CEDD89.5060107@ru.mvista.com> <4A15600A.40906@ru.mvista.com>
In-Reply-To: <4A15600A.40906@ru.mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905222044.42688.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 May 2009 16:07:06 Sergei Shtylyov wrote:
> Hello, I wrote:
> 
> >>> * Rename ->ide_dma_clear_irq method to ->clear_irq
> >>>   and move it from ide_hwif_t to struct ide_port_ops.
> 
> >>> * Move ->waiting_for_dma check inside ->clear_irq method.
> 
> >>> * Move ->dma_base check inside ->clear_irq method.
> 
> >>> piix.c:
> >>> * Add ich_port_ops and remove init_hwif_ich() wrapper.
> 
> >>> There should be no functional changes caused by this patch.
> 
> [...]
> 
> >>   It may also be worth considering turning this method into 
> >> test-and-clear, so that we can get the actual IDE interrupt state on 
> >> the chips that implement this...
> 
> >   Probably might add the test_irq() method to be called on 
> > !hwif->waiting_for_dma. Cleraing the status at once seems impractical...
> 
>     Yet this seems what ack_intr() method is doing already...
>     What it does is testing IRQ status and "acknowledging" it (the semantics 
> of "acknowledge" is not clear to me, yet it seems that it's clearing the 
> interrupt latch in the drivers where it's implemented). And the call site of 
> ack_intr() method corresponds to where test_irq() should have been called, 
> so it seems we don't need yet another method and probably didn't even need 
> clear_irq() method in the first place?..

They have different goals -- the main purpose of ack_intr() (despite its name)
seems to be testing whether the IRQ is ours, OTOH in clear_irq() we know that
already and we just want to clear the pending IRQ status.

So I'm not sure if unification is desirable... though some improvements are
definitely possibly there (less confusing naming at least)...

>     Bart, could you clarify about how ack_intr() is supposed to work?

Good question, m68k list would be the best place to look for an answer..
