Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbZF2Btj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbZF2Btj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 21:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZF2Btc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 21:49:32 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:38061 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZF2Btb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 21:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e7L5qmfylXzKT1me/NXRFaIoZe9s/A/v//7PtBuV3TC/OLkMYjlyDq9x4tpiAKmhcE
         BiubYIIDtWneor6DXnqTuCYgj0Kxwzh4XPLNxIPr5abF6h4ODOG+Jd7i2omr8k70rrtU
         SJruphloK9ufiJxQMnpctVbAqVUhhy26eUTYQ=
MIME-Version: 1.0
In-Reply-To: <20090628223132.GO20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net>
	 <86802c440906272126s7d3b97afh16069280bd297827@mail.gmail.com>
	 <20090628223132.GO20436@tamriel.snowman.net>
Date: Sun, 28 Jun 2009 18:49:34 -0700
Message-ID: <86802c440906281849m51ab3c82u84d76a1aaceba2ef@mail.gmail.com>
Subject: Re: ACPI issues on HP DL585 G2
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Stephen Frost <sfrost@snowman.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 3:31 PM, Stephen Frost<sfrost@snowman.net> wrote:
> Yinghai,
>
> * Yinghai Lu (yhlu.kernel@gmail.com) wrote:
>> try 2.6.30
>
> dmesg from 2.6.30 (w/ pci=noapic noapic) attached.  Box didn't boot
> again, but we did get a "hung process" message from the kernel after a
> while.  I don't have more info than that about the boot w/o pci=noapic
> noapic, sorry.  I can try and get that info at another time if this
> isn't enough.
>

your BIOS doesn't assign resource for some devices
[    0.688930] pci 0000:01:03.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.689183] pci 0000:01:04.2: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.696343] pci 0000:41:01.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.696525] pci 0000:41:02.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.696740] pci 0000:42:02.0: reg 30 32bit mmio: [0x000000-0x03ffff]

and acpi ioapic
ACPI: IOAPIC (id[0x08] address[0xf7cf0000] gsi_base[0])
IOAPIC[0]: apic_id 8, address 0xf7cf0000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xf7fd0000] gsi_base[24])
IOAPIC[1]: apic_id 9, address 0xf7fd0000, GSI 24-30
ACPI: IOAPIC (id[0x0a] address[0xf7fe0000] gsi_base[31])
IOAPIC[2]: apic_id 10, address 0xf7fe0000, GSI 31-37
ACPI: IOAPIC (id[0x0b] address[0xf7ff0000] gsi_base[38])
IOAPIC[3]: apic_id 11, address 0xf7ff0000, GSI 38-61

mptable report
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000] MPTABLE: OEM ID: HP
[    0.000000] MPTABLE: Product ID: PROLIANT
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] I/O APIC #8 Version 32 at 0xD9CF0000.
[    0.000000] I/O APIC #9 Version 32 at 0xD9FD0000.
[    0.000000] I/O APIC #10 Version 32 at 0xD9FE0000.

are you sure these two come from same BIOS ?

YH
