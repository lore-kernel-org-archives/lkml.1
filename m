Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbXGVB4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbXGVB4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 21:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbXGVB4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 21:56:24 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:52837
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbXGVB4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 21:56:21 -0400
Date: Sat, 21 Jul 2007 18:55:34 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: long-term regression
In-Reply-To: <20070627091903.635e9388.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0707211852450.6747@asgard.lang.hm>
References: <Pine.LNX.4.64.0706171052240.28371@asgard.lang.hm>
 <20070621052807.cc64605d.akpm@linux-foundation.org>
 <20070621083659.dabf3a22.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0706242157570.6215@asgard.lang.hm> <4680445C.8000703@oracle.com>
 <Pine.LNX.4.64.0706251555330.20356@asgard.lang.hm>
 <20070626121425.e92ba2e5.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0706270034560.6551@asgard.lang.hm>
 <20070627091903.635e9388.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for the long delay in testing.

On Wed, 27 Jun 2007, Randy Dunlap wrote:

> [adding linux-acpi@vger.kernel.org]
>
> On Wed, 27 Jun 2007 00:38:17 -0700 (PDT) david@lang.hm wrote:
>
>> On Tue, 26 Jun 2007, Randy Dunlap wrote:
>>
>>> On Mon, 25 Jun 2007 15:56:17 -0700 (PDT) david@lang.hm wrote:
>>>
>>>> due to the size the files are posted at http://linux.lang.hm/linux
>>>>
>>>> let me know what else I can send to help.
>>>>
>>>> David Lang
>>>
>>>
>>> I suggest that you test 2.6.22-rcN using one or both of these
>>> boot options:
>>>
>>> noisapnp
>>> pnpacpi=off
>>>
>>> Somewhere between 2.6.18 and 2.6.22-development, the ACPI config
>>> symbol also starting enabling (selecting) PNP.  That's one of many
>>> differences....
>>
>> with the 2.6.22-rc4 kernel that I was useing earlier, adding these two
>> options clears up the problem. Thanks.
>>
>> should I test the two individually? or just plan on useing both from now
>> on?
>
> Yes, please test them individually.  I expect that just one of them
> will suffice, but I don't know which one.

pnpacpi=off works
noisapnp doesn't work

>> I normally disable PnP (both ISA and PCI), should I leave it enabled with
>> the newer kernels and this motherboard?
>
> ACPI recently began enabling (selecting) PNP for you...

I didn't realize this had changed.

> How do you normally disable PCI PNP?
>
> What kind of hardware is this?  Please show us lspci output.

00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
 	Subsystem: Elitegroup Computer Systems Unknown device 1b51
 	Flags: bus master, 66MHz, fast devsel, latency 0
 	Capabilities: [44] HyperTransport: Slave or Primary Interface
 	Capabilities: [e0] HyperTransport: MSI Mapping

00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
 	Subsystem: Elitegroup Computer Systems Unknown device 1b51
 	Flags: bus master, 66MHz, fast devsel, latency 0

00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
 	Subsystem: Elitegroup Computer Systems Unknown device 1b51
 	Flags: 66MHz, fast devsel, IRQ 3
 	I/O ports at fc00 [size=32]
 	I/O ports at 1c00 [size=64]
 	I/O ports at 1c40 [size=64]
 	Capabilities: [44] Power Management version 2

00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2) (prog-if 10 [OHCI])
 	Subsystem: Elitegroup Computer Systems Unknown device 1b51
 	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
 	Memory at fe02f000 (32-bit, non-prefetchable) [size=4K]
 	Capabilities: [44] Power Management version 2

00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3) (prog-if 20 [EHCI])
 	Subsystem: Elitegroup Computer Systems Unknown device 1b51
 	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
 	Memory at fe02e000 (32-bit, non-prefetchable) [size=256]
 	Capabilities: [44] Debug port
 	Capabilities: [80] Power Management version 2

00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio Controller (rev a2)
 	Subsystem: Elitegroup Computer Systems Unknown device 1b51
 	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 3
 	I/O ports at f000 [size=256]
 	I/O ports at ec00 [size=256]
 	Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
 	Capabilities: [44] Power Management version 2

00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev a2) (prog-if 8a [Master SecP PriP])
 	Subsystem: Elitegroup Computer Systems Unknown device 1b51
 	Flags: bus master, 66MHz, fast devsel, latency 0
 	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
 	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
 	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
 	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
 	I/O ports at e000 [size=16]
 	Capabilities: [44] Power Management version 2

