Return-Path: <linux-kernel-owner+w=401wt.eu-S932935AbXBVG7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbXBVG7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 01:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXBVG7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 01:59:03 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34482 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbXBVG7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 01:59:01 -0500
Message-ID: <45DD3F20.7050907@pobox.com>
Date: Thu, 22 Feb 2007 01:58:40 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Alan <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI driver support for pata
References: <fa.IjFXvdcBtWXV65pRZipPd0NVTOA@ifi.uio.no> <45DD2E12.6000705@shaw.ca>
In-Reply-To: <45DD2E12.6000705@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Alan wrote:
>> - Add a driver for motherboard ACPI method devices
>> - Link it after normal drivers so ACPI is not preferred
>> - Hook the AMD driver to prefer ACPI for the Nvidia devices if ACPI is
>> active
>> - While we are at it fix up the simplex clear the AMD driver.
>>
>> Depends upon the set_mode -> do_set_mode wrapper patch
>>
>> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> I tried out 2.6.21-rc1 with the pata_acpi patch. First off, when you 
> enable pata_acpi, it appears that the Fedora mkinitrd stuff decides that 
> that should be loaded as the first driver. On boot it promptly attempts 
> to attach to all of the ATA controllers, including the nForce SATA 
> controllers, which somehow it fails to actually drive causing a failure 
> to mount the root filesystem. I got around that by blacklisting 
> pata_acpi in /etc/modprobe.conf before installing the kernel and 
> un-blacklisting it afterwards, so it wouldn't make the initrd try and 
> load it, but there must be a better solution.
> 
> It does seem to drive the PATA controllers, but the cable detection 
> doesn't seem to be working:
> 
> scsi5 : pata_acpi
> ata5.00: ATAPI, max UDMA/66
> ata5.00: limited to UDMA/33 due to 40-wire cable
> ata5.00: configured for UDMA/33

Honestly I don't think pata_acpi is the best way to go.

Unless we know /nothing/ about the controller (not true, in sata_nv 
case), I think it would be better to initiate ACPI actions from specific 
drivers, rather than forcing the user to switch from pata_amd to pata_acpi.

	Jeff



