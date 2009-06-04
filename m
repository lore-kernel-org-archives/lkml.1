Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZFDVmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZFDVmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZFDVmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:42:33 -0400
Received: from kroah.org ([198.145.64.141]:50892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbZFDVmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:42:32 -0400
Date: Thu, 4 Jun 2009 14:02:48 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Frans Pop <elendil@planet.nl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: Avoid PM error messages during resume if a device
	was disconnected
Message-ID: <20090604210248.GA17039@kroah.com>
References: <200906042230.49825.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906042230.49825.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 10:30:48PM +0200, Rafael J. Wysocki wrote:
> From: Frans Pop <elendil@planet.nl>
> 
> Currently if a laptop is suspended e.g. while docked and then resumed after
> undocking it, the following errors get generated because the USB hub in the
> docking station and the devices connected to it are no longer available:
> pm_op(): usb_dev_resume+0x0/0x10 returns -19
> PM: Device 1-2 failed to resume: error -19
> pm_op(): usb_dev_resume+0x0/0x10 returns -19
> PM: Device 1-2.2 failed to resume: error -19
> pm_op(): usb_dev_resume+0x0/0x10 returns -19
> PM: Device 1-2.3 failed to resume: error -19
> 
> As the removal of USB devices while a system is suspended is a relatively
> common use case and in most cases not an error, just return success on
> -ENODEV. The user gets informed anyway as the USB subsystem generates
> regular disconnect messages for the devices shortly afterwards:
> usb 1-2: USB disconnect, address 3
> usb 1-2.2: USB disconnect, address 4
> usblp0: removed
> usb 1-2.3: USB disconnect, address 5
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> Hi Greg,
> 
> I can take this patch to the suspend tree, but if you think it should go
> through USB, please consider including it into the 2.6.31 push.

I've now queued it up in my usb tree, as that is probably the best place
for it.

thanks,

greg k-h
