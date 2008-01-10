Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYAJElB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYAJElB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 23:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYAJEku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 23:40:50 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48794 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbYAJEkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 23:40:49 -0500
Message-ID: <4785A1CF.7050006@garzik.org>
Date: Wed, 09 Jan 2008 23:40:47 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matthew Hall <mhall@mhcomputing.net>
CC: linux-scsi@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sata_nv does not function in kernel > 2.6.20.21
References: <20080110024733.GC9461@mhcomputing.net>
In-Reply-To: <20080110024733.GC9461@mhcomputing.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Hall wrote:
> ACPI: PCI Interrupt Link [LT3D] enabled at IRQ 46
> ACPI: PCI Interrupt 0000:80:07.0[A] -> Link [LT3D] -> GSI 46 (level,
> low) -> IRQ 46
> sata_nv 0000:80:07.0: Using ADMA mode
> PCI: Unable to reserve mem region #6:1000@dfefe000 for device
> 0000:80:07.0
> ACPI: PCI interrupt for device 0000:80:07.0 disabled
> sata_nv: probe of 0000:80:07.0 failed with error -16
> ACPI: PCI Interrupt Link [LT2E] enabled at IRQ 45
> ACPI: PCI Interrupt 0000:80:08.0[A] -> Link [LT2E] -> GSI 45 (level,
> low) -> IRQ 45
> sata_nv 0000:80:08.0: Using ADMA mode
> PCI: Unable to reserve mem region #6:1000@dfefd000 for device
> 0000:80:08.0
> ACPI: PCI interrupt for device 0000:80:08.0 disabled
> sata_nv: probe of 0000:80:08.0 failed with error -16

Error -16 is EBUSY, which causes the driver load to fail due to the 
"Unable to reserve mem region" message.

This means that the sata_nv driver needed to use PCI BAR 6, but was 
unable to for some reason.  Given that sata_nv uses devres like other 
libata drivers, IMO the likely cause is outside the ATA subsystem (PCI? 
ACPI?).

One workaround to try is setting sata_nv module option 'adma' to zero 
(0), in the hopes that it ignores that final region and work anyway.

	Jeff



