Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbYLXWyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbYLXWyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 17:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYLXWyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 17:54:23 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3985 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751272AbYLXWyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 17:54:22 -0500
Date: Wed, 24 Dec 2008 17:54:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       <linux-usb@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/3] USB: FHCI: Driver should be responsible for
 managing endpoint queues
In-Reply-To: <20081224191303.GA21815@oksana.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.44L0.0812241752330.917-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2008, Anton Vorontsov wrote:

> Follow these changes for the FHCI driver:
> 
> commit e9df41c5c5899259541dc928872cad4d07b82076
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Wed Aug 8 11:48:02 2007 -0400
> 
> USB: make HCDs responsible for managing endpoint queues

On the whole this looks good.

> --- a/drivers/usb/host/fhci-q.c
> +++ b/drivers/usb/host/fhci-q.c
> @@ -200,6 +200,9 @@ void urb_complete_free(struct fhci_hcd *fhci, struct urb *urb)
>  		else
>  			urb->status = 0;
>  	}
> +
> +	usb_hcd_unlink_urb_from_ep(fhci_to_hcd(fhci), urb);
> +
>  	spin_unlock(&fhci->lock);
>  
>  	usb_hcd_giveback_urb(fhci_to_hcd(fhci), urb, urb->status);

For the future you might think about not using urb->status at all.  The 
intention is eventually to remove that field.

Alan Stern