00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2) (prog-if 01 [Subtractive decode])
 	Flags: bus master, 66MHz, fast devsel, latency 0
 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
 	I/O behind bridge: 0000c000-0000cfff
 	Memory behind bridge: fde00000-fdefffff
 	Prefetchable memory behind bridge: fdf00000-fdffffff

00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
 	Subsystem: Elitegroup Computer Systems Unknown device 1b51
 	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
 	Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
 	I/O ports at dc00 [size=8]
 	Capabilities: [44] Power Management version 2

00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
 	Flags: bus master, fast devsel, latency 0
 	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
 	I/O behind bridge: 0000b000-0000bfff
 	Memory behind bridge: fdd00000-fddfffff
 	Prefetchable memory behind bridge: 00000000fdc00000-00000000fdc00000
 	Capabilities: [40] Power Management version 2
 	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
 	Capabilities: [58] HyperTransport: MSI Mapping
 	Capabilities: [80] Express Root Port (Slot+) IRQ 0
 	Capabilities: [100] Virtual Channel

00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
 	Flags: bus master, fast devsel, latency 0
 	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
 	I/O behind bridge: 0000a000-0000afff
 	Memory behind bridge: fdb00000-fdbfffff
 	Prefetchable memory behind bridge: 00000000fda00000-00000000fda00000
 	Capabilities: [40] Power Management version 2
 	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
 	Capabilities: [58] HyperTransport: MSI Mapping
 	Capabilities: [80] Express Root Port (Slot+) IRQ 0
 	Capabilities: [100] Virtual Channel

00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
 	Flags: bus master, fast devsel, latency 0
 	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
 	I/O behind bridge: 00009000-00009fff
 	Memory behind bridge: fd900000-fd9fffff
 	Prefetchable memory behind bridge: 00000000fd800000-00000000fd800000
 	Capabilities: [40] Power Management version 2
 	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
 	Capabilities: [58] HyperTransport: MSI Mapping
 	Capabilities: [80] Express Root Port (Slot+) IRQ 0
 	Capabilities: [100] Virtual Channel

00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
 	Flags: bus master, fast devsel, latency 0
 	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
 	I/O behind bridge: 00008000-00008fff
 	Memory behind bridge: fd700000-fd7fffff
 	Prefetchable memory behind bridge: 00000000fa000000-00000000fbf00000
 	Capabilities: [40] Power Management version 2
 	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
 	Capabilities: [58] HyperTransport: MSI Mapping
 	Capabilities: [80] Express Root Port (Slot+) IRQ 0
 	Capabilities: [100] Virtual Channel

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
 	Flags: fast devsel
 	Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
 	Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
 	Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
 	Flags: fast devsel

01:06.0 RAID bus controller: 3ware Inc 5xxx/6xxx-series PATA-RAID (rev 12)
 	Subsystem: 3ware Inc 5xxx/6xxx-series PATA-RAID
 	Flags: bus master, stepping, medium devsel, latency 32, IRQ 16
 	I/O ports at cc00 [size=16]
 	[virtual] Expansion ROM at fdf20000 [disabled] [size=64K]

01:07.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
 	Subsystem: Adaptec 29160 Ultra160 SCSI Controller
 	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
 	BIST result: 00
 	I/O ports at c800 [disabled] [size=256]
 	Memory at fdeff000 (64-bit, non-prefetchable) [size=4K]
 	[virtual] Expansion ROM at fdf00000 [disabled] [size=128K]
 	Capabilities: [dc] Power Management version 2

01:08.0 RAID bus controller: 3ware Inc 5xxx/6xxx-series PATA-RAID (rev 12)
 	Subsystem: 3ware Inc 5xxx/6xxx-series PATA-RAID
 	Flags: bus master, stepping, medium devsel, latency 32, IRQ 18
 	I/O ports at c400 [size=16]
 	[virtual] Expansion ROM at fdf30000 [disabled] [size=64K]

05:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 [Radeon X300 (PCIE)] (prog-if 00 [VGA])
 	Subsystem: Diamond Multimedia Systems Unknown device 0460
 	Flags: bus master, fast devsel, latency 0, IRQ 18
 	Memory at fa000000 (32-bit, prefetchable) [size=32M]
 	I/O ports at 8c00 [size=256]
 	Memory at fd7f0000 (32-bit, non-prefetchable) [size=64K]
 	[virtual] Expansion ROM at fd700000 [disabled] [size=128K]
 	Capabilities: [50] Power Management version 2
 	Capabilities: [58] Express Endpoint IRQ 0
 	Capabilities: [80] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
 	Capabilities: [100] Advanced Error Reporting

05:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
 	Subsystem: Diamond Multimedia Systems Unknown device 0461
 	Flags: fast devsel
 	Memory at fd7e0000 (32-bit, non-prefetchable) [disabled] [size=64K]
 	Capabilities: [50] Power Management version 2
 	Capabilities: [58] Express Endpoint IRQ 0

David Lang

>>> I would also disable CONFIG_USB_USS720, at least for testing.
>>
>> for ease of testing (I got time to reboot the box around midnight) I used
>> the same config as before, so this is still on.
>>
>> David Lang
>>
>>>
>>>> On Mon, 25 Jun 2007, Randy Dunlap wrote:
>>>>
>>>>> Date: Mon, 25 Jun 2007 15:40:28 -0700
>>>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>>> To: david@lang.hm
>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
>>>>>     linux-usb-devel@lists.sourceforge.net
>>>>> Subject: Re: long-term regression
>>>>>
>>>>> david@lang.hm wrote:
>>>>>>  On Thu, 21 Jun 2007, Randy Dunlap wrote:
>>>>>>
>>>>>>>  Date: Thu, 21 Jun 2007 08:36:59 -0700
>>>>>>>  From: Randy Dunlap <randy.dunlap@oracle.com>
>>>>>>>  To: Andrew Morton <akpm@linux-foundation.org>
>>>>>>>  Cc: david@lang.hm, linux-kernel@vger.kernel.org,
>>>>>>>      linux-usb-devel@lists.sourceforge.net
>>>>>>>  Subject: Re: long-term regression
>>>>>>>
>>>>>>>  On Thu, 21 Jun 2007 05:28:07 -0700 Andrew Morton wrote:
>>>>>>>
>>>>>>>>>  On Sun, 17 Jun 2007 10:57:55 -0700 (PDT) david@lang.hm wrote:
>>>>>>>>>  I haven't had time to bisect this, but I'm having a problem on a
>>>>>>>>>  AMD64
>>>>>>>>>  gentoo system where the printer doesn't work with recent kernels.
>>>>>>>>>
>>>>>>>>>  2.6.18-rc3 worked
>>>>>>>>>  2.6.21.1 doesn't
>>>>>>>>>  2.6.22-rc4 doesn't
>>>>>>>>>
>>>>>>>>>  unfortunantly the system is gooted on 2.6.18 at the moment and I'm
>>>>>>>>>  out of
>>>>>>>>>  town so my ability to test is limited I can provide the 2.6.22-rc4
>>>>>>>>>  (attached) and 2.6.18-rc3 configs.
>>>>>>>>>
>>>>>>>>>  dmesg appears to show the port being detected, but writes to the
>>>>>>>>>  port
>>>>>>>>>  under newer kernels appear to complete, but no data gets to the
>>>>>>>>>  printer.
>>>>>>>>>
>>>>>>>>>  any suggestions other then doing the large bisect?
>>>>>>>>
>>>>>>>>  That would be good, thanks.  Please be sure to cc linux-usb-devel on
>>>>>>>>  the results.
>>>>>>>
>>>>>>>  OK, I'm curious about how someone deduced that this is a problem
>>>>>>>  with a USB printer vs. parallel port printer since the config file has:
>>>>>>>
>>>>>>>  CONFIG_PRINTER=y
>>>>>>>  CONFIG_USB_PRINTER=y
>>>>>>>
>>>>>>>  The kernel boot log should probably be posted also.
>>>>>>
>>>>>>  here is the dmesg from 2.6.22-rc4 and kern.log showing 2.6.22.-rc4 and
>>>>>>  2.6.180rc3
>>>>>>
>>>>>>  the printer not working is the parallel port.
>>>>>
>>>>> This email didn't show up on lkml or linux-usb-devel due to size limits (it
>>>>> was 900+ KB).
>>>>>
>>>>> David, please send your working 2.6.18 config file.
>>>>>
>>>>> Can you post the kernel log files on the web somewhere?
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
