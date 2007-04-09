Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbXDIChj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbXDIChj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 22:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXDIChj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 22:37:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:2871 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbXDIChi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 22:37:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,386,1170662400"; 
   d="scan'208"; a="226832626:sNHT19525611"
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
From: Zhang Rui <rui.zhang@intel.com>
To: David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org,
       "linux-acpi@vger" <linux-acpi@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <200704071308.07571.david-b@pacbell.net>
References: <200704031741.42273.david-b@pacbell.net>
	 <200704060843.30723.david-b@pacbell.net> <20070407050131.GB25511@kroah.com>
	 <200704071308.07571.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 10:36:25 +0800
Message-Id: <1176086185.2650.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-07 at 13:08 -0700, David Brownell wrote:
> On Friday 06 April 2007 10:01 pm, Greg KH wrote:
> 
> > Are you _sure_ you have a 1-to-1 relationship here?  No multiple devices
> > pointing to the same acpi node?  Or the other way around?  If so, you
> > are going to have to change the name to be something more unique.
> 
> I've wondered that too.  The short answer:  APCI only supports 1-1
> here.
Right.
>   It will emit warnings if it tries to bind more than one ACPI
> device to a given "real" device ... but errors the other way are
> silently ignored.
> 
My understanding is different.
First, one "real" device can only have one device.archdata.acpi_handle,
which means it can only be bound to one ACPI device.
Second, AE_ALREADY_EXISTS will be returned when ACPI tries to bind more
than one "real" devices to the same ACPI device.
> By adding a warning over this create-links patch, I found that the
> system in the $SUBJECT patch (and likely every ACPI system) has
> two different nodes that correspond to one ACPI node:
> 
> 	/sys/devices/pci0000:00 ... pci root node
> 	/sys/devices/pnp0/00:00 ... id PNP0a03
> 	/sys/devices/acpi_system:00/device:00/PNP0A03:00 ... ditto
> 
> Arguably that's too many sysfs nodes for one device...
> 
> Plus, there's the issue of flakey ACPI tables; in the $SUBJECT patch
> both MDM and AUD nodes exist in the ACPI namespace, but they could
> only refer to one PCI device (with MDM as the wakeup source, not AUD
> as listed in the table).  Or maybe that's another case where the ACPI
> code isn't handling the tables as sensibly as it might...
> 
Could you attach this acpidump please? :)

Thanks,
Rui
