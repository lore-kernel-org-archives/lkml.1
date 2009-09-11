Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbZIKO7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbZIKO7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZIKO7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:59:45 -0400
Received: from smtp35.dc2.safesecureweb.com ([208.112.85.230]:41225 "EHLO
	smtp35.dc2.safesecureweb.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186AbZIKO7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:59:45 -0400
X-Greylist: delayed 1035 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2009 10:59:45 EDT
Message-ID: <433DD7EA0883478C9A18E5443FD1B328@Route495PC>
From: "Richard B. Johnson" <RJohnson@Route495Software.com>
To: <markh@compro.net>, <linux-pci@vger.kernel.org>
Cc: "Mark Hounschell" <dmarkh@cfl.rr.com>, <linux-kernel@vger.kernel.org>
References: <4AAA5B1F.3020103@compro.net>
In-Reply-To: <4AAA5B1F.3020103@compro.net>
Subject: Re: problems doing direct dma from a pci device to pci-e device
Date: Fri, 11 Sep 2009 10:41:53 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6001.18000
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6001.18049
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Mark Hounschell" <markh@compro.net>
To: <linux-pci@vger.kernel.org>
Cc: "Mark Hounschell" <dmarkh@cfl.rr.com>; <linux-kernel@vger.kernel.org>
Sent: Friday, September 11, 2009 10:13 AM
Subject: problems doing direct dma from a pci device to pci-e device


>I know this is really just a pci issue but have CC'd LKML just in case. 
>Sorry LKML for the noise.
>
> I have a situation where a card on a regular PCI bus (Compro gpiohsd) does 
> dma's
> directly into another PCI cards memory (VMIC-5565 reflective memory) 
> living on
> another PCI bus. These 2 cards are sometimes seperated by many bridges.
> Expansion racks etc. We've been doing this forever. No problem (mostly).
>
> I now have an AM3 based DFI DK 790FXB-M3H5 motherboard. This board has 3 
> regular
> PCI slots and 3 PCI-E (16x) slots. I also have a PCI-E (x4) version of the 
> VMIC-5565
> reflective memory  card in one of the PCI-E slots and our gpiohsd card in 
> one of the regular
> PCI slots. All on the motherboard. No expansion slots being used. However 
> I cannot get
> data from our gpiohsd into the PCI-E VMIC-5565 cards memory. I can 
> certainly get the data there
> from a userland buffer, no problem. Just not from one card to the other 
> directly. Oh and when
> I put the regular PCI version of the VMIC into one of the regular PCI 
> slots everything works
> as expected. They are then both on the same PCI bus and no bridges are 
> involved though.
>

[SNIPPED...]

Please check your software to make sure that after the DMA has presumed to 
complete, you READ something from the destination PCI bus address! With so 
many PCI writes queued, they may all be stuck in the many hardware FIFOs and 
the sure way to complete the writes is to perform a read.
Cheers,
Richard B. Johnson
http://Route495Software.com/




