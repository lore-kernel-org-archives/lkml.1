Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbXEURRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbXEURRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbXEURR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:17:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:2725 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbXEURR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:17:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=ez7HT789xqVIsM92VyN7u0InoO7hIF1jYoCxKK1tp1jdMF97JKZ3Sq/EFgLcoZfbD40nAGzCRbHIRlSONeGXt0K1mBV9TLAK1W2uN2M/y29aAFbptj2+vQCZq2vhE38FxCiJgSMdDcTlxe+vRubHMHv3V/KO9XYBuol5iASoHbk=
Message-ID: <4651D40B.7080907@gmail.com>
Date: Mon, 21 May 2007 19:16:59 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel@vger.kernel.org, alan@redhat.com, bzolnier@gmail.com,
       jgarzik@pobox.com, linux-pcmcia@lists.infradead.org
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com> <464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com> <46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com> <46518798.2020808@gmail.com> <4651B66E.6030505@gmail.com> <4651B834.3060702@gmail.com> <4651C4A1.6000101@gmail.com> <4651C74B.7020108@gmail.com>
In-Reply-To: <4651C74B.7020108@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020700050808010200000900"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020700050808010200000900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I don't know if linux-pcmcia is members only, so this might not reach 
that list.

Here are some log files...

Tejun Heo wrote:
> Robert de Rooy wrote:
>   
>> Hmm, good question. I do not have any other PCMCIA device to test.
>> The only other device I have is a Cardbus Wi-Fi adapter without Linux
>> support (Marvell). If I insert that adapter lspci seems to list it
>> properly, but without resorting to ndiswrapper I have no way of testing
>> it. In any case, seeing how Cardbus is PCI based this is probably
>> pointless to resolving this issue.
>>
>> Would any other log data from the controller initialization or lspci help?
>>     
>
> Hmmm... I don't really know much about PCMCIA.  cc'ing linux-pcmcia.
>
> The original thread can be read from the following URL.
>
>   http://thread.gmane.org/gmane.linux.kernel/530099
>
> It seems we're losing interrupts from the CFA device.  Any ideas?
>
> Thanks.
>
>   


--------------020700050808010200000900
Content-Type: text/plain;
 name="pccardctl.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pccardctl.txt"

[root@localhost ~]# pccardctl info
PRODID_1="                   "
PRODID_2="Memory Card Adapter"
PRODID_3=""
PRODID_4=""
MANFID=0045,0401
FUNCID=4
PRODID_1=""
PRODID_2=""
PRODID_3=""
PRODID_4=""
MANFID=0000,0000
FUNCID=255

--------------020700050808010200000900
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

Linux version 2.6.22-rc1-git5 (root@localhost.localdomain) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #5 SMP Thu May 17 21:23:42 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff60000 (usable)
 BIOS-e820: 000000007ff60000 - 000000007ff77000 (ACPI data)
 BIOS-e820: 000000007ff77000 - 000000007ff79000 (ACPI NVS)
 BIOS-e820: 000000007ff80000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 524128) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524128
early_node_map[1] active PFN ranges
    0:        0 ->   524128
On node 0 totalpages: 524128
  DMA zone: 40 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4056 pages, LIFO batch:0
  Normal zone: 2200 pages used for memmap
  Normal zone: 223080 pages, LIFO batch:31
  HighMem zone: 2878 pages used for memmap
  HighMem zone: 291874 pages, LIFO batch:31
