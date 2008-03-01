Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbYCAFVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbYCAFVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 00:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYCAFVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 00:21:14 -0500
Received: from mail.suse.de ([195.135.220.2]:42752 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbYCAFVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 00:21:13 -0500
Date: Fri, 29 Feb 2008 21:24:33 -0800
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@hp.com>, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
       Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/4] Introduce pci_slot
Message-ID: <20080301052433.GC19353@suse.de>
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080229002855.GD21420@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229002855.GD21420@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 05:28:55PM -0700, Alex Chiang wrote:
>   - Make pci_slot the primary sysfs entity. hotplug_slot becomes a
>     subsidiary structure.
>     o pci_create_slot() creates and registers a slot with the PCI core
>     o pci_slot_add_hotplug() gives it hotplug capability
> 
>   - Change the prototype of pci_hp_register() to take the bus and
>     slot number (on parent bus) as parameters.
> 
>   - Remove all the ->get_address methods since this functionality is
>     now handled by pci_slot directly.

This describes what you did, but not why you are doing this, making it a
pretty bad changelog comment.

Can you refresh my memory as to the "why" for all of this and how you
are handling machines that do not export this information at all?

oh, and don't put "extern" in a .c file, and call kobject_uevent in the
same function that you added the kobject in, unless there is a very good
reason to do so, otherwise you just missed all of those events...

thanks,

greg k-h
