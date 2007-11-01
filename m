Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbXKAQdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbXKAQdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbXKAQdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:33:40 -0400
Received: from ex8.myhostedexchange.com ([69.50.2.12]:29772 "EHLO
	ex8.myhostedexchange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbXKAQdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:33:39 -0400
X-Greylist: delayed 971 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 12:33:39 EDT
Message-ID: <4729FC36.3040000@gmail.com>
Date: Thu, 01 Nov 2007 09:17:58 -0700
From: Josh Logan <joshtlogan@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Abit F-190HD Onboard rlt8169 Ethernet Controller
References: <20071029061532.5d10dfc6@snowcone> <20071029083333.18a4dab7@the-village.bc.nu>
In-Reply-To: <20071029083333.18a4dab7@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2007 16:17:27.0759 (UTC) FILETIME=[B20DD5F0:01C81CA2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> It is not recognised by 2.6.24-rc1. I'm guessing it's because the
>> vendor ID is 0001 rather than something sensible. I patched the kernel
>> as follows:
> 
> A vendor ID of 1 is very very very broken. Do all boards have this or do
> you have a faulty box (perhaps a misprogrammed EEPROM somewhere)
> 
>> --- drivers/net/r8169.c.orig	2007-10-29 05:37:02.000000000 +0000
>> +++ drivers/net/r8169.c	2007-10-29 05:54:30.000000000 +0000
>> @@ -165,6 +165,7 @@
>>  	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8136), 0, 0, RTL_CFG_2 },
>>  	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8167), 0, 0, RTL_CFG_0 },
>>  	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8168), 0, 0, RTL_CFG_1 },
>> +	{ PCI_DEVICE(PCI_ANY_ID,		0x8168), 0, 0, RTL_CFG_2 },
> 
> That will match any device 0x8168 not just a realtek one. I'd use 0x0001,
> 0x8168 for the match. However I'd seriously consider checking another
> board as I suspect you simply have a return candidate.
> 

I have had this board for a few months as well and I have needed to 
patch the driver to use 0x0001 as well.

							Later, JOSH
