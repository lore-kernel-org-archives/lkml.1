Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZHMPWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZHMPWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZHMPWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:22:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57309 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752032AbZHMPWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:22:43 -0400
Date: Thu, 13 Aug 2009 11:22:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       <linux-pci@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [RFC] usb: Add support for runtime power management of the hcd
In-Reply-To: <20090813003544.GB2532@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0908131117130.2940-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Matthew Garrett wrote:

> --- a/drivers/usb/core/hcd-pci.c
> +++ b/drivers/usb/core/hcd-pci.c
> @@ -363,6 +363,18 @@ static int hcd_pci_restore(struct device *dev)
>  	return resume_common(dev, true);
>  }
>  
> +static int hcd_pci_runtime_suspend(struct device *dev)
> +{
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +	struct usb_hcd *hcd = pci_get_drvdata(pci_dev);
> +	struct usb_device *rhdev = hcd->self.root_hub;
> +
> +	if (!(hcd->driver->flags & HCD_RUNTIME_PM))
> +		return -EINVAL;
> +
> +	return 0;
> +}

You have to call the HCD's pci_suspend method!  Not to mention calling 
synchronize_irq and all the other stuff in hcd_pci_suspend and 
hcd_pci_suspend_noirq.

Ditto for resuming.

Alan Stern

