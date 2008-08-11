Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbYHKXtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbYHKXtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYHKXs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:48:57 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:30599 "EHLO
	pd2mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754057AbYHKXs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:48:56 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=7_tdhnrDAAAA:8 a=up6kH5ZQ6YfkyP98kgIA:9 a=Ui5VaynZMwXN-d04MZoA:7 a=m5pv5xSILfut7sqYyLc47p9gw_EA:4 a=MSl-tDqOz04A:10 a=Yd0ZYPPrE7cA:10 a=ctHlUJ6XgvMA:10
Message-ID: <48A0CFE2.6090705@shaw.ca>
Date: Mon, 11 Aug 2008 17:48:50 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       tj@kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [2.6.26.*] boot problem (ahci/irq related?)
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com> <20080811202731.GB2916@elte.hu> <20080811210140.GW9038@one.firstfloor.org>
In-Reply-To: <20080811210140.GW9038@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Mon, Aug 11, 2008 at 10:27:31PM +0200, Ingo Molnar wrote:
>> * Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
>>
>>> A have problem with booting 2.6.26* and 2.6.27-rc* kernels. Very often
>>> booting stops on this message:
>>>
>>> [...]
>>> Uniform Multi-Platform E-IDE driver
>>> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
>>> ICH7: IDE controller (0x8086:0x27df rev 0x01) at  PCI slot 0000:00:1f.1
>>> ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
>>> ICH7: not 100% native mode: will probe irqs later
>>> ICH7: IDE port disabled
>>>     ide0: BM-DMA at 0x60a0-0x60a7
>>>
>>> afer should be:
>>> hda: MATSHITADVD-RAM UJ-840S, ATAPI CD/DVD-ROM drive
>>> hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
>>> hda: MWDMA2 mode selected
>>> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
>>> [...]
>>>
>>> Initially I was think, that is hardware problem. But XP and 2.6.25.8 
>>> work with _no_ problem (booting from xp, linux, knoppix, linux 
>>> firmware development kit - about 50 reboots).
>>> http://unixy.pl/maciek/download/kernel/dupa/dmesg-2.6.26.2.txt
>>> dmesg: http://unixy.pl/maciek/download/kernel/dupa/dmesg-2.6.25.8.txt
>> i had a look at diff -up dmesg-2.6.25.8.txt dmesg-2.6.26.2.txt, and 
>> these changes stood out:
> 
> Yes post 2.6.25 changed to trust the ACPI motherboard resources
> to signify working mmcfg, previously it would use the e820 table
> which excluded near all motherboards which were not white listed
> by PCI-ID because BIOS programmers were generally not aware
> they had to reserve mcfg in e820. 
> 
> You can verify this by booting with pci=nommconf. If it works
> then it's likely that.
> 
> The new heuristic is apparently the same as what Vista does.
> 
> Robert Hancock (cc'ed, fullquote) is mr. mmconfig quirk.
> 
> -Andi

Wouldn't hurt to try it, but I'm kind of doubtful it's that - MMCONFIG 
failures don't normally get that far into bootup, and I believe we're 
not using it for non-extended config space anyways - I doubt IDE is 
doing extended config space access..