DMI present.
Using APIC driver default
ACPI: RSDP 000F6D70, 0024 (r2 IBM   )
ACPI: XSDT 7FF6A6BD, 004C (r1 IBM    TP-1R        3210  LTP        0)
ACPI: FACP 7FF6A800, 00F4 (r3 IBM    TP-1R        3210 IBM         1)
ACPI Warning (tbfadt-0434): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
ACPI: DSDT 7FF6A9E7, C4E5 (r1 IBM    TP-1R        3210 MSFT  100000E)
ACPI: FACS 7FF78000, 0040
ACPI: SSDT 7FF6A9B4, 0033 (r1 IBM    TP-1R        3210 MSFT  100000E)
ACPI: ECDT 7FF76ECC, 0052 (r1 IBM    TP-1R        3210 IBM         1)
ACPI: TCPA 7FF76F1E, 0032 (r1 IBM    TP-1R        3210 PTL         1)
ACPI: BOOT 7FF76FD8, 0028 (r1 IBM    TP-1R        3210  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
Allocating PCI resources starting at 88000000 (gap: 80000000:7f800000)
Built 1 zonelists.  Total pages: 519010
Kernel command line: ro root=LABEL=/ rhgb quiet
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (0241d000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c078b000 soft=c076b000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 599.504 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2066148k/2096512k available (2092k kernel code, 29176k reserved, 1110k data, 260k init, 1179008k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc56000 - 0xfffff000   (3748 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0725000 - 0xc0766000   ( 260 kB)
      .data : 0xc060b1f2 - 0xc0720d94   (1110 kB)
      .text : 0xc0400000 - 0xc060b1f2   (2092 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1199.80 BogoMIPS (lpj=599903)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: a7e9f9bf 00000000 00000000 00000000 00000180 00000000 00000000
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 1024K
CPU: After all inits, caps: a7e9f9bf 00000000 00000000 00002040 00000180 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0800)
CPU0: Intel(R) Pentium(R) M processor 1700MHz stepping 05
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
PM: Adding info for No Bus:platform
Time: 19:02:35  Date: 04/21/107
NET: Registered protocol family 16
PM: Adding info for No Bus:vtcon0
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd8d6, last bus=8
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
PM: Adding info for acpi:acpi_system:00
PM: Adding info for acpi:button_power:00
PM: Adding info for acpi:ACPI0007:00
PM: Adding info for acpi:device:00
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:PNP0C01:00
PM: Adding info for acpi:PNP0C0D:00
PM: Adding info for acpi:PNP0C0E:00
PM: Adding info for acpi:PNP0A03:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0800:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:IBM0057:00
PM: Adding info for acpi:PNP0700:00
PM: Adding info for acpi:device:02
PM: Adding info for acpi:PNP0501:00
PM: Adding info for acpi:PNP0400:00
PM: Adding info for acpi:IBM0071:00
PM: Adding info for acpi:PNP0C09:00
PM: Adding info for acpi:power_resource:00
PM: Adding info for acpi:PNP0C0A:00
PM: Adding info for acpi:ACPI0003:00
PM: Adding info for acpi:IBM0068:00
PM: Adding info for acpi:device:03
PM: Adding info for acpi:video:00
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:bay:00
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:15
PM: Adding info for acpi:thermal:00
PM: Adding info for acpi:thermal:01
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PM: Adding info for No Bus:pci0000:00
PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:1d.0
PM: Adding info for pci:0000:00:1d.1
PM: Adding info for pci:0000:00:1d.2
PM: Adding info for pci:0000:00:1d.7
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.1
PM: Adding info for pci:0000:00:1f.3
PM: Adding info for pci:0000:00:1f.5
PM: Adding info for pci:0000:00:1f.6
PM: Adding info for pci:0000:01:00.0
PM: Adding info for pci:0000:02:00.0
PM: Adding info for pci:0000:02:00.1
PM: Adding info for pci:0000:02:01.0
PM: Adding info for pci:0000:02:02.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: Power Resource [PUBS] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:02
PM: Adding info for pnp:00:03
PM: Adding info for pnp:00:04
PM: Adding info for pnp:00:05
PM: Adding info for pnp:00:06
PM: Adding info for pnp:00:07
PM: Adding info for pnp:00:08
PM: Adding info for pnp:00:09
PM: Adding info for pnp:00:0a
PM: Adding info for pnp:00:0b
PM: Adding info for pnp:00:0c
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xc0000-0xc3fff could not be reserved
pnp: 00:00: iomem range 0xc4000-0xc7fff could not be reserved
pnp: 00:00: iomem range 0xc8000-0xcbfff could not be reserved
Time: tsc clocksource has been installed.
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
PM: Adding info for No Bus:oldmem
PCI: Bridge: 0000:00:01.0
  IO window: 3000-3fff
  MEM window: c0100000-c01fffff
  PREFETCH window: e0000000-e7ffffff
PCI: Bus 3, cardbus bridge: 0000:02:00.0
  IO window: 00004000-000040ff
  IO window: 00004400-000044ff
  PREFETCH window: e8000000-ebffffff
  MEM window: c4000000-c7ffffff
PCI: Bus 7, cardbus bridge: 0000:02:00.1
  IO window: 00004800-000048ff
  IO window: 00004c00-00004cff
  PREFETCH window: ec000000-efffffff
  MEM window: c8000000-cbffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 4000-8fff
  MEM window: c0200000-cfffffff
  PREFETCH window: e8000000-efffffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:02:00.1[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs...<6>Switched to high resolution mode on CPU 0
 it is
Freeing initrd memory: 3466k freed
Simple Boot Flag at 0x35 set to 0x1
IBM machine detected. Enabling interrupts during APM calls.
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
PM: Adding info for platform:pcspkr
PM: Adding info for No Bus:snapshot
audit: initializing netlink socket (disabled)
audit(1179774155.177:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
PM: Adding info for platform:vesafb.0
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3] C4[C3])
ACPI: Processor [CPU] (supports 8 throttling states)
Marking TSC unstable due to: possible TSC halt in C2.
ACPI: Thermal Zone [THM0] (46 C)
PM: Adding info for No Bus:pnp1
isapnp: Scanning for PnP cards...
Time: acpi_pm clocksource has been installed.
isapnp: No Plug & Play device found
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
PM: Adding info for No Bus:rtc
Real Time Clock Driver v1.12ac
PM: Adding info for No Bus:hpet
PM: Adding info for No Bus:nvram
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel 855PM Chipset.
PM: Adding info for No Bus:agpgart
agpgart: AGP aperture is 256M @ 0xd0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
PM: Adding info for platform:serial8250
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
pnp: Device 00:0a activated.
PM: Removing info for No Bus:ttyS0
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
PM: Adding info for No Bus:ttyS0
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI interrupt for device 0000:00:1f.6 disabled
PM: Adding info for No Bus:isa
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
PM: Adding info for No Bus:lo
input: Macintosh mouse button emulation as /class/input/input0
Yenta: CardBus bridge found at 0000:02:00.0 [1014:0552]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:00.0, mfunc 0x01d21b22, devctl 0x64
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000086
pcmcia: parent PCI bridge I/O window: 0x4000 - 0x8fff
cs: IO port probe 0x4000-0x8fff: clean.
pcmcia: parent PCI bridge Memory window: 0xc0200000 - 0xcfffffff
pcmcia: parent PCI bridge Memory window: 0xe8000000 - 0xefffffff
PM: Adding info for No Bus:pcmcia_socket0
Yenta: CardBus bridge found at 0000:02:00.1 [1014:0552]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:00.1, mfunc 0x01d21b22, devctl 0x64
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000086
pcmcia: parent PCI bridge I/O window: 0x4000 - 0x8fff
cs: IO port probe 0x4000-0x8fff: clean.
pcmcia: parent PCI bridge Memory window: 0xc0200000 - 0xcfffffff
pcmcia: parent PCI bridge Memory window: 0xe8000000 - 0xefffffff
PM: Adding info for No Bus:pcmcia_socket1
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
PM: Adding info for serio:serio0
PM: Adding info for serio:serio1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
  Magic number: 7:548:41
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 260k freed
Write protecting the kernel text: 2096k
Write protecting the kernel read-only data: 850k
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
PM: Adding info for usb:usb1
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-0:1.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev1.1_ep81
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001820
PM: Adding info for usb:usb2
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-0:1.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev2.1_ep81
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001840
PM: Adding info for usb:usb3
PM: Adding info for No Bus:usbdev3.1_ep00
usb usb3: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-0:1.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev3.1_ep81
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xc0000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
PM: Adding info for usb:usb4
PM: Adding info for No Bus:usbdev4.1_ep00
usb usb4: configuration #1 chosen from 1 choice
PM: Adding info for usb:4-0:1.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x2c6ab1, caps: 0x884793/0x0
serio: Synaptics pass-through port at isa0060/serio1/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input2
PM: Adding info for serio:serio2
PM: Adding info for No Bus:usbdev4.1_ep81
SCSI subsystem initialized
libata version 2.20 loaded.
ata_piix 0000:00:1f.1: version 2.11
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
PM: Adding info for No Bus:host0
scsi1 : ata_piix
PM: Adding info for No Bus:host1
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00011860 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x00011868 irq 15
ata1: soft resetting port
ata1: reset complete
ata1.00: issuing IDENTIFY
ata1.00: IDENTIFY complete
ata1.00: ata_hpa_resize 1: sectors = 117210240, hpa_sectors = 117210240
ata1.00: ATA-6: HTS726060M9AT00, MH4OA6DA, max UDMA/100
ata1.00: 117210240 sectors, multi 16: LBA 
ata1.00: issuing IDENTIFY
ata1.00: IDENTIFY complete
ata1.00: ata_hpa_resize 1: sectors = 117210240, hpa_sectors = 117210240
ata1.00: configured for UDMA/100
ata1: EH complete
ata2: soft resetting port
ata2: reset complete
ata2.00: issuing IDENTIFY
ata2.00: IDENTIFY complete
ata2.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata2.00: ATA-6: HTS548080M9AT00, MG4OA5HA, max UDMA/100
ata2.00: 156301488 sectors, multi 16: LBA 
ata2.00: issuing IDENTIFY
ata2.00: IDENTIFY complete
ata2.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata2.00: configured for UDMA/100
ata2: EH complete
PM: Adding info for No Bus:target0:0:0
scsi 0:0:0:0: Direct-Access     ATA      HTS726060M9AT00  MH4O PQ: 0 ANSI: 5
PM: Adding info for scsi:0:0:0:0
sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<6>usb 2-2: new full speed USB device using uhci_hcd and address 3
PM: Adding info for usb:2-2
PM: Adding info for No Bus:usbdev2.3_ep00
usb 2-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-2:1.0
PM: Adding info for No Bus:usbdev2.3_ep82
PM: Adding info for No Bus:usbdev2.3_ep01
libusual: modprobe for usb-storage succeeded, but module is not present
 sda1
sd 0:0:0:0: [sda] Attached SCSI disk
PM: Adding info for No Bus:target1:0:0
scsi 1:0:0:0: Direct-Access     ATA      HTS548080M9AT00  MG4O PQ: 0 ANSI: 5
PM: Adding info for scsi:1:0:0:0
sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 1:0:0:0: [sdb] Attached SCSI disk
PM: Adding info for No Bus:device-mapper
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1179774162.345:2): selinux=0 auid=4294967295
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input3
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
Floppy drive(s): fd0 is 1.44M
cs: IO port probe 0x100-0x3af: clean.
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7:<6>FDC 0 is a National Semiconductor PC87306
 clean.
cs: IO port probe 0xa00-0xaff:<7>PM: Adding info for platform:floppy.0
 clean.
cs: IO port probe 0x100-0x3af: clean.
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
iTCO_vendor_support: vendor-support=0
ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PM: Adding info for No Bus:i2c-0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
PM: Adding info for platform:iTCO_wdt
iTCO_wdt: Found a ICH4-M TCO device (Version=1, TCOBASE=0x1060)
PM: Adding info for No Bus:watchdog
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
intel_rng: FWH not detected
PM: Adding info for No Bus:timer
PM: Adding info for No Bus:seq
PM: Adding info for No Bus:sequencer
PM: Adding info for No Bus:sequencer2
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.6 to 64
PM: Adding info for No Bus:pcmC1D0p
PM: Adding info for No Bus:pcmC1D0c
PM: Adding info for No Bus:dsp1
PM: Adding info for No Bus:audio1
PM: Adding info for ac97:1-1:Si3036,8
PM: Adding info for No Bus:controlC1
PM: Adding info for No Bus:mixer1
NET: Registered protocol family 23
pnp: Device 00:0c activated.
nsc-ircc, chip->init
nsc-ircc, Found chip at base=0x02e
nsc-ircc, driver loaded (Dag Brattli)
PM: Adding info for No Bus:irda0
IrDA: Registered device irda0
nsc-ircc, Found dongle: HP HSDL-1100/HSDL-2100
PM: Adding info for platform:nsc-ircc.0
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
e1000: 0000:02:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:11:25:2b:ab:92
PM: Adding info for No Bus:eth0
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x3bc, irq 7 [PCSPP,TRISTATE]
PM: Adding info for platform:parport_pc.956
PM: Removing info for platform:parport_pc.956
PM: Adding info for platform:parport_pc.888
PM: Removing info for platform:parport_pc.888
PM: Adding info for platform:parport_pc.632
PM: Removing info for platform:parport_pc.632
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.5 to 64
AC'97 0 analog subsections not ready
intel8x0_measure_ac97_clock: measured 50315 usecs
intel8x0: clocking to 48000
PM: Adding info for No Bus:pcmC0D4p
PM: Adding info for No Bus:pcmC0D3c
PM: Adding info for No Bus:pcmC0D2c
PM: Adding info for No Bus:pcmC0D1c
PM: Adding info for No Bus:adsp
PM: Adding info for No Bus:pcmC0D0p
PM: Adding info for No Bus:pcmC0D0c
PM: Adding info for No Bus:dsp
PM: Adding info for No Bus:audio
PM: Adding info for ac97:0-0:AD1981B
PM: Adding info for No Bus:controlC0
PM: Adding info for No Bus:mixer
loop: module loaded
lp0: using parport0 (interrupt-driven).
lp0: console ready
sonypi: Sony Programmable I/O Controller Driver v1.26.
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcsa8
PM: Removing info for No Bus:vcs8
PM: Removing info for No Bus:vcsa8
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcsa8
PM: Removing info for No Bus:vcs8
PM: Removing info for No Bus:vcsa8
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcsa8
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.27.0 20060524 on minor 0
Clocksource tsc unstable (delta = -175488522 ns)
ACPI: AC Adapter [AC] (off-line)
ACPI: Battery Slot [BAT0] (battery present)
PM: Adding info for platform:dock.0
ACPI: ACPI Dock Station Driver 
ACPI: \_SB_.PCI0.IDE0.SCND.MSTR: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.SCND.MSTR: Adding notify handler
PM: Adding info for platform:bay.0
ACPI: Bay [\_SB_.PCI0.IDE0.SCND.MSTR] Added
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input5
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SLPB]
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2031608k swap on /dev/VolGroup00/LogVol01.  Priority:-1 extents:1 across:2031608k
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:microcode
PM: Adding info for platform:microcode
PM: Adding info for No Bus:microcode
PM: Removing info for No Bus:microcode
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
PM: Removing info for No Bus:microcode
PM: Removing info for platform:microcode
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
Bluetooth: Core ver 2.11
PM: Adding info for platform:bluetooth
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
usb 2-2: USB disconnect, address 3
PM: Removing info for No Bus:usbdev2.3_ep82
PM: Removing info for No Bus:usbdev2.3_ep01
PM: Removing info for usb:2-2:1.0
PM: Removing info for No Bus:usbdev2.3_ep00
PM: Removing info for usb:2-2
usb 2-2: new full speed USB device using uhci_hcd and address 4
PM: Adding info for usb:2-2
PM: Adding info for No Bus:usbdev2.4_ep00
usb 2-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-2:1.0
PM: Adding info for No Bus:usbdev2.4_ep82
PM: Adding info for No Bus:usbdev2.4_ep01
Initializing USB Mass Storage driver...
scsi2 : SCSI emulation for USB Mass Storage devices
PM: Adding info for No Bus:host2
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
usb-storage: device scan complete
PM: Adding info for No Bus:target2:0:0
scsi 2:0:0:0: Direct-Access     IBM      Memory Key       3.52 PQ: 0 ANSI: 0 CCS
PM: Adding info for No Bus:target2:0:1
PM: Removing info for No Bus:target2:0:1
PM: Adding info for No Bus:target2:0:2
PM: Removing info for No Bus:target2:0:2
PM: Adding info for No Bus:target2:0:3
PM: Removing info for No Bus:target2:0:3
PM: Adding info for No Bus:target2:0:4
PM: Removing info for No Bus:target2:0:4
PM: Adding info for No Bus:target2:0:5
PM: Removing info for No Bus:target2:0:5
PM: Adding info for No Bus:target2:0:6
PM: Removing info for No Bus:target2:0:6
PM: Adding info for No Bus:target2:0:7
PM: Removing info for No Bus:target2:0:7
PM: Adding info for scsi:2:0:0:0
sd 2:0:0:0: [sdc] 499712 512-byte hardware sectors (256 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 45 00 00 08
sd 2:0:0:0: [sdc] Assuming drive cache: write through
sd 2:0:0:0: [sdc] 499712 512-byte hardware sectors (256 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 45 00 00 08
sd 2:0:0:0: [sdc] Assuming drive cache: write through
 sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI removable disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Removing info for No Bus:vcs7
PM: Removing info for No Bus:vcsa7
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 2 usecs

--------------020700050808010200000900
Content-Type: text/plain;
 name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci.txt"

00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller (rev 03)
	Subsystem: IBM Thinkpad T41
	Flags: bus master, fast devsel, latency 0
	Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Capabilities: [e4] Vendor Specific Information
	Capabilities: [a0] AGP version 2.0
00: 86 80 40 33 06 01 90 20 03 00 00 06 00 00 00 00
10: 08 00 00 d0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 29 05
30: 00 00 00 00 e4 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 02 00 00 00 00 00 00 00 00 00 00 00 27 00 00
60: 10 20 30 40 00 00 00 00 00 00 00 00 00 00 00 00
70: 04 04 00 00 00 00 00 00 00 00 02 2d 71 32 40 30
80: 71 00 80 05 00 00 00 00 00 10 01 00 00 00 00 00
90: 10 11 11 01 30 11 11 00 41 19 00 00 00 1a 7d 00
a0: 02 00 20 00 17 02 00 1f 01 03 00 00 00 00 00 00
b0: 80 00 00 00 00 00 00 00 00 00 f0 37 20 10 00 00
c0: 44 40 50 11 00 80 05 06 00 00 00 00 00 00 00 00
d0: 02 28 00 0e 0b 00 00 30 00 00 31 b5 00 00 02 00
e0: 00 00 00 00 09 a0 04 41 00 00 00 00 00 00 00 00
f0: 00 00 01 00 74 f8 20 80 38 0f 21 00 04 00 00 00

00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, fast devsel, latency 96
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: c0100000-c01fffff
	Prefetchable memory behind bridge: e0000000-e7ffffff
00: 86 80 41 33 07 01 a0 00 03 00 04 06 00 60 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 40 30 30 a0 22
20: 10 c0 10 c0 00 e0 f0 e7 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: d4 95 ff 1f 41 f4 09 00 cc 08 94 8c 55 fe 03 00
60: 01 00 00 00 52 48 80 00 b2 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: IBM Thinkpad R50e model 1634
	Flags: bus master, medium devsel, latency 0, IRQ 11
	I/O ports at 1800 [size=32]
00: 86 80 c2 24 05 00 80 02 01 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 18 00 00 00 00 00 00 00 00 00 00 14 10 2d 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: IBM Thinkpad R50e model 1634
	Flags: bus master, medium devsel, latency 0, IRQ 11
	I/O ports at 1820 [size=32]
00: 86 80 c4 24 05 00 80 02 01 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 21 18 00 00 00 00 00 00 00 00 00 00 14 10 2d 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: IBM Thinkpad R50e model 1634
	Flags: bus master, medium devsel, latency 0, IRQ 11
	I/O ports at 1840 [size=32]
00: 86 80 c7 24 05 00 80 02 01 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 41 18 00 00 00 00 00 00 00 00 00 00 14 10 2d 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: IBM Thinkpad R50e model 1634
	Flags: bus master, medium devsel, latency 0, IRQ 11
	Memory at c0000000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port
00: 86 80 cd 24 06 01 90 02 01 20 03 0c 00 00 00 00
10: 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 2e 05
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 04 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 00 80 20 00 00 00 00
60: 20 20 1f 00 00 00 00 00 01 00 00 00 00 00 08 c0
70: 00 00 c7 0f 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 20 00 3f 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 78 bf 1f 00 88 83 00 00 60 0f 00 00 06 00 00 00

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=08, sec-latency=168
	I/O behind bridge: 00004000-00008fff
	Memory behind bridge: c0200000-cfffffff
	Prefetchable memory behind bridge: e8000000-efffffff
00: 86 80 48 24 07 01 80 80 81 00 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 02 08 a8 40 80 80 22
20: 20 c0 f0 cf 00 e8 f0 ef 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 04 00
40: 02 28 20 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 02 74 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 10 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 01 00 02 00 00 00 c0 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 2c 4a

00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 01)
	Flags: bus master, medium devsel, latency 0
00: 86 80 cc 24 0f 00 80 02 01 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 10 00 00 10 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 81 11 00 00 10 00 00 00
60: 0b 0b 0b 0b 92 00 00 00 80 80 80 0b 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: ff fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 24 02 00 00 00 00 00 00 0d 00 00 00 00 00 08 00
b0: 00 00 00 00 00 00 00 00 00 00 02 0a 00 00 00 00
c0: 10 00 00 00 e0 15 00 00 00 00 00 00 0f 00 00 00
d0: 07 28 00 00 02 0f 00 00 04 00 00 00 00 00 00 00
e0: 10 02 00 ff 01 16 0f 3c 33 22 11 00 00 00 67 45
f0: 00 00 00 00 00 00 00 00 60 0f 03 00 00 00 80 00

00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 01) (prog-if 8a [Master SecP PriP])
	Subsystem: IBM Thinkpad R50e model 1634
	Flags: bus master, medium devsel, latency 0, IRQ 11
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 1860 [size=16]
	Memory at 88000000 (32-bit, non-prefetchable) [size=1K]
00: 86 80 ca 24 07 00 80 02 01 8a 01 01 00 00 00 00
10: 01 00 00 00 01 00 00 00 01 00 00 00 01 00 00 00
20: 61 18 00 00 00 00 00 88 00 00 00 00 14 10 2d 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 01 00 00
40: 07 a3 07 a3 00 00 00 00 05 00 01 01 00 00 00 00
50: 00 00 00 00 50 54 00 00 00 00 00 00 00 00 00 00
60: 08 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 01)
	Subsystem: IBM Thinkpad R50e model 1634
	Flags: medium devsel, IRQ 11
	I/O ports at 1880 [size=32]
00: 86 80 c3 24 01 00 80 02 01 00 05 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 18 00 00 00 00 00 00 00 00 00 00 14 10 2d 05
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 02 00 00
40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
	Subsystem: IBM Thinkpad T41
	Flags: bus master, medium devsel, latency 0, IRQ 11
	I/O ports at 1c00 [size=256]
	I/O ports at 18c0 [size=64]
	Memory at c0000c00 (32-bit, non-prefetchable) [size=512]
	Memory at c0000800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
00: 86 80 c5 24 07 00 90 02 01 00 01 04 00 00 00 00
10: 01 1c 00 00 c1 18 00 00 00 0c 00 c0 00 08 00 c0
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 37 05
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
40: 09 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 c2 c9 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 01) (prog-if 00 [Generic])
	Subsystem: IBM Unknown device 0525
	Flags: bus master, medium devsel, latency 0, IRQ 11
	I/O ports at 2400 [size=256]
	I/O ports at 2000 [size=128]
	Capabilities: [50] Power Management version 2
