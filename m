Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZBGDsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZBGDsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 22:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZBGDsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 22:48:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:57485 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbZBGDsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 22:48:36 -0500
Message-ID: <498D0454.8030401@kernel.org>
Date: Fri, 06 Feb 2009 19:47:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] x86: find nr_irqs_gsi with mp_ioapic_routing
References: <498CCEDB.8050708@kernel.org> <alpine.LFD.2.00.0902062221050.26256@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902062221050.26256@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> 
> 
>> Impact: find right nr_irqs_gsi on some systems.
>>
>> one system has gap between gsi.
>> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
>> [    0.000000] ACPI: IOAPIC (id[0x05] address[0xfeafd000] gsi_base[48])
>> [    0.000000] IOAPIC[1]: apic_id 5, version 0, address 0xfeafd000, GSI 48-54
>> [    0.000000] ACPI: IOAPIC (id[0x06] address[0xfeafc000] gsi_base[56])
>> [    0.000000] IOAPIC[2]: apic_id 6, version 0, address 0xfeafc000, GSI 56-62
>> ...
>> [    0.000000] nr_irqs_gsi: 38
> 
> I've never seen gaps in GSIs.
> I've never seen IOAPICs with 7 redirection table entries.
> 
> This system looks quite broken even before the probe for nr_irqs_gsi.
> Do you have more information on it?

it is one AMD based system from Sun.
it has two hypertransport chains.
one: 8132 + ck804
one: io4

when 8 sockets are installed, will get
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfdefd000] gsi_base[48])
[    0.000000] IOAPIC[1]: apic_id 1, version 0, address 0xfdefd000, GSI 48-54
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfdefc000] gsi_base[56])
[    0.000000] IOAPIC[2]: apic_id 2, version 0, address 0xfdefc000, GSI 56-62
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfeaff000] gsi_base[24])
[    0.000000] IOAPIC[3]: apic_id 3, version 0, address 0xfeaff000, GSI 24-47


when 2 sockets are installed, only HT chains is used. will get
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfeafd000] gsi_base[48])
[    0.000000] IOAPIC[1]: apic_id 5, version 0, address 0xfeafd000, GSI 48-54
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfeafc000] gsi_base[56])
[    0.000000] IOAPIC[2]: apic_id 6, version 0, address 0xfeafc000, GSI 56-62

acpi madt ioapic-entries does include gsi_base field.

amd 8131: has 4 gsi
amd 8132: has 7 gsi, but only 3 can be used.

anyway that system is not broken, and it is quite solid.

this patch seems to be a 2.6.29 material.

YH

