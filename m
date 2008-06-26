Return-Path: <linux-kernel-owner+w=401wt.eu-S1763326AbYFZNfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763326AbYFZNfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761467AbYFZNfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:35:08 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35912 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760878AbYFZNfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:35:05 -0400
Date: Thu, 26 Jun 2008 20:37:46 +0700
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, varunc@linux.vnet.ibm.com,
       jbarnes@virtuousgeek.org, greg@kroah.com, jesse.brandeburg@intel.com
Subject: Re: Strange problem with e1000 driver - ping packet loss
Message-ID: <20080626133746.GB3635@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <fa.QBOn2aWyqGnBJJticG4h09lpxD0@ifi.uio.no> <485A9678.5000707@shaw.ca> <20080620123054.GH3548@linux.vnet.ibm.com> <alpine.LFD.1.10.0806251455500.3014@localhost.localdomain> <alpine.LFD.1.10.0806251502000.3014@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806251502000.3014@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 03:04:59PM -0400, Len Brown wrote:
> On Wed, 25 Jun 2008, Len Brown wrote:
> 
> > > Linux version 2.6.18-53.el5
> 
> can you find out if the latest upstream kernel still has this problem?

Len,
	We'd tried 2.6.25 and found it doesnt help.

> > > ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 177
> > > PCI: Setting latency timer of device 0000:00:1d.1 to 64
> > > uhci_hcd 0000:00:1d.1: UHCI Host Controller
> > > uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
> > > uhci_hcd 0000:00:1d.1: irq 177, io base 0x0000e880
> > 
> > > SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
> > > audit(1213972202.305:3): policy loaded auid=4294967295
> > > Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
> > > Copyright (c) 1999-2006 Intel Corporation.
> > > ACPI: PCI Interrupt 0000:02:02.0[B] -> GSI 18 (level, low) -> IRQ 193
> > > e1000: 0000:02:02.0: e1000_probe: (PCI-X:66MHz:64-bit) 00:04:23:00:90:ab
> > > e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
> > > ACPI: PCI Interrupt 0000:02:02.1[B] -> GSI 18 (level, low) -> IRQ 193
> > > e1000: 0000:02:02.1: e1000_probe: (PCI-X:66MHz:64-bit) 00:04:23:00:90:aa
> > > e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
> 
> your /proc/interrutps showed just eth1, and it was on IRQ 177 --
> was that from a different boot than this dmesg?

Yes the dmesg and /proc/interrupts output I'd sent was from different
boot instances.

> in any case, when you boot these on a new kernel
> they should both show up on IRQ 18 (because they're on GSI 18).

hmm ok. we can verify.

> Also, these IOAPIC interrupts are not programmable -- they
> are hard-coded, so the issue is not in the ACPI PCI interrupt
> link programming code.

So is the issue likely with the e1000 device itself then? I have sent
ethregs output to Jesse ...hopefully that will give us some clues.

-- 
Regards,
vatsa
