Return-Path: <linux-kernel-owner+w=401wt.eu-S1759833AbYGQBVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833AbYGQBVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 21:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYGQBVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 21:21:41 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:55602 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750718AbYGQBVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 21:21:40 -0400
Date: Wed, 16 Jul 2008 21:21:28 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080717012128.GA18013@bromo.msbb.uc.edu>
References: <20080716035830.GA27935@bromo.msbb.uc.edu> <dd18b0c30807152230u39ef9c18v78b48d1c7b9ddd17@mail.gmail.com> <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com> <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com> <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com> <20080716140810.GA2861@bromo.msbb.uc.edu> <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com> <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com> <20080717004004.GA17792@bromo.msbb.uc.edu> <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 05:49:39PM -0700, Yinghai Lu wrote:
> 
> please boot with
> debug initcall_debug apic=verbose pci=routeirq?
> 
> and try pci=nommconf
> 
> I suspect that could be pci bridge is using 0xf0000000-0xf400000 too
> after Linus merge pci tree, please try to boot with
> pci=early_config_dump
> to see if it is true.
> 
> please don't drop the cc list.
> 
> YH

Yinghai,
    Here is what I see with 'debug initcall_debug apci=verbose pci=routeirq'.
Hopefully nothing important scrolled off the top of the screen (I've not found
a higher resolution vga kernel option that works on my MacBook Pro yet).

calling blk_ioc_init+0x0/0x2a
initcall blk_ioc_init+0x0/0x2a returned 0 after 0 msecs
calling genhd_device_init+0x0/0x55
initcall genhd_device_init+0x0/0x55 returned 0 after 0 msecs
calling fbmem_init+0x0/0x8a
initcall fbmem_init+0x0/0x8a returned 0 after 0 msecs
calling acpi_init+0x0/0x221
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: BIOS_IOS(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
initcall acpi_init+0x0/0x221 returned 0 after 16 msecs
calling acpi_scan_init+0x0/0x10a
initcall acpi_scan_init+0x0/0x10a returned 0 after 35 msecs
calling acpi_ec_init+0x0/0x61
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
initcall acpi_ec_init+0x0/0x61 returned 0 after 0 msecs
calling acpi_pci_root+init+0x0/0x28
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0 :quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00.1f.0 :quirk: region 0500-053f claimed by ICH6 GPIO

This is from the current linus kernel source with your mmconfig patch
applied. I will do the other test next.
              Jack
