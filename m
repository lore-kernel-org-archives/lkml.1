Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbXH2KkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbXH2KkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 06:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXH2Kj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 06:39:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38167 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbXH2Kj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 06:39:57 -0400
Message-ID: <46D54CF6.7060009@garzik.org>
Date: Wed, 29 Aug 2007 06:39:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: HighPoint Linux Team <linux@highpoint-tech.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com
Subject: Re: [PATCH] hptiop: adding new firmware interface and more PCI device
 IDs
References: <200605101704.27491.linux@highpoint-tech.com> <200605121107.48597.linux@highpoint-tech.com> <200605161438.09717.linux@highpoint-tech.com> <200708291510.53793.linux@highpoint-tech.com>
In-Reply-To: <200708291510.53793.linux@highpoint-tech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

HighPoint Linux Team wrote:
> +	if (hba->firmware_version > 0x01020000 || hba->interface_version > 0x01020000) {
[...]
> +	if (hba->firmware_version > 0x01020000 ||
> +				hba->interface_version > 0x01020000) {

Rather than repeating this test, you should do it once at probe time, 
and set a "new interface" single-bit flag in some hptiop_hba field.

Less maintenance intensive, less prone to error, and removes expensive 
tests from the driver hotpath.


>  static struct pci_device_id hptiop_id_table[] = {
> -	{ PCI_DEVICE(0x1103, 0x3220) },
> -	{ PCI_DEVICE(0x1103, 0x3320) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x3220) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x3320) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x3520) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x4320) },
>  	{},

Using the PCI_VDEVICE() macro can make this even shorter:

	{ PCI_VDEVICE(TTI, 0x4320) }

Regards,

	Jeff


