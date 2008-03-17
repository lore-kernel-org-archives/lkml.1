Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYCQM1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYCQM1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbYCQM1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:27:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47621 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbYCQM1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:27:30 -0400
Message-ID: <47DE63B0.2070209@garzik.org>
Date: Mon, 17 Mar 2008 08:27:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH libata-dev#upstream-fixes] ahci: request all PCI BARs
References: <47D6643A.6060001@gmail.com> <47D6646F.9070109@gmail.com>
In-Reply-To: <47D6646F.9070109@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> ahci is often implemented with accompanying SFF compatible interface
> and legacy IDE driver may attach to the legacy IO ports when the
> controller is already claimed by ahci and vice-versa.  This patch
> makes ahci use pcim_iomap_regions_request_all() so that all IO regions
> are claimed on attach.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  drivers/ata/ahci.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: work/drivers/ata/ahci.c
> ===================================================================
> --- work.orig/drivers/ata/ahci.c
> +++ work/drivers/ata/ahci.c
> @@ -2234,7 +2234,10 @@ static int ahci_init_one(struct pci_dev 
>  	if (rc)
>  		return rc;
>  
> -	rc = pcim_iomap_regions(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
> +	/* AHCI controllers often implement SFF compatible interface.
> +	 * Grab all PCI BARs just in case.
> +	 */
> +	rc = pcim_iomap_regions_request_all(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
>  	if (rc == -EBUSY)
>  		pcim_pin_device(pdev);

applied this, and the devres function


