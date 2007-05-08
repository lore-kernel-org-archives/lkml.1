Return-Path: <linux-kernel-owner+w=401wt.eu-S967637AbXEHClE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967637AbXEHClE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 22:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967630AbXEHClA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 22:41:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:9479 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967561AbXEHCk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 22:40:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,503,1170662400"; 
   d="scan'208";a="240547097"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/8] Restructuring hpet timer generic clock interfaces
Date: Mon, 7 May 2007 19:40:47 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F55DF0A8@scsmsx415.amr.corp.intel.com>
In-Reply-To: <200705080247.54463.caglar@pardus.org.tr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/8] Restructuring hpet timer generic clock interfaces
thread-index: AceRAkeGQd/w4V0ORDy3Gs5DxfaGQgAFwL5w
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: <caglar@pardus.org.tr>
CC: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andi Kleen" <ak@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Chris Wright" <chrisw@sous-sol.org>
X-OriginalArrivalTime: 08 May 2007 02:40:49.0312 (UTC) FILETIME=[49966A00:01C7911A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: S.Çaðlar Onur [mailto:caglar@pardus.org.tr] 
>Sent: Monday, May 07, 2007 4:48 PM
>To: Pallipadi, Venkatesh
>Cc: linux-kernel; Andrew Morton; Thomas Gleixner; Andi Kleen; 
>Ingo Molnar; Chris Wright
>Subject: Re: [PATCH 1/8] Restructuring hpet timer generic 
>clock interfaces
>
>Hi;
>
>07 May 2007 Pts tarihinde, Venki Pallipadi þunlarý yazmýþtý: 
>> i386 HPET changes.
>>
>> Patchset does the following changes to HPET support:
>> * Add HPET force detect to ICH chipsets, and detect the
>>   presence of HPET through PCI quirk.
>> * Enable HPET timer to function in standard interrupt delivery mode,
>> against the current legacy replacement mode
>> * Enable HPET as a PER CPU time event, which will help in 
>laptops that
>>   supports C3 and hence has unreliable LAPIC timer.
>>
>> The changes enable processors to stay in idle longer, by 
>increasing the
>> average time spend in an idle state per call, by more than twice, on
>> my dual core laptop. It reduces the number of interrupts on a totally
>> idle system, compared to when I use PIT.
>
>My machine (SONY VAIO FS-215B) just hangs/freezes (no oops, no 
>MAGIC_SYSRQ) 
>after writing "ACPI: Power Button (CM) [PWRB]" on screen
>
>...
>Machine check exception polling timer started.
>apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
>audit: initializing netlink socket (disabled)
>audit(1178591695.734:1): initialized
>highmem bounce pool size: 64 pages
>VFS: Disk quotas dquot_6.5.1
>Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
>io scheduler noop registered
>io scheduler anticipatory registered
>io scheduler deadline registered
>io scheduler cfq registered (default)
>ACPI: AC Adapter [ADP1] (on-line)
>ACPI: Battery Slot [BAT0] (battery present)
>input: Power Button (FF) as /class/input/input0
>ACPI: Power Button (FF) [PWRF]
>input: Lid Switch as /class/input/input1
>ACPI: Lid Switch [LID0]
>input: Power Button (CM) as /class/input/input2
>ACPI: Power Button (CM) [PWRB]
>
>Normal boot sequence continues with following;
>
>ACPI: CPU0 (power states: C1[C1] C2[C2])
>ACPI: Processor [CPU0] (supports 8 throttling states)
>ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor 
>Device is not 
>present [20070126]
>ACPI: Thermal Zone [THRM] (98 C)
>isapnp: Scanning for PnP cards...
>Time: acpi_pm clocksource has been installed.
>isapnp: No Plug & Play device found
>Real Time Clock Driver v1.12ac
>Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
>sharing enabled
>Clocksource tsc unstable (delta = -490158796 ns)
>floppy0: no floppy controllers found
>RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
>loop: loaded (max 8 devices)
>...
>
>System boots fine with hpet=disable and by the way, i tried 
>the first version 
>of this patchset without a problem (if i remembered correctly, 
>it was just 
>force detects the hpet but only enables for x86_64)
>
>zangetsu ~ # lspci
>00:00.0 Host bridge: Intel Corporation Mobile 
>915GM/PM/GMS/910GML Express 
>Processor to DRAM Controller (rev 03)
>00:02.0 VGA compatible controller: Intel Corporation Mobile 
>915GM/GMS/910GML 
>Express Graphics Controller (rev 03)
>00:02.1 Display controller: Intel Corporation Mobile 
>915GM/GMS/910GML Express 
>Graphics Controller (rev 03)
>00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW 
>(ICH6 Family) 
>High Definition Audio Controller (rev 03)
>00:1d.0 USB Controller: Intel Corporation 
>82801FB/FBM/FR/FW/FRW (ICH6 Family) 
>USB UHCI #1 (rev 03)
>00:1d.1 USB Controller: Intel Corporation 
>82801FB/FBM/FR/FW/FRW (ICH6 Family) 
>USB UHCI #2 (rev 03)
>00:1d.2 USB Controller: Intel Corporation 
>82801FB/FBM/FR/FW/FRW (ICH6 Family) 
>USB UHCI #3 (rev 03)
>00:1d.3 USB Controller: Intel Corporation 
>82801FB/FBM/FR/FW/FRW (ICH6 Family) 
>USB UHCI #4 (rev 03)
>00:1d.7 USB Controller: Intel Corporation 
>82801FB/FBM/FR/FW/FRW (ICH6 Family) 
>USB2 EHCI Controller (rev 03)
>00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3)
>00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC 
>Interface Bridge 
>(rev 03)
>00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW 
>(ICH6 Family) 
>IDE Controller (rev 03)
>00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 
>Family) SMBus 
>Controller (rev 03)
>06:03.0 CardBus bridge: Texas Instruments PCI7420 CardBus Controller
>06:03.2 FireWire (IEEE 1394): Texas Instruments PCI7x20 
>1394a-2000 OHCI 
>Two-Port PHY/Link-Layer Controller
>06:03.3 Mass storage controller: Texas Instruments 
>PCI7420/7620 Combo CardBus, 
>1394a-2000 OHCI and SD/MS-Pro Controller
>06:04.0 Network controller: Intel Corporation PRO/Wireless 
>2200BG Network 
>Connection (rev 05)
>06:08.0 Ethernet controller: Intel Corporation 
>82562ET/EZ/GT/GZ - PRO/100 VE 
>(LOM) Ethernet Controller Mobile (rev 03)
>
>Cheers
>-- 
>S.Çaðlar Onur <caglar@pardus.org.tr>
>http://cekirdek.pardus.org.tr/~caglar/
>
>Linux is like living in a teepee. No Windows, no Gates and an 
>Apache in house!
>

Hmm. Looks like timer was somehow not set correctly.
Can you try only the first 5 patches in the patchset and leave out the last three and check whether it works.

Thanks,
Venki
