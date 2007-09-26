Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbXIZLmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbXIZLmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbXIZLmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:42:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44967 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbXIZLmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:42:06 -0400
Message-ID: <46FA4587.4070105@garzik.org>
Date: Wed, 26 Sep 2007 07:41:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Peer Chen <peerchen@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ahci: enable GHC.AE bit before set GHC.HR
References: <200709211327569648280@gmail.com>	<46F9DA07.4080201@garzik.org> <20070926122332.39351382@the-village.bc.nu>
In-Reply-To: <20070926122332.39351382@the-village.bc.nu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 26 Sep 2007 00:03:19 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Peer Chen wrote:
>>> According to the description of section 5.2.2.1 and 10.1.2 of AHCI specification rev1_1/rev1_2, GHC.HR shall only be set to ¡®1¡¯
>>> by software when GHC.AE is set to ¡®1¡¯.
>>>
>>> Signed-off-by: Peer Chen <peerchen@gmail.com>
>>> ---
>>> --- linux-2.6.23-rc7/drivers/ata/ahci.c.orig	2007-09-20 11:01:55.000000000 -0400
>>> +++ linux-2.6.23-rc7/drivers/ata/ahci.c	2007-09-20 11:07:31.000000000 -0400
>>> @@ -834,6 +834,10 @@ static int ahci_reset_controller(struct 
>>>  	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
>>>  	u32 tmp;
>>>  
>>> +        /* turn on AHCI mode before controller reset*/
>>> +        writel(HOST_AHCI_EN, mmio + HOST_CTL);
>>> +        (void) readl(mmio + HOST_CTL);  /* flush */
>> applied the attached patch, inspired by yours.
> 
> 
> NAK - mmio is an iomap so writel and readl are the wrong things to use

The patch is consistent with the rest of the driver.

You are welcome to submit a patch to convert ahci to using ioremap.

	Jeff



