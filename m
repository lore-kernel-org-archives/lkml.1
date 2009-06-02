Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZFBVsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZFBVsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 17:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZFBVsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 17:48:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43475 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750780AbZFBVsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 17:48:02 -0400
Date: Tue, 2 Jun 2009 17:48:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, <linux-usb@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: avoid PM error messages during resume if a device
 was disconnected
In-Reply-To: <200906022326.34491.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906021745380.3960-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Rafael J. Wysocki wrote:

> Returning 0 from usb_external_resume_device() if the device is not present
> any more doesn't seem wrong.  It's not really an error condition, IMO, because
> it's rather normal that the devices may be removed while suspended.
> 
> OTOH, I don't think we can ignore -ENODEV universally in the core, because
> its meaning may depend on the bus type.  For example, for PCI it sometimes
> means a hardware problem has occured (other than the device being not present
> any more).

> I'd vote in favor of the Frans' patch, at least for now.
> 
> So, Frans, please resubmit with the changelog modified as requested by Alan.

If we change -ENODEV to 0, the change should be made in usb_resume()
rather than usb_external_resume_device().

Alan Stern

