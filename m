Return-Path: <linux-kernel-owner+w=401wt.eu-S933408AbXGZIhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbXGZIhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765801AbXGZIgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:36:11 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:36307 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761203AbXGZIgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:36:08 -0400
Message-ID: <46A85CE9.7070506@free.fr>
Date: Thu, 26 Jul 2007 10:35:53 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Pin-pointing the root of unusual application latencies
References: <469600F7.3060603@free.fr> <20070725133835.GA17616@elte.hu> <46A758B5.9070602@free.fr> <200707251309.54240.lenb@kernel.org>
In-Reply-To: <200707251309.54240.lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:

> John Sigler wrote:
> 
>> # cat /proc/interrupts
>>             CPU0
>>    0:         37    XT-PIC-XT        timer
>>    1:          2    XT-PIC-XT        i8042
>>    2:          0    XT-PIC-XT        cascade
>>    7:          0    XT-PIC-XT        acpi
>>   10:        175    XT-PIC-XT        eth2, Dta1xx
>>   11:       1129    XT-PIC-XT        eth0
>>   12:          4    XT-PIC-XT        eth1
>>   14:      21482    XT-PIC-XT        ide0
>> NMI:          0
>> LOC:     161632
>> ERR:          0
>> MIS:          0
>>
>> IRQ 10 is shared between a NIC and an I/O board.
>>
>> For eth2, the kernel said:
>> ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC]
>>    -> GSI 10 (level, low) -> IRQ 10
>>
>> For Dta1xx, the kernel said:
>> ACPI: PCI Interrupt 0000:02:0e.0[A] -> Link [LNKC]
>>    -> GSI 10 (level, low) -> IRQ 10
>>
>> Is it possible to avoid the two boards sharing IRQ 10?
> 
> Maybe.  In this configuration, INTA of the two devices
> is physically connected to the same wire on the device-side
> of the interrupt re-mapper -- so you'd have to change the configuration.
> If you have an IOAPIC and can enable it, that will not hurt --

I believe this board does not provide an IO-APIC.
Even the LAPIC is disabled in the BIOS.
(Why would they do that??)

> though unless something else changes, these devices are still
> tied together on the device-side of the mapper.
> So if you can physically move one of the devices to another slot
> that is your best bet.

I will try.

> I'd need a bunch of info from your system to tell you what
> you can do ahead of time, including full dmesg, lspci -vv
> and acpidump.

The motherboard is an Adlink EBC-2000T with 3 on-board Intel 82559 NICs.
http://www.adlinktech.com/PD/web/PD_detail.php?pid=213

VIA Pro133T (VT82C694T + VT82C686B) chipset.
http://www.viaarena.com/default.aspx?PageID=40&STypeID=12

Kernel config:
http://linux.kernel.free.fr/latency/config-2.6.20.7-rt8-adlink-latency

dmesg:
http://linux.kernel.free.fr/latency/dmesg.adlink

lspci:
http://linux.kernel.free.fr/latency/lspci.adlink

acpidump:
http://linux.kernel.free.fr/latency/acpidump.adlink

Regards.
