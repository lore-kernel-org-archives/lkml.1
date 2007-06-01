Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbXFAOUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbXFAOUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761387AbXFAOTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:19:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43803 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761368AbXFAOTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:19:33 -0400
Date: Fri, 1 Jun 2007 10:19:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michael Hanselmann <linux-kernel@hansmi.ch>
cc: linux-kernel@vger.kernel.org, <dbrownell@users.sourceforge.net>,
       <linux-usb-devel@lists.sourceforge.net>,
       <linux-kernel@killerfox.forkbomb.ch>
Subject: Re: [linux-usb-devel] [PATCH] Fix NEC OHCI chip silicon bug
In-Reply-To: <20070531213427.GA25154@hansmi.ch>
Message-ID: <Pine.LNX.4.44L0.0706011017370.3185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Michael Hanselmann wrote:

> This patch fixes a silicon bug in some NEC OHCI chips. The bug appears
> at random times and is very, very difficult to reproduce. Without the
> following patch, Linux would shut the chip and its associated devices
> down. In Apple PowerBooks this leads to an unusable keyboard and mouse
> (SSH still working). The idea of restarting the chip is taken from
> public Darwin code.

> @@ -779,7 +790,11 @@ static int ohci_restart (struct ohci_hcd
>  	 */
>  	spin_lock_irq(&ohci->lock);
>  	disable (ohci);
> +
> +#ifdef CONFIG_PM
>  	usb_root_hub_lost_power(ohci_to_hcd(ohci)->self.root_hub);
> +#endif
> +

Suppose CONFIG_PM isn't defined.  How are you going to let usbcore 
know about all the old connections which no longer exist?

Alan Stern

