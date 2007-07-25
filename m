Return-Path: <linux-kernel-owner+w=401wt.eu-S934062AbXGYRKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934062AbXGYRKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbXGYRKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:10:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:41508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbXGYRKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:10:03 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: John Sigler <linux.kernel@free.fr>
Subject: Re: Pin-pointing the root of unusual application latencies
Date: Wed, 25 Jul 2007 13:09:54 -0400
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <469600F7.3060603@free.fr> <20070725133835.GA17616@elte.hu> <46A758B5.9070602@free.fr>
In-Reply-To: <46A758B5.9070602@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251309.54240.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 10:05, John Sigler wrote:

> # cat /proc/interrupts
>             CPU0
>    0:         37    XT-PIC-XT        timer
>    1:          2    XT-PIC-XT        i8042
>    2:          0    XT-PIC-XT        cascade
>    7:          0    XT-PIC-XT        acpi
>   10:        175    XT-PIC-XT        eth2, Dta1xx
>   11:       1129    XT-PIC-XT        eth0
>   12:          4    XT-PIC-XT        eth1
>   14:      21482    XT-PIC-XT        ide0
> NMI:          0
> LOC:     161632
> ERR:          0
> MIS:          0
> 
> IRQ 10 is shared between a NIC and an I/O board.
> 
> For eth2, the kernel said:
> ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC]
>    -> GSI 10 (level, low) -> IRQ 10
> 
> For Dta1xx, the kernel said:
> ACPI: PCI Interrupt 0000:02:0e.0[A] -> Link [LNKC]
>    -> GSI 10 (level, low) -> IRQ 10
> 
> Is it possible to avoid the two boards sharing IRQ 10?

Maybe.  In this configuration, INTA of the two devices
is physically connected to the same wire on the device-side
of the interrupt re-mapper -- so you'd have to change the configuration.
If you have an IOAPIC and can enable it, that will not hurt --
though unless something else changes, these devices are still
tied together on the device-side of the  mapper.
So if you can physically move one of the devices to another slot
that is your best bet.

I'd need a bunch of info from your system to tell you what
you can do ahead of time, including full dmesg, lspci -vv
and acpidump.

-Len