00: 86 80 c6 24 05 00 90 02 01 00 03 07 00 00 00 00
10: 01 24 00 00 01 20 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 25 05
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 c2 c9 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon R250 [Mobility FireGL 9000] (rev 02) (prog-if 00 [VGA])
	Subsystem: IBM Unknown device 0531
	Flags: bus master, stepping, fast Back2Back, 66MHz, medium devsel, latency 66, IRQ 11
	Memory at e0000000 (32-bit, prefetchable) [size=128M]
	I/O ports at 3000 [size=256]
	Memory at c0100000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at c0120000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
	Capabilities: [50] Power Management version 2
00: 02 10 66 4c 87 03 b0 02 02 00 00 03 08 42 00 00
10: 08 00 00 e0 01 30 00 00 00 00 10 c0 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 31 05
30: 00 00 00 00 58 00 00 00 00 00 00 00 0b 01 08 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 31 05
50: 01 00 02 06 00 00 00 00 02 50 20 00 17 02 00 2f
60: 01 03 00 1f 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:00.0 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus Controller (rev 01)
	Subsystem: IBM Unknown device 0552
	Flags: bus master, medium devsel, latency 168, IRQ 11
	Memory at b0000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
	Memory window 0: e8000000-ebfff000 (prefetchable)
	Memory window 1: c4000000-c7fff000
	I/O window 0: 00004000-000040ff
	I/O window 1: 00004400-000044ff
	16-bit legacy interface ports at 0001
