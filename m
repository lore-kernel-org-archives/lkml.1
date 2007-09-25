Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbXIYIgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbXIYIgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbXIYIgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:36:47 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:43286 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754997AbXIYIgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:36:45 -0400
Message-ID: <46F8C880.1010006@suse.de>
Date: Tue, 25 Sep 2007 12:36:16 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Damien Wyart <damien.wyart@free.fr>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
References: <20070925065109.GA3080@localhost.localdomain> <20070925003340.5d6dd7f4.akpm@linux-foundation.org>
In-Reply-To: <20070925003340.5d6dd7f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do you have CONFIG_ACPI_SLEEP enabled in your .config?

Andrew Morton wrote:
> On Tue, 25 Sep 2007 08:51:09 +0200 Damien Wyart <damien.wyart@free.fr> wrote:
> 
>> Hello,
>>
>> After testing rc8, I noticed that I couldn't power off the computer
>> directly, it only got halted and I had to press the power button
>> manually. Just before displaying "System halted", the following message
>> is displayed:
>>
>>   ACPI : PCI interrupt for device 0000:02:08.0 disabled
>>
>> I had to first revert 5a50fe709d527f31169263e36601dd83446d5744 then
>> f216cc3748a3a22c2b99390fddcdafa0583791a2 (handling of Sx states) to
>> recover previous behaviour.
> 
> Let's add some cc's.
> 
>> Attached are the dmesg for rc7, rc8 and rc8 with the two patches
>> reverted.
> 
> "diff -u dmesg.rc8_revert dmesg.rc8" says:
> 
> --- dmesg.rc8_revert	2007-09-25 00:31:33.000000000 -0700
> +++ dmesg.rc8	2007-09-25 00:31:30.000000000 -0700
> @@ -1,4 +1,4 @@
> -Linux version 2.6.23-rc8-25092007dw (root@brouette) (gcc version 4.2.1 (Debian 4.2.1-5)) #2 SMP Tue Sep 25 08:31:09 CEST 2007
> +Linux version 2.6.23-rc8-25092007dw (root@brouette) (gcc version 4.2.1 (Debian 4.2.1-5)) #1 SMP Tue Sep 25 07:27:10 CEST 2007
>  BIOS-provided physical RAM map:
>   BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
>   BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> @@ -72,18 +72,18 @@
>  console [tty0] enabled
>  Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
>  Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> -Memory: 2074780k/2096592k available (2175k kernel code, 20712k reserved, 815k data, 192k init, 1179088k highmem)
> +Memory: 2074780k/2096592k available (2175k kernel code, 20712k reserved, 816k data, 192k init, 1179088k highmem)
>  virtual kernel memory layout:
>      fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
>      pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>      vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
>      lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>        .init : 0xc03f0000 - 0xc0420000   ( 192 kB)
> -      .data : 0xc031fd5c - 0xc03ebd04   ( 815 kB)
> -      .text : 0xc0100000 - 0xc031fd5c   (2175 kB)
> +      .data : 0xc031fcd4 - 0xc03ebd04   ( 816 kB)
> +      .text : 0xc0100000 - 0xc031fcd4   (2175 kB)
>  Checking if this processor honours the WP bit even in supervisor mode... Ok.
>  SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
> -Calibrating delay using timer specific routine.. 5987.66 BogoMIPS (lpj=2993833)
> +Calibrating delay using timer specific routine.. 5987.60 BogoMIPS (lpj=2993802)
>  Mount-cache hash table entries: 512
>  CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 0000041d 00000000 00000000 00000000
>  monitor/mwait feature present.
> @@ -104,7 +104,7 @@
>  Booting processor 1/1 eip 2000
>  CPU 1 irqstacks, hard=c0426000 soft=c0424000
>  Initializing CPU#1
> -Calibrating delay using timer specific routine.. 5984.18 BogoMIPS (lpj=2992093)
> +Calibrating delay using timer specific routine.. 5984.16 BogoMIPS (lpj=2992084)
>  CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 0000041d 00000000 00000000 00000000
>  monitor/mwait feature present.
>  CPU: Trace cache: 12K uops, L1 D cache: 16K
> @@ -116,7 +116,7 @@
>  CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
>  CPU1: Thermal monitoring enabled
>  CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 03
> -Total of 2 processors activated (11971.85 BogoMIPS).
> +Total of 2 processors activated (11971.77 BogoMIPS).
>  ENABLING IO-APIC IRQs
>  ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
>  checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> @@ -279,6 +279,7 @@
>  EXT3-fs: mounted filesystem with ordered data mode.
>  VFS: Mounted root (ext3 filesystem) readonly.
>  Freeing unused kernel memory: 192k freed
> +input: PC Speaker as /devices/platform/pcspkr/input/input4
>  sr0: scsi3-mmc drive: 1x/48x cd/rw xa/form2 cdda tray
>  Uniform CD-ROM driver Revision: 3.20
>  sr 1:0:0:0: Attached scsi CD-ROM sr0
> @@ -287,7 +288,6 @@
>  usbcore: registered new interface driver usbfs
>  usbcore: registered new interface driver hub
>  usbcore: registered new device driver usb
> -input: PC Speaker as /devices/platform/pcspkr/input/input4
>  parport_pc 00:0a: reported by Plug and Play ACPI
>  parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
>  USB Universal Host Controller Interface driver v3.0
> @@ -299,46 +299,42 @@
>  usb usb1: configuration #1 chosen from 1 choice
>  hub 1-0:1.0: USB hub found
>  hub 1-0:1.0: 2 ports detected
> -ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 20
> -PCI: Setting latency timer of device 0000:00:1d.1 to 64
> -uhci_hcd 0000:00:1d.1: UHCI Host Controller
> -uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
> -uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000ff60
> +ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 20
> +PCI: Setting latency timer of device 0000:00:1d.7 to 64
> +ehci_hcd 0000:00:1d.7: EHCI Host Controller
> +ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
> +ehci_hcd 0000:00:1d.7: debug port 1
> +PCI: cache line size of 128 is not supported by device 0000:00:1d.7
> +ehci_hcd 0000:00:1d.7: irq 20, io mem 0xffa80800
> +ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
>  usb usb2: configuration #1 chosen from 1 choice
>  hub 2-0:1.0: USB hub found
> -hub 2-0:1.0: 2 ports detected
> +hub 2-0:1.0: 8 ports detected
> +ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 21
> +PCI: Setting latency timer of device 0000:00:1d.1 to 64
> +uhci_hcd 0000:00:1d.1: UHCI Host Controller
> +uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> +uhci_hcd 0000:00:1d.1: irq 21, io base 0x0000ff60
> +usb usb3: configuration #1 chosen from 1 choice
> +hub 3-0:1.0: USB hub found
> +hub 3-0:1.0: 2 ports detected
>  ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 17
>  PCI: Setting latency timer of device 0000:00:1d.2 to 64
>  uhci_hcd 0000:00:1d.2: UHCI Host Controller
> -uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
> +uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
>  uhci_hcd 0000:00:1d.2: irq 17, io base 0x0000ff40
> -usb usb3: configuration #1 chosen from 1 choice
> -hub 3-0:1.0: USB hub found
> -hub 3-0:1.0: 2 ports detected
> -usb 1-1: new full speed USB device using uhci_hcd and address 2
> +usb usb4: configuration #1 chosen from 1 choice
> +hub 4-0:1.0: USB hub found
> +hub 4-0:1.0: 2 ports detected
>  ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 19
>  PCI: Setting latency timer of device 0000:00:1d.3 to 64
>  uhci_hcd 0000:00:1d.3: UHCI Host Controller
> -uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
> +uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
>  uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000ff20
> -usb usb4: configuration #1 chosen from 1 choice
> -hub 4-0:1.0: USB hub found
> -hub 4-0:1.0: 2 ports detected
> -ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 21
> -PCI: Setting latency timer of device 0000:00:1d.7 to 64
> -ehci_hcd 0000:00:1d.7: EHCI Host Controller
> -ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
> -ehci_hcd 0000:00:1d.7: debug port 1
> -PCI: cache line size of 128 is not supported by device 0000:00:1d.7
> -ehci_hcd 0000:00:1d.7: irq 21, io mem 0xffa80800
> -ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> -usb 1-1: configuration #1 chosen from 1 choice
> -usb 1-1: can't set config #1, error -71
>  usb usb5: configuration #1 chosen from 1 choice
>  hub 5-0:1.0: USB hub found
> -hub 5-0:1.0: 8 ports detected
> -usb 1-1: USB disconnect, address 2
> -usb 1-1: new full speed USB device using uhci_hcd and address 3
> +hub 5-0:1.0: 2 ports detected
> +usb 1-1: new full speed USB device using uhci_hcd and address 2
>  usb 1-1: configuration #1 chosen from 1 choice
>  Adding 1212896k swap on /dev/sdb7.  Priority:-1 extents:1 across:1212896k
>  EXT3 FS on sdb2, internal journal
> 

