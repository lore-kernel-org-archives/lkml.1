Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257Ab0ANHrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab0ANHrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174Ab0ANHri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:47:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:54437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab0ANHrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:47:37 -0500
Message-ID: <4B4ECBCE.1010502@kernel.org>
Date: Wed, 13 Jan 2010 23:46:22 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jeff Garrett <jeff@jgarrett.org>
CC: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@vger.kernel.org, David Airlie <airlied@linux.ie>
Subject: Re: 2.6.33-rc3: pci host bridge windows ignored (works with pci=use_crs)
References: <20100113053736.GA6720@jgarrett.org> <86802c441001130044w4026abadi3f513559f6e71cef@mail.gmail.com> <86802c441001130045i17f75692tb0ad5aadaabdfd2a@mail.gmail.com> <20100113132407.GA11350@jgarrett.org>
In-Reply-To: <20100113132407.GA11350@jgarrett.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 05:24 AM, Jeff Garrett wrote:
> On Wed, Jan 13, 2010 at 12:45:17AM -0800, Yinghai Lu wrote:
>> On Wed, Jan 13, 2010 at 12:44 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Tue, Jan 12, 2010 at 9:37 PM, Jeff Garrett <jeff@jgarrett.org> wrote:
>>>> Took a stab at getting the right emails.  If I missed anyone, sorry...
>>>>
>>>> I have a desktop machine with a radeon HD 4850, and on recent kernels
>>>> the radeon driver has failed with the message "No valid linear
>>>> framebuffer address".  lspci on the broken configuration showed the
>>>> first memory region at d0000000 of the radeon card to be ignored.  dmesg
>>>> showed there to be a host bridge window at that address which was also
>>>> ignored.
>>>> ...
>>>
>>> [    0.000000] BIOS-provided physical RAM map:
>>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>>> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>>> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>>> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf790000 (usable)
>>> [    0.000000]  BIOS-e820: 00000000bf790000 - 00000000bf79e000 (ACPI data)
>>> [    0.000000]  BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
>>> [    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
>>> [    0.000000]  BIOS-e820: 00000000bf7ec000 - 00000000c0000000 (reserved)
>>> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>>> [    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
>>> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000340000000 (usable)
>>> ...
>>>
>>> [    0.833443] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
>>> 0xe0000000-0xefffffff] (base 0xe0000000)
>>> [    0.835028] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved
>>> in ACPI motherboard resources
>>> ...
>>>
>>> [    0.847449] ACPI: PCI Root Bridge [PCI0] (0000:00)
>>> [    0.847470] pci_root PNP0A08:00: ignoring host bridge windows from
>>> ACPI; boot with "pci=use_crs" to use them
>>> [    0.847693] pci_root PNP0A08:00: host bridge window [io
>>> 0x0000-0x0cf7] (ignored)
>>> [    0.847695] pci_root PNP0A08:00: host bridge window [io
>>> 0x0d00-0xffff] (ignored)
>>> [    0.847697] pci_root PNP0A08:00: host bridge window [mem
>>> 0x000a0000-0x000bffff] (ignored)
>>> [    0.847699] pci_root PNP0A08:00: host bridge window [mem
>>> 0x000d0000-0x000dffff] (ignored)
>>> [    0.847701] pci_root PNP0A08:00: host bridge window [mem
>>> 0xc0000000-0xdfffffff] (ignored)
>>> [    0.847703] pci_root PNP0A08:00: host bridge window [mem
>>> 0xf0000000-0xfed8ffff] (ignored)
>>> ...
>>> [    0.848025] IOH bus: [00, fb]
>>> [    0.848026] IOH bus: 00 index 0 io port: [0, ffff]
>>> [    0.848028] IOH bus: 00 index 1 mmio: [e0000000, fdffffff]
>>> ...
>>> [    0.849289] PCI: peer root bus 00 res updated from pci conf
>>> ...
>>> [    0.849361] pci 0000:04:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
>>> [    0.849369] pci 0000:04:00.0: reg 18: [mem 0xfbee0000-0xfbeeffff 64bit]
>>> [    0.849374] pci 0000:04:00.0: reg 20: [io  0xe000-0xe0ff]
>>> [    0.849381] pci 0000:04:00.0: reg 30: [mem 0xfbec0000-0xfbedffff pref]
>>> [    0.849423] pci 0000:04:00.1: reg 10: [mem 0xfbefc000-0xfbefffff 64bit]
>>> [    0.849481] pci 0000:00:07.0: PCI bridge to [bus 04-04]
>>> [    0.849484] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
>>> [    0.849487] pci 0000:00:07.0:   bridge window [mem 0xfbe00000-0xfbefffff]
>>> [    0.849491] pci 0000:00:07.0:   bridge window [mem
>>> 0xd0000000-0xdfffffff 64bit pref]
>>>
>>>
>>> it seems HW IOH only can use [e000000 - fdffffff] under that bridge...
>>>
>>> and _CRS said the peer root bus could use [c000000 - dfffffff]
>>>
>>> could be that we need to check other register to decide if we can use
>>> reading from ioh reg directly.
>>
>> can you send out
>>
>> lspci -tvnn
>> lspci -vvxxxx
>>

not sure why [0xc000000 - 0xcffffff] should work with 00:07.0

checked with intel doc, that is out of scope to LMMIOL register...

really don't know how it works with your platform.

YH
