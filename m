Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbYFYTIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbYFYTIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYFYTIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:08:30 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:48777 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbYFYTI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:08:29 -0400
Date: Wed, 25 Jun 2008 15:04:59 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: Strange problem with e1000 driver - ping packet loss
In-reply-to: <alpine.LFD.1.10.0806251455500.3014@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, varunc@linux.vnet.ibm.com,
       jbarnes@virtuousgeek.org, greg@kroah.com
Message-id: <alpine.LFD.1.10.0806251502000.3014@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <fa.QBOn2aWyqGnBJJticG4h09lpxD0@ifi.uio.no>
 <485A9678.5000707@shaw.ca> <20080620123054.GH3548@linux.vnet.ibm.com>
 <alpine.LFD.1.10.0806251455500.3014@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Jun 2008, Len Brown wrote:

> > Linux version 2.6.18-53.el5
 
can you find out if the latest upstream kernel still has this problem?

> > ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 177
> > PCI: Setting latency timer of device 0000:00:1d.1 to 64
> > uhci_hcd 0000:00:1d.1: UHCI Host Controller
> > uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
> > uhci_hcd 0000:00:1d.1: irq 177, io base 0x0000e880
> 
> > SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
> > audit(1213972202.305:3): policy loaded auid=4294967295
> > Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
> > Copyright (c) 1999-2006 Intel Corporation.
> > ACPI: PCI Interrupt 0000:02:02.0[B] -> GSI 18 (level, low) -> IRQ 193
> > e1000: 0000:02:02.0: e1000_probe: (PCI-X:66MHz:64-bit) 00:04:23:00:90:ab
> > e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
> > ACPI: PCI Interrupt 0000:02:02.1[B] -> GSI 18 (level, low) -> IRQ 193
> > e1000: 0000:02:02.1: e1000_probe: (PCI-X:66MHz:64-bit) 00:04:23:00:90:aa
> > e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection

your /proc/interrutps showed just eth1, and it was on IRQ 177 --
was that from a different boot than this dmesg?

in any case, when you boot these on a new kernel
they should both show up on IRQ 18 (because they're on GSI 18).

Also, these IOAPIC interrupts are not programmable -- they
are hard-coded, so the issue is not in the ACPI PCI interrupt
link programming code.

-Len

