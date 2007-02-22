Return-Path: <linux-kernel-owner+w=401wt.eu-S1751418AbXBVFrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbXBVFrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 00:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbXBVFrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 00:47:21 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:38629 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbXBVFrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 00:47:20 -0500
Date: Wed, 21 Feb 2007 23:45:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] ACPI driver support for pata
In-reply-to: <fa.IjFXvdcBtWXV65pRZipPd0NVTOA@ifi.uio.no>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: jgarzik@pobox.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Message-id: <45DD2E12.6000705@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.IjFXvdcBtWXV65pRZipPd0NVTOA@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> - Add a driver for motherboard ACPI method devices
> - Link it after normal drivers so ACPI is not preferred
> - Hook the AMD driver to prefer ACPI for the Nvidia devices if ACPI is
> active
> - While we are at it fix up the simplex clear the AMD driver.
> 
> Depends upon the set_mode -> do_set_mode wrapper patch
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

I tried out 2.6.21-rc1 with the pata_acpi patch. First off, when you 
enable pata_acpi, it appears that the Fedora mkinitrd stuff decides that 
that should be loaded as the first driver. On boot it promptly attempts 
to attach to all of the ATA controllers, including the nForce SATA 
controllers, which somehow it fails to actually drive causing a failure 
to mount the root filesystem. I got around that by blacklisting 
pata_acpi in /etc/modprobe.conf before installing the kernel and 
un-blacklisting it afterwards, so it wouldn't make the initrd try and 
load it, but there must be a better solution.

It does seem to drive the PATA controllers, but the cable detection 
doesn't seem to be working:

scsi5 : pata_acpi
ata5.00: ATAPI, max UDMA/66
ata5.00: limited to UDMA/33 due to 40-wire cable
ata5.00: configured for UDMA/33

I can assure you that is an 80-wire cable on that device :-) I suppose 
next step is adding debug to see where it is having issues?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

