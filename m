Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZI1USZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZI1USZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZI1USY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:18:24 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:44499 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZI1USX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:18:23 -0400
Message-ID: <4AC11A0F.2030806@mandriva.org>
Date: Mon, 28 Sep 2009 23:18:23 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090830)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Lin Ming <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [git pull request] ACPI & driver patches for Linux-2.6.32-rc0
References: <alpine.LFD.2.00.0909190237560.22030@localhost.localdomain> <4ABCB2CA.4020709@mandriva.org> <d3f22a0909261902o5e48c2a0lab56fca21edf8c5b@mail.gmail.com> <1254016503.17697.21.camel@minggr.sh.intel.com> <alpine.LFD.2.00.0909270348570.16783@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0909270348570.16783@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------070606070600080200090103"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070606070600080200090103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Len Brown wrote:
>>> This gets my laptop flooding logs with:
> 
>>>> ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20090903/evregion-424)
>>>> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.GBST] (Node ffff88013f81c5e0), AE_TIME
>>>> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.BAT0._BST] (Node ffff88013f81c720), AE_TIME
>>>> ACPI Exception: AE_TIME, Evaluating _BST (20090903/battery-393)
> 
>> Could you do a bisect?
> 
> In particular, please try the 2.6.31 versio of drivers/acpi/ec.c
> 

Hi,

in order to get the 2.6.31 version of ec.c to build I had to apply a 
small patch:

> --- linux-acpi/drivers/acpi/ec.c.orig	2009-09-10 01:13:59.000000000 +0300
> +++ linux-acpi/drivers/acpi/ec.c	2009-09-28 21:09:15.359406828 +0300
> @@ -42,6 +42,7 @@
>  #include <asm/io.h>
>  #include <acpi/acpi_bus.h>
>  #include <acpi/acpi_drivers.h>
> +#include <linux/dmi.h>
>  
>  #define ACPI_EC_CLASS			"embedded_controller"
>  #define ACPI_EC_DEVICE_NAME		"Embedded Controller"
> @@ -1078,7 +1079,6 @@ static struct acpi_driver acpi_ec_driver
>  		.add = acpi_ec_add,
>  		.remove = acpi_ec_remove,
>  		.start = acpi_ec_start,
> -		.stop = acpi_ec_stop,
>  		.suspend = acpi_ec_suspend,
>  		.resume = acpi_ec_resume,
>  		},

After that  it built and the errors are gone.

Now this is a Acer TravelMate 5720G laptop with the latest 1.35 bios.
Distro is Mandriva Linux Cooker, and arch is x86_64

Attached is output of "grep ACPI /var/log/dmesg"
dmesg-acpi-20090903
- all acpi patches as of 2.6.32-rc1

dmesg-acpi-20090903-ec-2.6.31
- all acpi patches as of 2.6.32-rc1
- ec.c from 2.6.31.1


Should I start bisecting, or do you have any other suggestion?

--
Thomas

--------------070606070600080200090103
Content-Type: text/plain;
 name="dmesg-acpi-20090903"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-acpi-20090903"

 BIOS-e820: 00000000bfed0000 - 00000000bfedf000 (ACPI NVS)
