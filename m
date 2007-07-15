Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbXGOHk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbXGOHk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 03:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbXGOHkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 03:40:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48832 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbXGOHkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 03:40:15 -0400
Message-ID: <4699CF56.7010304@garzik.org>
Date: Sun, 15 Jul 2007 03:40:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: surya.prabhakar@wipro.com
CC: caglar@pardus.org.tr, linux-kernel@vger.kernel.org, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/12] drivers/isdn/hisax/avm_pci.c: replace pci_find_device
 with pci_get_device
References: <200707140144.20855.caglar@pardus.org.tr> <46996D12.40501@garzik.org> <A94AD757879CE142B7CEBC3E6FF5D3EC015DAC49@BLR-EC-MBX02.wipro.com> <4699A9AD.2050206@garzik.org>
In-Reply-To: <4699A9AD.2050206@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To be more clear, your solution is incorrect unless the pci_dev_put() 
occurs after the last reference to hw.{elsa,diva,hfc,njet,...}.dev, 
which is where the HiSax ISDN drivers store their reference to struct 
pci_dev during the runtime life of the PCI device.

Am I missing where your patch does this?

By way of further interest, a few hours _before_ (yes, really) I saw 
your patches, I resumed converting the ISDN HiSax PCI drivers to use the 
PCI driver API.  You can find this work in 
git://git.kernel.org/.../jgarzik/misc-2.6.git#isdn-pci.

If you fix your patches' lifetime problems, I will ACK them myself, 
since my effort is a spare time effort.  But just wanted you to be aware 
that I am deep into the code you are fixing, and can at least speak 
somewhat knowledgeably on the specific lines of code you are changing.

	Jeff



