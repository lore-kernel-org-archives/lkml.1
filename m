Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbZKRQWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbZKRQWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbZKRQWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:22:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42497 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754454AbZKRQWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:22:22 -0500
Date: Wed, 18 Nov 2009 11:22:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alexander Holler <holler@ahsoftware.de>
cc: Oliver Neukum <oliver@neukum.org>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: Problems with p55-express and sleeping usb-hds
In-Reply-To: <4B032C4E.1020606@ahsoftware.de>
Message-ID: <Pine.LNX.4.44L0.0911181119240.3036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009, Alexander Holler wrote:

> Hello,
> 
> I've done some more tests and have some more findings.
> 
> After the problem occured (which looks for me like a timeout during a 
> wait for a CSW), ehci_hcd doesn't work anymore. Low- and full-speed 
> devices are still working and are recognized correctly, but no 
> high-speed device. After unloading ehci_hcd and reloading it, high-speed 
> devices are recognized correctly again.
> As unloading is no option for kernels which have ehci_hcd compiled in 
> (like the F11-kernel), is there another option to reset the driver?

You can unbind ehci-hcd from the controller by writing the controller's 
name to the "unbind" attribute in the appropriate sysfs directory.  For 
example, on my system:

# ls /sys/bus/pci/drivers/ehci_hcd
0000:00:1d.7  0000:01:00.2  0000:01:01.2  bind  module  new_id  uevent  
unbind
# echo -n 0000:00:1d.7 >/sys/bus/pci/drivers/ehci_hcd/unbind

Then to rebind the driver, write the device name to the "bind" 
attribute:

# echo -n 0000:00:1d.7 >/sys/bus/pci/drivers/ehci_hcd/bind

Alan Stern