00: 4c 10 46 ac 07 00 10 02 01 00 07 06 20 a8 82 00
10: 00 00 00 b0 a0 00 00 02 02 03 06 b0 00 00 00 e8
20: 00 f0 ff eb 00 00 00 c4 00 f0 ff c7 00 40 00 00
30: fc 40 00 00 00 44 00 00 fc 44 00 00 0b 01 c0 05
40: 14 10 52 05 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 71 d0 40 08 00 00 0a 04 00 00 0f 00 22 1b d2 01
90: c0 02 64 41 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 12 fe 00 00 c0 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:00.1 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus Controller (rev 01)
	Subsystem: IBM Unknown device 0552
	Flags: bus master, medium devsel, latency 168, IRQ 11
	Memory at b1000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=07, subordinate=07, sec-latency=176
	Memory window 0: ec000000-effff000 (prefetchable)
	Memory window 1: c8000000-cbfff000
	I/O window 0: 00004800-000048ff
	I/O window 1: 00004c00-00004cff
	16-bit legacy interface ports at 0001
00: 4c 10 46 ac 07 00 10 02 01 00 07 06 20 a8 82 00
10: 00 00 00 b1 a0 00 00 02 02 07 07 b0 00 00 00 ec
20: 00 f0 ff ef 00 00 00 c8 00 f0 ff cb 00 48 00 00
30: fc 48 00 00 00 4c 00 00 fc 4c 00 00 0b 02 c0 05
40: 14 10 52 05 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 71 d0 40 08 00 00 0a 04 00 00 0f 00 22 1b d2 01
90: c0 02 64 41 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 12 fe 00 00 c0 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:01.0 Ethernet controller: Intel Corporation 82540EP Gigabit Ethernet Controller (Mobile) (rev 03)
	Subsystem: IBM PRO/1000 MT Mobile Connection
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
	Memory at c0240000 (32-bit, non-prefetchable) [size=128K]
	Memory at c0200000 (32-bit, non-prefetchable) [size=64K]
	I/O ports at 8000 [size=64]
	[virtual] Expansion ROM at c0220000 [disabled] [size=64K]
	Capabilities: [dc] Power Management version 2
00: 86 80 1e 10 17 01 30 02 03 00 00 02 08 40 00 00
10: 00 00 24 c0 00 00 20 c0 01 80 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 22 00 00 00 14 10 49 05
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0b 01 ff 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 22 c8
e0: 00 20 00 14 07 00 02 00 00 00 40 04 00 00 00 00
f0: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00

02:02.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
	Subsystem: Unknown device 17ab:8331
	Flags: bus master, medium devsel, latency 80, IRQ 11
	Memory at c0210000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [44] Power Management version 2
00: 8c 16 14 10 16 01 90 02 01 00 00 02 08 50 00 00
10: 00 00 21 c0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 01 50 00 00 ab 17 31 83
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 0a 1c
40: 00 00 00 00 01 00 02 00 00 40 00 c6 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


--------------020700050808010200000900--
