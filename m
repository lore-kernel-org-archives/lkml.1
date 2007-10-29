Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbXJ2Oqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbXJ2Oqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXJ2Oqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:46:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54073 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbXJ2Oqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:46:47 -0400
Message-ID: <4725F254.700@garzik.org>
Date: Mon, 29 Oct 2007 10:46:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Dirk Hohndel <hohndel@linux.intel.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciserial_resume_one ignored return value of pci_enable_device
References: <20071029132817.GA20449@bigserver.hohndel.org>
In-Reply-To: <20071029132817.GA20449@bigserver.hohndel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk Hohndel wrote:
> [PATCH] pciserial_resume_one ignored return value of pci_enable_device
> 
> Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>
> 
> ---
>  drivers/serial/8250_pci.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
> index 0e35756..ceb03c9 100644
> --- a/drivers/serial/8250_pci.c
> +++ b/drivers/serial/8250_pci.c
> @@ -1986,6 +1986,7 @@ static int pciserial_suspend_one(struct pci_dev *dev, pm_message_t state)
>  
>  static int pciserial_resume_one(struct pci_dev *dev)
>  {
> +	int err;
>  	struct serial_private *priv = pci_get_drvdata(dev);
>  
>  	pci_set_power_state(dev, PCI_D0);
> @@ -1995,7 +1996,9 @@ static int pciserial_resume_one(struct pci_dev *dev)
>  		/*
>  		 * The device may have been disabled.  Re-enable it.
>  		 */
> -		pci_enable_device(dev);
> +		err = pci_enable_device(dev);
> +		if (err)
> +			return err;

ACK


