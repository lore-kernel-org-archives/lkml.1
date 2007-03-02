Return-Path: <linux-kernel-owner+w=401wt.eu-S2992641AbXCBWyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992641AbXCBWyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992711AbXCBWyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:54:43 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:51887 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992641AbXCBWym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:54:42 -0500
Date: Fri, 2 Mar 2007 23:55:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH,RFC] pci: do not mark exported functions as __devinit
Message-ID: <20070302225512.GA22555@uranus.ravnborg.org>
References: <20070227092702.GA21337@uranus.ravnborg.org> <20070302204752.GA24716@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302204752.GA24716@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 12:47:52PM -0800, Greg KH wrote:
> On Tue, Feb 27, 2007 at 10:27:02AM +0100, Sam Ravnborg wrote:
> > Functions marked __devinit will be removed after kernel init.
> > But being exported they are potentially called by a module
> > much later.
> > So the safer choice seems to be to keep the function even
> > in the non CONFIG_HOTPLUG case.
> > 
> > This silence the follwoing section mismatch warnings:
> > WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_bus_add_device from __ksymtab_gpl between '__ksymtab_pci_bus_add_device' (at offset 0x20) and '__ksymtab_pci_walk_bus'
> > WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_create_bus from __ksymtab_gpl between '__ksymtab_pci_create_bus' (at offset 0x40) and '__ksymtab_pci_stop_bus_device'
> > WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_bus_max_busnr from __ksymtab_gpl between '__ksymtab_pci_bus_max_busnr' (at offset 0xc0) and '__ksymtab_pci_assign_resource_fixed'
> > WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_claim_resource from __ksymtab_gpl between '__ksymtab_pci_claim_resource' (at offset 0xe0) and '__ksymtab_pcie_port_bus_type'
> > WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_bus_add_devices from __ksymtab between '__ksymtab_pci_bus_add_devices' (at offset 0x70) and '__ksymtab_pci_bus_alloc_resource'
> > WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_scan_bus_parented from __ksymtab between '__ksymtab_pci_scan_bus_parented' (at offset 0x90) and '__ksymtab_pci_root_buses'
> > WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_bus_assign_resources from __ksymtab between '__ksymtab_pci_bus_assign_resources' (at offset 0x4d0) and '__ksymtab_pci_bus_size_bridges'
> > WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_bus_size_bridges from __ksymtab between '__ksymtab_pci_bus_size_bridges' (at offset 0x4e0) and '__ksymtab_pci_setup_cardbus'
> > 
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > ---
> > Is this the correct approach or do we allow __init symbols to be
> > exported? In that case we need to find a way to export them without
> > causing a section mismatch warning.
> 
> Yes, we allow them to be exported globally, as other init code might
> need to call them, like these functions.
> 
> So yes, I think we need to find a way to fix the warning tools, as the
> code is correct here.

OK - for now I have added code to kbuild to ignore/whitelist all EXPORT_SYMBOL*()
og functions marked __*init.
This silence the above warnings.

	Sam
