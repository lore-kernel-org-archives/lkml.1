Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbXJ2Imq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbXJ2Imq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 04:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbXJ2Imi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 04:42:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49007 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbXJ2Imi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 04:42:38 -0400
Message-ID: <47259CFB.2090106@garzik.org>
Date: Mon, 29 Oct 2007 04:42:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Abit F-190HD Onboard rlt8169 Ethernet Controller
References: <20071029061532.5d10dfc6@snowcone> <20071029083333.18a4dab7@the-village.bc.nu>
In-Reply-To: <20071029083333.18a4dab7@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> A vendor ID of 1 is very very very broken. Do all boards have this or do
> you have a faulty box (perhaps a misprogrammed EEPROM somewhere)

>>  	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8136), 0, 0, RTL_CFG_2 },
>>  	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8167), 0, 0, RTL_CFG_0 },
>>  	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8168), 0, 0, RTL_CFG_1 },
>> +	{ PCI_DEVICE(PCI_ANY_ID,		0x8168), 0, 0, RTL_CFG_2 },

> That will match any device 0x8168 not just a realtek one. I'd use 0x0001,
> 0x8168 for the match. However I'd seriously consider checking another
> board as I suspect you simply have a return candidate.

Amusingly, 8139too had to deal with the exact same problem.  At the 
time, we chose to obtain the subsystem vendor/device ids, and list them 
that way:

         /* some crazy cards report invalid vendor ids like
          * 0x0001 here.  The other ids are valid and constant,
          * so we simply don't match on the main vendor id.
          */
         {PCI_ANY_ID, 0x8139, 0x10ec, 0x8139, 0, 0, RTL8139 },
         {PCI_ANY_ID, 0x8139, 0x1186, 0x1300, 0, 0, RTL8139 },
         {PCI_ANY_ID, 0x8139, 0x13d1, 0xab06, 0, 0, RTL8139 },

Given that the subsystem vendor ids in particular were sane and valid in 
each case, this seemed narrow enough to avoid false positives.


Regardless, I agree with your "you...have a return candidate" comment.

	Jeff


