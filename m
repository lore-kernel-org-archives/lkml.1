Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYHMK7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYHMK7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYHMK65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:58:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:56103 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYHMK64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:58:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:in-reply-to:references:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=tupLg2lXXa9FPHoFMrSMDwp8fO3eyvTa/Jk7nq9nkb2upoiETg7GwdyaaTAq9i0BoB
         8XS8di9vBWrB4zS2k2NkYGkrhP3nqCIXcHPq5mTK5nqqGYVRf0phGl+Xb426PDGVYD3k
         8NjzXh52ksIJp6klxuAGbO9HK7swAE4LGl/J8=
Subject: Re: Timer unstability on when using C2 and deeper sleep states
	(Dell Latitude XT)
From: Milan Plzik <milan.plzik@gmail.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1218566008.13866.41.camel@localhost>
References: <1218566008.13866.41.camel@localhost>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 12:58:45 +0200
Message-Id: <1218625125.4304.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  I apologize for replying on my own mail (and also for top-posting, but
this information is global update, not exactly fitting any of topics
mentioned below).

  After playing for a longer while I found out that the system ends
sometimes in state where, in order to do anything useful, I need to
press keys on keyboard. Otherwise, the system just stalls and does
nothing. I have no idea why does this happen (especially when I know
that OHCI or wireless network adapter produce fair amount of
interrupts). My /proc/interrupts is below. Just for the record, chipset
on board is ATI RS600 with (apparently from lspci) ATI SB600
southbridge.

#  cat /proc/interrupts 
           CPU0       CPU1       
  0:         94          0   IO-APIC-edge      timer
  1:       3034          0   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc0
  9:          1          0   IO-APIC-fasteoi   acpi
 12:      13677          0   IO-APIC-edge      i8042
 14:      13679          0   IO-APIC-fasteoi   pata_atiixp
 15:          0          0   IO-APIC-edge      pata_atiixp
 16:          0          0   IO-APIC-fasteoi   ohci_hcd:usb2
 17:     238527          0   IO-APIC-fasteoi   ohci_hcd:usb3, ohci_hcd:usb5, HDA Intel
 18:      26960          0   IO-APIC-fasteoi   ndiswrapper, fglrx[0]@PCI:1:5:0
 19:        475          0   IO-APIC-fasteoi   ehci_hcd:usb1
 20:         20          0   IO-APIC-fasteoi   ohci_hcd:usb4, ohci_hcd:usb6
 22:          0          0   IO-APIC-fasteoi   mmc0
 23:          3          0   IO-APIC-fasteoi   ohci1394
316:          2          0   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:     629038     206882   Local timer interrupts
RES:      15738      15713   Rescheduling interrupts
CAL:         24         72   function call interrupts
TLB:        968       2244   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0



On Ut, 2008-08-12 at 20:33 +0200, Milan Plzik wrote:
> Good day,
> 
>   This e-mail will be a bit longer, as I will describe everything I was
> able to find out about $subj. I'm not 100% sure that the issue is what
> it seems to be (not even sure I'm posting to correct mailing list), so
> if you see I did something wrong, please tell me. Also please, Cc: me,
> as I'm not (yet, I was not able to find out how) subscribed to this
> mailing list.
> 
>   I started to experiment with Linux on Dell Latitude XT, actually with
> 2.6.26 (for more info see [1]). The system seems to be more or less
> operational, when booting without any special arguments, but sometimes
> it hangs for few seconds with no reason. This becomes more apparent when
> e.g. playing movie (player sometimes stops for really long while), and
> is also apparent when using powertop, which tells me I had 20000
> wakeups/s (yes, twenty thousand) per second, although sum of wakeups
> from the topmost wakeup causes does not reach 2000. Sometimes, however,
> this number goes down to reasonable values, but only for a while.
> 
>   I spent some time experimenting with linux kernel parameters; first
> with clocksource, where with all possible sources (but jiffies, which
> seemed to work) were having the same problem. With nohz=off parameter
> the computer was stable (but it did not enter power saving states), and
> after trying processor.max_cstate=1, computer was stable as well (any
> higher state causes instability) and powertop was returning meaningful
> values.
> 
>   Any attempts I made failed, so I'll welcome any suggestion, I have
> never seen something like this before.
> 
>   Best regards,
> 	Milan Plzik
> 
> 
> [1] My configuration follows:
> 
> # uname -a
> Linux tiny 2.6.26-gentoo #18 SMP Tue Aug 12 12:40:57 CEST 2008 x86_64 Intel(R) Core(TM)2 CPU U7600 @ 1.20GHz GenuineIntel GNU/Linux
> 
> # grep -e HZ -e HPET -e RTC -e IDLE -e CPUFREQ /usr/src/linux/.config |grep -v "not set"
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_NO_HZ=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> CONFIG_X86_ACPI_CPUFREQ=y
> CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # RTC interfaces
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> CONFIG_RTC_INTF_DEV_UIE_EMUL=y
> # I2C RTC drivers
> # SPI RTC drivers
> # Platform RTC drivers
> CONFIG_RTC_DRV_CMOS=y
> # on-CPU RTC drivers
> 
> # cat /proc/cpuinfo
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 CPU         U7600  @ 1.20GHz
> stepping	: 2
> cpu MHz		: 800.000
> cache size	: 2048 KB
> physical id	: 0
> siblings	: 2
> core id		: 0
> cpu cores	: 2
> apicid		: 0
> initial apicid	: 0
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est
> tm2 ssse3 cx16 xtpr lahf_lm
> bogomips	: 2402.19
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> processor	: 1
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 CPU         U7600  @ 1.20GHz
> stepping	: 2
> cpu MHz		: 800.000
> cache size	: 2048 KB
> physical id	: 0
> siblings	: 2
> core id		: 1
> cpu cores	: 2
> apicid		: 1
> initial apicid	: 1
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est
> tm2 ssse3 cx16 xtpr lahf_lm
> bogomips	: 2400.00
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> # lspci
> 00:00.0 Host bridge: ATI Technologies Inc Device 7930
> 00:01.0 PCI bridge: ATI Technologies Inc Device 7932
> 00:04.0 PCI bridge: ATI Technologies Inc Device 7934
> 00:06.0 PCI bridge: ATI Technologies Inc Device 7936
> 00:07.0 PCI bridge: ATI Technologies Inc Device 7937
> 00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
> 00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
> 00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
> 00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
> 00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
> 00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
> 00:14.0 SMBus: ATI Technologies Inc SB600 SMBus (rev 14)
> 00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
> 00:14.2 Audio device: ATI Technologies Inc SB600 Azalia
> 00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
> 00:14.4 PCI bridge: ATI Technologies Inc SB600 PCI to PCI Bridge
> 01:05.0 VGA compatible controller: ATI Technologies Inc Device 7942
> 03:01.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
> 03:01.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant
> IEEE 1394 Host Controller
> 03:01.3 SD Host controller: Texas Instruments PCIxx12 SDA Standard
> Compliant SD Host Controller
> 09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5756ME
> Gigabit Ethernet PCI Express
> 0b:00.0 Network controller: Broadcom Corporation BCM4310 USB Controller
> (rev 01)
> 

