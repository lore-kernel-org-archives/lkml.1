Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbYI3AJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbYI3AJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 20:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYI3AJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 20:09:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47707 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYI3AJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 20:09:27 -0400
Date: Tue, 30 Sep 2008 01:09:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Jeffrey W. Baker" <jwbaker@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Put unused PCI devices in D3
Message-ID: <20080930000923.GA29775@srcf.ucam.org>
References: <1222719064.19236.129.camel@squeak.gghcwest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222719064.19236.129.camel@squeak.gghcwest.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 01:11:03PM -0700, Jeffrey W. Baker wrote:

> Currently it looks to me from browsing the code that D3 is only used in
> Linux when the whole machine is headed for S3, and the drivers are asked
> to suspend.  I think the drivers should be able to enter D3 in other
> circumstances:
> 
> * During pci_unregister_driver ... i.e. on module unload

The fact that Linux isn't using a device doesn't inherently mean that 
the system isn't using it. For example, the smbus controller will 
probably still be used by ACPI even if there's no Linux driver loaded.

> * When a network interface is downed

Yes. Drivers are moving towards this model.

> * If the device is a bridge or hub with no downstream device

Potential problems with hotplugging? But sure, this kind of thing is 
being implemented in USB and SCSI.

> * Whenever userspace requests D3 via sysfs

This functionality was explicitly removed a few years back.

> So, what fundamental problem prevents me from, for example, calling
> pci_set_power_state() from ohci1394's __exit?

Nothing I'm aware of. It sounds pretty safe in that case. But that would 
require you to load and unload the driver - better to have the driver 
loaded the entire time and make sure it does as much runtime power 
management as possible. I don't know enough about the firewire OHCI 
hardware, but can you power down most of the chip and still get hotplug 
events?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
