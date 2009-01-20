Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbZATUdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbZATUdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZATUda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:33:30 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:35526 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762894AbZATUd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:33:29 -0500
Date: Tue, 20 Jan 2009 15:33:06 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] USB: Fix suspend-resume of PCI USB controllers
In-reply-to: <Pine.LNX.4.44L0.0901201031490.2612-100000@iolanthe.rowland.org>
X-X-Sender: lenb@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>
Message-id: <alpine.LFD.2.00.0901201526510.5575@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <Pine.LNX.4.44L0.0901201031490.2612-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Alan, does this look ok for you?
> 
> There are a few things I don't like about it:
> 
> 	In usb_hcd_pci_suspend, the failure path for 
> 	pci_set_power_state doesn't undo all the changes
> 	that have already been made.  In fact, the easiest
> 	way to do the rest of the recovery probably is to
> 	call usb_hcd_pci_resume directly.
> 
> 	In the !has_pci_pm path we don't call pci_set_power_state.
> 	This means controllers with legacy power management won't
> 	get suspended.  Maybe pci_set_power_state should be
> 	called always, and has_pci_pm be used only for
> 	interpreting the return code and printing debug messages.
> 
> 	In usb_hcd_pci_resume, the pci_wake_from_d3 call
> 	should be moved up right next to the pci_enable_wake
> 	call.  It makes no sense for them to be separated by
> 	pci_enable_device and pci_set_master.  After all,
> 	even if you can't re-enable the device you probably
> 	don't want it to continue being a wakeup source.
> 
> 	It's a little annoying that several debug messages
> 	in usb_hcd_pci_resume have been removed.  Can't we
> 	display the power state upon entry, before trying to
> 	change it?
> 
> 	It stands out that the resume method contains no call
> 	to match pci_set_power_state() in the suspend method.
> 	There should at least be a comment about it.
> 
> Some of these problems predate Rafael's patch.  Given that it has 
> already helped a number of people, we might want to merge the patch 
> and then make additional changes to address these issues.

Rafael's patch is required for upstream to resume on my T61.

Tested-by: Len Brown <len.brown@intel.com>

Perhaps Greg can apply Rafael's patch now to fix upstream ASAP,
while Alan prepares a 2nd patch to address his observations above?

thanks,
Len Brown, Intel Open Source Technology Center