ACPI: RSDP 00000000000f7bf0 00024 (v02 PTLTD )
ACPI: XSDT 00000000bfed160e 0008C (v01 ACRSYS ACRPRDCT 06040000 INNA 00000000)
ACPI: FACP 00000000bfedbbd7 000F4 (v03 INTEL  CRESTLNE 06040000 ALAN 00000001)
ACPI: DSDT 00000000bfed2bba 08FA9 (v02 INTEL  CRESTLNE 06040000 MSFT 03000000)
ACPI: FACS 00000000bfedefc0 00040
ACPI: HPET 00000000bfedbccb 00038 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
ACPI: MCFG 00000000bfedbd03 0003C (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
ACPI: TCPA 00000000bfedbd3f 00032 (v01 Intel   CRESTLN 06040000      00005A52)
ACPI: TMOR 00000000bfedbd71 00026 (v01 PTLTD           06040000 PTL  00000003)
ACPI: SLIC 00000000bfedbd97 00176 (v01 ACRSYS ACRPRDCT 06040000 ANNI 00000001)
ACPI: ASF! 00000000bfedbf0d 00063 (v32 OEMID  OEMTBL   06040000 PTL  00000001)
ACPI: APIC 00000000bfedbf70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
ACPI: BOOT 00000000bfedbfd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
ACPI: SSDT 00000000bfed28dd 002DD (v01 SataRe SataAhci 00001000 INTL 20050624)
ACPI: SSDT 00000000bfed1c56 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
ACPI: SSDT 00000000bfed1bb0 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050624)
ACPI: SSDT 00000000bfed169a 00516 (v01  PmRef    CpuPm 00003000 INTL 20050624)
ACPI: Local APIC address 0xfee00000
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
ACPI: Core revision 20090903
ACPI: bus type pci registered
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Enumerating devices from [\]
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 10 *11)
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
ACPI Warning for \_SB_.PCI0.SATA.PRT0._GTF: Return type mismatch - found Integer, expected Buffer (20090903/nspredef-1006)
ACPI Error (psargs-0359): [\_PR_.CPU0.CSTX] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_._Q2F] (Node ffff88013f81c1a0), AE_NOT_FOUND
ACPI: WMI: Mapper loaded
ACPI: I/O resource 0000:00:1f.3 [0x1c00-0x1c1f] conflicts with ACPI region SMBI [0x1c00-0x1c0f]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
acer-wmi: Acer Laptop ACPI-WMI Extras
tg3 0000:02:00.0: wake-up capability disabled by ACPI
ACPI: AC Adapter [ADP1] (on-line)
ACPI: Extensa 5220 detected - disabling mwait for CPU C-states
ACPI: Lid Switch [LID0]
ACPI: Sleep Button [SLPB]
ACPI: SSDT 00000000bfed2559 002BC (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: SSDT 00000000bfed1eb5 0061F (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Power Button [PWRF]
ACPI: SSDT 00000000bfed2815 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
ACPI: SSDT 00000000bfed24d4 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [TZS0] (41 C)
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
ACPI Warning for \_SB_.PCI0.LPCB.EC0_.BAT0._BIF: Converted Buffer to expected String at index 9 (20090903/nsrepair-132)
ACPI Warning for \_SB_.PCI0.LPCB.EC0_.BAT0._BIF: Converted Buffer to expected String at index 10 (20090903/nsrepair-132)
ACPI Warning for \_SB_.PCI0.LPCB.EC0_.BAT0._BIF: Converted Buffer to expected String at index 11 (20090903/nsrepair-132)
ACPI Warning for \_SB_.PCI0.LPCB.EC0_.BAT0._BIF: Converted Buffer to expected String at index 12 (20090903/nsrepair-132)
ACPI: Thermal Zone [TZS1] (51 C)
ACPI: Battery Slot [BAT0] (battery present)

--------------070606070600080200090103
Content-Type: text/plain;
 name="dmesg-acpi-20090903-ec-2.6.31"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-acpi-20090903-ec-2.6.31"

 BIOS-e820: 00000000bfed0000 - 00000000bfedf000 (ACPI NVS)
ACPI: RSDP 00000000000f7bf0 00024 (v02 PTLTD )
ACPI: XSDT 00000000bfed160e 0008C (v01 ACRSYS ACRPRDCT 06040000 INNA 00000000)
ACPI: FACP 00000000bfedbbd7 000F4 (v03 INTEL  CRESTLNE 06040000 ALAN 00000001)
ACPI: DSDT 00000000bfed2bba 08FA9 (v02 INTEL  CRESTLNE 06040000 MSFT 03000000)
ACPI: FACS 00000000bfedefc0 00040
ACPI: HPET 00000000bfedbccb 00038 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
ACPI: MCFG 00000000bfedbd03 0003C (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
ACPI: TCPA 00000000bfedbd3f 00032 (v01 Intel   CRESTLN 06040000      00005A52)
ACPI: TMOR 00000000bfedbd71 00026 (v01 PTLTD           06040000 PTL  00000003)
ACPI: SLIC 00000000bfedbd97 00176 (v01 ACRSYS ACRPRDCT 06040000 ANNI 00000001)
ACPI: ASF! 00000000bfedbf0d 00063 (v32 OEMID  OEMTBL   06040000 PTL  00000001)
ACPI: APIC 00000000bfedbf70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
ACPI: BOOT 00000000bfedbfd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
ACPI: SSDT 00000000bfed28dd 002DD (v01 SataRe SataAhci 00001000 INTL 20050624)
ACPI: SSDT 00000000bfed1c56 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
ACPI: SSDT 00000000bfed1bb0 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050624)
ACPI: SSDT 00000000bfed169a 00516 (v01  PmRef    CpuPm 00003000 INTL 20050624)
ACPI: Local APIC address 0xfee00000
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
ACPI: Core revision 20090903
ACPI: bus type pci registered
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Enumerating devices from [\]
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 10 *11)
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
ACPI Warning for \_SB_.PCI0.SATA.PRT0._GTF: Return type mismatch - found Integer, expected Buffer (20090903/nspredef-1006)
ACPI: AC Adapter [ADP1] (on-line)
ACPI: Extensa 5220 detected - disabling mwait for CPU C-states
ACPI: SSDT 00000000bfed2559 002BC (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: SSDT 00000000bfed1eb5 0061F (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 00000000bfed2815 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
ACPI: SSDT 00000000bfed24d4 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Lid Switch [LID0]
ACPI: Sleep Button [SLPB]
ACPI: Power Button [PWRF]
ACPI: WMI: Mapper loaded
tg3 0000:02:00.0: wake-up capability disabled by ACPI
ACPI: Thermal Zone [TZS0] (44 C)
ACPI: Thermal Zone [TZS1] (58 C)
acer-wmi: Acer Laptop ACPI-WMI Extras
ACPI Warning for \_SB_.PCI0.LPCB.EC0_.BAT0._BIF: Converted Buffer to expected String at index 9 (20090903/nsrepair-132)
ACPI Warning for \_SB_.PCI0.LPCB.EC0_.BAT0._BIF: Converted Buffer to expected String at index 10 (20090903/nsrepair-132)
ACPI Warning for \_SB_.PCI0.LPCB.EC0_.BAT0._BIF: Converted Buffer to expected String at index 11 (20090903/nsrepair-132)
ACPI Warning for \_SB_.PCI0.LPCB.EC0_.BAT0._BIF: Converted Buffer to expected String at index 12 (20090903/nsrepair-132)
ACPI: Battery Slot [BAT0] (battery present)
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
ACPI: I/O resource 0000:00:1f.3 [0x1c00-0x1c1f] conflicts with ACPI region SMBI [0x1c00-0x1c0f]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver

--------------070606070600080200090103--
