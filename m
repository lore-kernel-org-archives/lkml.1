Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbXGOKIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbXGOKIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 06:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758191AbXGOKIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 06:08:41 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:47938 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbXGOKIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 06:08:40 -0400
Subject: Re: [PATCH 1/12] drivers/isdn/hisax/avm_pci.c: replace
	pci_find_device with pci_get_device
From: Surya Prabhakar N <surya.prabhakar@wipro.com>
Reply-To: surya.prabhakar@wipro.com
To: Jeff Garzik <jeff@garzik.org>
Cc: caglar@pardus.org.tr, linux-kernel@vger.kernel.org, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       akpm <akpm@linux-foundation.org>
In-Reply-To: <4699CF56.7010304@garzik.org>
References: <200707140144.20855.caglar@pardus.org.tr>
	 <46996D12.40501@garzik.org>
	 <A94AD757879CE142B7CEBC3E6FF5D3EC015DAC49@BLR-EC-MBX02.wipro.com>
	 <4699A9AD.2050206@garzik.org>  <4699CF56.7010304@garzik.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Coe, Wipro Technologies
Date: Sun, 15 Jul 2007 15:41:49 +0530
Message-Id: <1184494309.18254.16.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 15 Jul 2007 10:08:38.0027 (UTC) FILETIME=[1CADF5B0:01C7C6C8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 03:40 -0400, Jeff Garzik wrote:
> To be more clear, your solution is incorrect unless the pci_dev_put() 
> occurs after the last reference to hw.{elsa,diva,hfc,njet,...}.dev, 
> which is where the HiSax ISDN drivers store their reference to struct 
> pci_dev during the runtime life of the PCI device.
> 
> Am I missing where your patch does this?
It is really missing :-(
> 
> By way of further interest, a few hours _before_ (yes, really) I saw 
> your patches, I resumed converting the ISDN HiSax PCI drivers to use the 
> PCI driver API.  You can find this work in 
> git://git.kernel.org/.../jgarzik/misc-2.6.git#isdn-pci.
> 
> If you fix your patches' lifetime problems, I will ACK them myself, 
> since my effort is a spare time effort.  But just wanted you to be aware 
> that I am deep into the code you are fixing, and can at least speak 
> somewhat knowledgeably on the specific lines of code you are changing.
I can see the bug. Thanks for updating me. I really missed the point
that these whole set of drivers are a part of hisax.ko...

most of the initialization is done in hisax/config.c
Now are you suggesting that we should have a pci_dev_put in config.c
where you have the module_exit.

I am not sure where I can call the dev_put.
consider hisax/avm_pci.c  

in which if we have a code like the below
dev_avm = pci_get_device(PCI_VENDOR_ID_AVM,
		PCI_DEVICE_ID_AVM_A1,  dev_avm))) {

dev_avm is getting initialized in this file 
static struct pci_dev *dev_avm __devinitdata = NULL;

so can I do an
extern static struct pci_dev *dev_avm; 
in the config.c 

and call pci_dev_put(dev_avm) in config.c file's module_exit or
whereever there is an error return?


> 
> 	Jeff
> 
> 
> 
-surya.
