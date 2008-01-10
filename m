Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbYAJTiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbYAJTiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYAJTiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:38:10 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:59723 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbYAJTiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:38:08 -0500
Date: Thu, 10 Jan 2008 20:38:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Help needed to fix section mismatch warnings
Message-ID: <20080110193811.GB14021@uranus.ravnborg.org>
References: <20080106140728.GA3504@uranus.ravnborg.org> <20080109222542.422c90e0.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109222542.422c90e0.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 10:25:42PM -0800, Randy Dunlap wrote:
> On Sun, 6 Jan 2008 15:07:28 +0100 Sam Ravnborg wrote:
> 
> 
> > This is the current list of warnings
> 
> Sam,
> 
> Several of these are due to driver variable names not matching
> the whitelisted names in modpost.  I have patches for the ones
> that I have identified so far.  And I have patches for a few of
> the others that are true section mismatch problems (total of 8
> patches ready for now).
> 
> The whitelisted names will always be a (small) problem.
> Can __init_refok be used in these cases.. or some other new
> attribute, instead of forever adding to the whitelist or
> modifying variable names?

We had 112 warnings with the modified allyesconfig build and
many of these from the same module.
So in these cases I greatly prefer to rename variables to match
what other drivers use and thus enabling the current whitelist
to supress the warnings.

The remaining bits to address is the const / non-const issue.
Here we most likely need to invent a parallel set of section
names (yrk).

init_refok is for me the last resort and if we need many more
of these something else needs to be invented.


> 
> 
> > WARNING: vmlinux.o(.text+0x738a): Section mismatch: reference to .init.data:ebda_addr (between 'discover_ebda' and 'get_model_name')
> > WARNING: vmlinux.o(.text+0x73c4): Section mismatch: reference to .init.data:ebda_size (between 'discover_ebda' and 'get_model_name')
> 
> patch ready.
> 
> > WARNING: vmlinux.o(.text+0x605e14): Section mismatch: reference to .init.text: (between 'cciss_pci_init' and 'cciss_getgeometry')
> 
> patch ready.
> 
> > WARNING: vmlinux.o(.exit.text+0xc64d): Section mismatch: reference to .init.data:_asc_def_iop_base (between 'advansys_isa_remove' and 'advansys_eisa_remove')
> 
> patch ready.
> 
> > WARNING: vmlinux.o(.data+0x7e9b8): Section mismatch: reference to .init.text:tpm_inf_pnp_probe (between 'tpm_inf_pnp' and 'cn_idx')
> 
> patch ready.
> 
> > WARNING: vmlinux.o(.data+0xd44d8): Section mismatch: reference to .init.data:prism2_plx_id_table (between 'prism2_plx_drv_id' and 'dev_info')
> 
> patch ready.
> 
> > WARNING: vmlinux.o(.data+0x149908): Section mismatch: reference to .init.text:av7110_attach (between 'av7110_extension' and 'ir_protocol')
> 
> patch ready.
> 
> > WARNING: vmlinux.o(.data+0x1b3ce0): Section mismatch: reference to .init.text:megaraid_probe_one (between 'megaraid_pci_driver_g' and 'class_device_attr_megaraid_mbox_app_hndl')
> 
> patch ready.
> 
> > WARNING: vmlinux.o(.text+0xb0c71d): Section mismatch: reference to .exit.text: (between 'qla2xxx_pci_error_detected' and 'qla2xxx_pci_mmio_enabled')
> 
> patch ready.
> 
> > WARNING: vmlinux.o(.text+0xb4ff4b): Section mismatch: reference to .exit.text: (between 'sym2_io_error_detected' and 'sym2_io_slot_dump')
> 
> Patch sent by /me on 2007.OCT.29 to linux-scsi & akpm.
> 
> I will send the ready patches sometime on THU 2008.JAN.10.

Great!

	Sam
