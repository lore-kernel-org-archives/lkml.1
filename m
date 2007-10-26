Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbXJZQ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbXJZQ5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXJZQ5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:57:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:61206 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbXJZQ5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=lU2yz4loYAL9rDXM2/yj0VrjVSmuD4Q9FcQnZv1utLHYk5hhkTiUph2sjIS4nt+A6FeOCP0PIT8UTsutaXI6ZSWx02vxu9b79Dd3hLiskzrJbfLZQqOvsqVbIveAlmM1Ew2zZiymyAisjZ/7xkFrSd/oheFUX2T/iOeGMpWA320=
Message-ID: <47221C67.9050502@gmail.com>
Date: Fri, 26 Oct 2007 20:57:11 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.624-rc1 regression] lost battery information
References: <200710262024.06012.arvidjaar@mail.ru>
In-Reply-To: <200710262024.06012.arvidjaar@mail.ru>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------070302060501050100090503"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070302060501050100090503
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrey Borzenkov wrote:
> I have lost battery in 2.6.24-rc1. Without CONFIG_ACPI_PROCFS I have 
> no /proc/acpi/battery and cannot test netlink interface because right now 
> there is no consumer of this.
for /sysfs interface you need to enable power_supply driver.
or you could apply this patch and power_supply will be selected by battery itself.
> 
> With CONFIG_ACPI_PROCFS I get
> 
> {pts/1}% LC_ALL=C ll /proc/acpi/battery/BAT1
> total 0
> -rw-r--r-- 1 root root 0 Oct 26 20:18 alarm
> -r--r--r-- 1 root root 0 Oct 26 20:18 info
> -r--r--r-- 1 root root 0 Oct 26 20:18 state
> {pts/1}% LC_ALL=C  cat /proc/acpi/battery/BAT1/*
> cat: /proc/acpi/battery/BAT1/alarm: Bad address
> cat: /proc/acpi/battery/BAT1/info: Bad address
> cat: /proc/acpi/battery/BAT1/state: Bad address
Could you make sure it's a clean build with all drivers updated/kernel included?
> {pts/1}% LC_ALL=C ll /proc/acpi/battery/BAT2
> total 0
> -rw-r--r-- 1 root root 0 Oct 26 20:18 alarm
> -r--r--r-- 1 root root 0 Oct 26 20:18 info
> -r--r--r-- 1 root root 0 Oct 26 20:18 state
> {pts/1}% LC_ALL=C cat /proc/acpi/battery/BAT2/*
> present:                 no
> present:                 no
> present:                 no
> 
> BAT2 is correct - it is not present. BAT1 is lying. There is nothing in dmesg. 
> battery is loaded (obviously)
> 
> ACPI related stuff from dmesg:
> 
> {pts/1}% dmesg |grep ACPI
> [    0.000000]  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000001ef60000 - 000000001ef70000 (ACPI data)
> [    0.000000] ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
> [    0.000000] ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814 TASM  
> 4010000)
> [    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM  
> 4010000)
> [    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT  
> 100000A)
> [    0.000000] ACPI: FACS 000EEE00, 0040
> [    0.000000] ACPI: PM-Timer IO Port: 0xee08
> [  896.112009] ACPI: Core revision 20070126
> [  896.112775] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml 
> not found.
> [  896.123590]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables 
> successfully acquired
> [  896.123631] ACPI: setting ELCR to 0200 (from 0a00)
> [  896.124208] evxfevnt-0091 [00] enable                : Transition to ACPI 
> mode successful
> [  896.131744] ACPI: bus type pci registered
> [  896.149165] ACPI: EC: Look up EC in DSDT
> [  896.163343] ACPI: Interpreter enabled
> [  896.163362] ACPI: (supports S0 S3 S4 S5)
> [  896.163510] ACPI: Using PIC for interrupt routing
> [  896.195892] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [  896.197650] PCI quirk: region ee00-ee3f claimed by ali7101 ACPI
> [  896.200015] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [  896.200588] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
> [  896.227797] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
> [  896.228562] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
> [  896.229271] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
> [  896.230101] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
> [  896.230818] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
> [  896.231527] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
> [  896.232912] ACPI: Power Resource [PFAN] (off)
> [  896.233622] pnp: PnP ACPI init
> [  896.233766] ACPI: bus type pnp registered
> [  896.257679] pnp: PnP ACPI: found 12 devices
> [  896.257737] ACPI: ACPI bus type pnp unregistered
> [  896.258820] PCI: Using ACPI for IRQ routing
> [  896.325763] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> [  896.325805] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI 11 
> (level, low) -> IRQ 11
> [  896.327116] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
> [  896.327143] ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11 
> (level, low) -> IRQ 11
> [  896.328392] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> [  896.328416] ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11 
> (level, low) -> IRQ 11
> [  896.978962] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
> [  896.980097] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11 
> (level, low) -> IRQ 11
> [  902.378588] ACPI: Unable to derive IRQ for device 0000:00:04.0
> [  902.406719] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
> [  919.051426] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
> [  919.051451] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11 
> (level, low) -> IRQ 11
> [  920.132284] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
> [  920.132307] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11 
> (level, low) -> IRQ 11
> [  927.120073] ACPI: AC Adapter [ADP1] (on-line)
> [  927.195942] ACPI: Battery Slot [BAT1] (battery present)
> [  927.200475] ACPI: Battery Slot [BAT2] (battery absent)
> [  927.277564] ACPI: Power Button (FF) [PWRF]
> [  927.290786] ACPI: Lid Switch [LID]
> [  927.324850] ACPI: Transitioning device [FAN] to D3
> [  927.324867] ACPI: Transitioning device [FAN] to D3
> [  927.324891] ACPI: Fan [FAN] (off)
> [  927.535960] ACPI: CPU0 (power states: C1[C1] C2[C2])
> [  927.638487] ACPI: Thermal Zone [THRM] (55 C)
> [  927.770100] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
> [  927.920519] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
> [ 1055.552624] ACPI: PCI interrupt for device 0000:00:0a.0 disabled
> [ 1055.554812] ACPI: PCI interrupt for device 0000:00:06.0 disabled
> [ 1055.555479] ACPI: PCI interrupt for device 0000:00:02.0 disabled
> [    0.901020] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11 
> (level, low) -> IRQ 11
> [    0.901271] ACPI: Unable to derive IRQ for device 0000:00:04.0
> [    0.901278] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
> [    0.904594] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11 
> (level, low) -> IRQ 11
> 
> 
> As for the case without ACPI_PROCFS ... well, I do not have it in /proc - 
> which is expected - but neither I do have it in /sys. And Kconfig help reads
> 
>           The deprecated files (and their replacements) include:
> 
>           /proc/acpi/sleep (/sys/power/state)
>           /proc/acpi/info (/sys/modules/acpi/parameters/acpica_version)
>           /proc/acpi/dsdt (/sys/firmware/acpi/tables/DSDT)
>           /proc/acpi/fadt (/sys/firmware/acpi/tables/FACP)
>           /proc/acpi/debug_layer (/sys/module/acpi/parameters/debug_layer)
>           /proc/acpi/debug_level (/sys/module/acpi/parameters/debug_level)
> 
> neither does it mention /proc/acpi/battery not do I actually have any battery 
> information in /sys.
> 
> Personally I do not like it (if it is intentional). Leaving only netlink 
> interface means user has no way to query for actual state. We need something 
> running all the time and hope, it never loses any event and thus reflects 
> actual state. But it also means we are not allowed to restart it (whatever it 
> is) as it will have no way to query for actual state on restart ...
> 
> -andrey


--------------070302060501050100090503
Content-Type: text/x-diff;
 name="use_select_for_power_class.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="use_select_for_power_class.patch"

ACPI: use select POWER_SUPPLY for AC, BATTERY and SBS

From: Alexey Starikovskiy <astarikovskiy@suse.de>

POWER_SUPPLY is needed for AC, battery, and SBS sysfs support.
Use 'select' instead of 'depends on', as it is will not be selected
by anything else, leading to confusion.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/Kconfig |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 5d0e26a..ecd87d7 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -88,7 +88,8 @@ config ACPI_PROC_EVENT
 
 config ACPI_AC
 	tristate "AC Adapter"
-	depends on X86 && POWER_SUPPLY
+	depends on X86
+	select POWER_SUPPLY
 	default y
 	help
 	  This driver adds support for the AC Adapter object, which indicates
@@ -97,7 +98,8 @@ config ACPI_AC
 
 config ACPI_BATTERY
 	tristate "Battery"
-	depends on X86 && POWER_SUPPLY
+	depends on X86
+	select POWER_SUPPLY
 	default y
 	help
 	  This driver adds support for battery information through
@@ -352,7 +354,7 @@ config ACPI_HOTPLUG_MEMORY
 config ACPI_SBS
 	tristate "Smart Battery System"
 	depends on X86
-	depends on POWER_SUPPLY
+	select POWER_SUPPLY
 	help
 	  This driver adds support for the Smart Battery System, another
 	  type of access to battery information, found on some laptops.

--------------070302060501050100090503--
