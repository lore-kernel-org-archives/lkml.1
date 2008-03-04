Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYCDFyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYCDFyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbYCDFx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:53:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbYCDFxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:53:54 -0500
Date: Mon, 3 Mar 2008 21:56:03 -0800
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@hp.com>, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
       Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v7] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080304055603.GC15566@suse.de>
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080301051247.GB19353@suse.de> <20080303233556.GA3694@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303233556.GA3694@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 04:35:56PM -0700, Alex Chiang wrote:
> * Greg KH <gregkh@suse.de>:
> > On Thu, Feb 28, 2008 at 05:23:41PM -0700, Alex Chiang wrote:
> > > 
> > > I did turn on kobject debugging, and all seems well except for
> > > one little thing. I based my module (pci_slot) on acpiphp, and
> > > the kobject system complains:
> > > 
> > > kobject: 'acpiphp' (a00000020476aed0): does not have a release()
> > > function, it is broken and must be fixed.
> > > 
> > > kobject: 'pci_slot' (a000000204791e50): does not have a release()
> > > function, it is broken and must be fixed.
> > > 
> > > Not quite sure what to do about these yet, but since no one has
> > > fixed acpiphp yet, I'm thinking that I can't be *too* wrong. :)
> > 
> > Um, the obvious solution of providing a release function for these
> > kobjects is somehow not correct?
> > 
> > Please do that, otherwise the code is wrong (and yes, acpiphp might be
> > wrong as well, I haven't seen that report yet.)
> 
> Hrm, maybe this is a false alarm? Those messages appear when
> doing an rmmod <foo>. Turns out you get those messages for lots
> of modules, for instance, uhci_ucd:

No, they are correct, and need to be fixed.

> kobject: 'uhci_hcd' (a00000020427c8d0): kobject_cleanup
> kobject: 'uhci_hcd' (a00000020427c8d0): does not have a release() function, it is broken and must be fixed.
> kobject: 'uhci_hcd' (a00000020427c8d0): auto cleanup 'remove' event
> kobject: 'uhci_hcd' (a00000020427c8d0): kobject_uevent_env
> kobject: 'uhci_hcd' (a00000020427c8d0): fill_kobj_path: path = '/module/uhci_hcd'
> kobject: 'uhci_hcd' (a00000020427c8d0): auto cleanup kobject_del
> kobject: 'uhci_hcd': free name
> 
> Are you saying that modules that call module_init/module_exit are
> supposed to supply a release() function?

No, the module core needs to do this, as that is the owner of this
kobject, not the module author.

I'll add it to my todo list :(

thanks,

greg k-h
