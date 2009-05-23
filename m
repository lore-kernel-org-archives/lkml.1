Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbZEWK1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbZEWK1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 06:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZEWK1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 06:27:38 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:45399 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbZEWK1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 06:27:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZqI30MbtLXRsQiL0GlTtl1CddSmEMSdF7kpt7yseidjij5hRz3xZ9EKKi1lATEpUEx
         6vIDADeSDfVDkfBAJzeYMbZGGL/rPpobIiTOh06JyuhijJOPfYRbiiduSyLPUoULIqjF
         OLKxVIrkFLmdN0geNJugk5SjQioyJbNrD094E=
Message-ID: <4A17CF66.7070408@gmail.com>
Date: Sat, 23 May 2009 12:26:46 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1pre) Gecko/20090521 Shredder/3.0b3pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume (output with debug
 patch)
References: <ckpL0-3TE-3@gated-at.bofh.it> <ckpL0-3TE-5@gated-at.bofh.it> <ckpL0-3TE-7@gated-at.bofh.it> <ckpL0-3TE-9@gated-at.bofh.it> <ckpL0-3TE-11@gated-at.bofh.it> <ckpL0-3TE-1@gated-at.bofh.it> <cllvN-2Gf-1@gated-at.bofh.it> <49D0D788.6070405@gmail.com> <49D419E8.2080603@kernel.org> <49D4591B.3070807@gmail.com> <49D46096.1040701@kernel.org> <49D49B8A.7070408@gmail.com> <49D4C886.1010101@gmail.com> <49D6E7FA.3000306@kernel.org> <49D98C9E.2000507@gmail.com> <49D9D4D8.2020608@kernel.org> <49DA489E.1030801@gmail.com> <49DA5A83.2070002@kernel.org> <49DA7392.4020809@gmail.com> <49DE3BE3.80806@kernel.org> <4A17BF44.2030703@gmail.com>
In-Reply-To: <4A17BF44.2030703@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2009 11:17 AM, Niel Lambrechts wrote:
> On 04/09/2009 08:18 PM, Tejun Heo wrote:
>> Hmm... none of the debugging messages got triggered, so there should
>> be no noticeable timing change.  It seems like you're being lucky for
>> the time being.  Can you please keep testing and report back?
>
> Hi Tejun,
>
> Just to keep you up informed - this issue is still happening, I've 
> been testing the latest 2.6.30-git kernels the last couple of weeks 
> and just checked my logs after having an unexpected fsck upon system 
> boot - the freeze seems to trigger very infrequently though, since I 
> use s2disk at least twice a day and the error only seems to have 
> happened twice since May 2.
>
> I had a look at your 2.6.29 debug patch, it does "Hunk #6 succeeded at 
> 3368" so it should still be good (I hope), I'll try and run with it 
> for a while.

Hi Tejun

Bug triggered with your patch! I played audio while suspending to try 
and increase activity  (I also removed a CD on boot), and the filesystem 
came up dirty! This was on attempt nr. 3 or 4.

Here is the /var/log/messages output - i hope this is sufficient to 
trace down the cause:
May 23 12:15:08 linux-7vph kernel: PM: Shrinking memory...  done (98443 
pages freed)
May 23 12:15:07 linux-7vph pulseaudio[3781]: alsa-util.c:   period_time  
: 185759
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   tstamp_mode  
: ENABLE
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   period_step  : 1
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   avail_min    
: 15503
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   period_event : 0
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   
start_threshold  : -1
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   
stop_threshold   : 1073741824
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   
silence_threshold: 0
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   silence_size : 0
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   boundary     
: 1073741824
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c: Slave: 
Hardware PCM card 0 'HDA Intel' device 0 subdevice 0
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c: Its setup is:
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   stream       
: PLAYBACK
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   access       
: MMAP_INTERLEAVED
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   format       
: S16_LE
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   subformat    
: STD
May 23 12:15:08 linux-7vph kernel: PM: Freed 393772 kbytes in 3.23 
seconds (121.91 MB/s)
May 23 12:15:09 linux-7vph kernel: Suspending console(s) (use 
no_console_suspend to debug)
May 23 12:15:09 linux-7vph kernel: sd 0:0:0:0: [sda] Synchronizing SCSI 
cache
May 23 12:15:09 linux-7vph kernel: ACPI handle has no context!
May 23 12:15:09 linux-7vph kernel: ata1: exception Emask 0x0 SAct 0x0 
SErr 0x0 action 0x0
May 23 12:15:09 linux-7vph kernel: ata2: exception Emask 0x0 SAct 0x0 
SErr 0x0 action 0x0
May 23 12:15:09 linux-7vph kernel: ehci_hcd 0000:00:1d.7: PCI INT D disabled
May 23 12:15:09 linux-7vph kernel: ehci_hcd 0000:00:1d.7: PME# disabled
May 23 12:15:09 linux-7vph kernel: uhci_hcd 0000:00:1d.2: PCI INT C disabled
May 23 12:15:09 linux-7vph kernel: uhci_hcd 0000:00:1d.1: PCI INT B disabled
May 23 12:15:09 linux-7vph kernel: uhci_hcd 0000:00:1d.0: PCI INT A disabled
May 23 12:15:09 linux-7vph kernel: HDA Intel 0000:00:1b.0: PCI INT B 
disabled
May 23 12:15:10 linux-7vph kernel: ehci_hcd 0000:00:1a.7: PCI INT D disabled
May 23 12:15:10 linux-7vph kernel: ehci_hcd 0000:00:1a.7: PME# disabled
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1a.2: PCI INT C disabled
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1a.1: PCI INT B disabled
May 23 12:15:08 linux-7vph pulseaudio[3781]: alsa-util.c:   channels     : 2
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   rate         
: 44100
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   exact rate   
: 44100 (44100/1)
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1a.0: PCI INT A disabled
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   msbits       
: 16
May 23 12:15:10 linux-7vph kernel: e1000e 0000:00:19.0: PCI INT A disabled
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   buffer_size  
: 16384
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   period_size  
: 8192
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   period_time  
: 185759
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   tstamp_mode  
: ENABLE
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   period_step  : 1
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   avail_min    
: 15503
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   period_event : 0
May 23 12:15:10 linux-7vph kernel: e1000e 0000:00:19.0: PME# enabled
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   
start_threshold  : -1
May 23 12:15:10 linux-7vph kernel: e1000e 0000:00:19.0: wake-up 
capability enabled by ACPI
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   
stop_threshold   : 1073741824
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   
silence_threshold: 0
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   silence_size : 0
May 23 12:15:10 linux-7vph kernel: ACPI: Preparing to enter system sleep 
state S4
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-util.c:   boundary     
: 1073741824
May 23 12:15:10 linux-7vph kernel: PM: Saving platform NVS memory
May 23 12:15:10 linux-7vph kernel: Disabling non-boot CPUs ...
May 23 12:15:10 linux-7vph kernel: CPU 1 is now offline
May 23 12:15:10 linux-7vph kernel: SMP alternatives: switching to UP code
May 23 12:15:10 linux-7vph pulseaudio[3781]: alsa-sink.c: Increasing 
wakeup watermark to 40.00 ms
May 23 12:15:10 linux-7vph kernel: CPU0 attaching NULL sched-domain.
May 23 12:15:10 linux-7vph kernel: CPU1 attaching NULL sched-domain.
May 23 12:15:10 linux-7vph kernel: CPU0 attaching NULL sched-domain.
May 23 12:15:10 linux-7vph kernel: CPU1 is down
May 23 12:15:10 linux-7vph kernel: Extended CMOS year: 2000
May 23 12:15:10 linux-7vph kernel: PM: Creating hibernation image:
May 23 12:15:10 linux-7vph kernel: PM: Need to copy 124750 pages
May 23 12:15:10 linux-7vph kernel: x86 PAT enabled: cpu 0, old 
0x7040600070406, new 0x7010600070106
May 23 12:15:10 linux-7vph kernel: Intel machine check architecture 
supported.
May 23 12:15:10 linux-7vph kernel: Intel machine check reporting enabled 
on CPU#0.
May 23 12:15:10 linux-7vph kernel: PM: Restoring platform NVS memory
May 23 12:15:10 linux-7vph kernel: Extended CMOS year: 2000
May 23 12:15:10 linux-7vph kernel: Enabling non-boot CPUs ...
May 23 12:15:10 linux-7vph kernel: SMP alternatives: switching to SMP code
May 23 12:15:10 linux-7vph kernel: Booting processor 1 APIC 0x1 ip 0x6000
May 23 12:15:10 linux-7vph kernel: Initializing CPU#1
May 23 12:15:10 linux-7vph kernel: Calibrating delay using timer 
specific routine.. 5054.05 BogoMIPS (lpj=10108117)
May 23 12:15:10 linux-7vph kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
May 23 12:15:10 linux-7vph kernel: CPU: L2 cache: 6144K
May 23 12:15:10 linux-7vph kernel: CPU: Physical Processor ID: 0
May 23 12:15:10 linux-7vph kernel: CPU: Processor Core ID: 1
May 23 12:15:10 linux-7vph kernel: Intel machine check architecture 
supported.
May 23 12:15:10 linux-7vph kernel: Intel machine check reporting enabled 
on CPU#1.
May 23 12:15:10 linux-7vph kernel: x86 PAT enabled: cpu 1, old 
0x7040600070406, new 0x7010600070106
May 23 12:15:10 linux-7vph kernel: CPU1: Intel(R) Core(TM)2 Duo CPU     
T9400  @ 2.53GHz stepping 06
May 23 12:15:10 linux-7vph kernel: CPU0 attaching NULL sched-domain.
May 23 12:15:10 linux-7vph kernel: Switched to high resolution mode on CPU 1
May 23 12:15:10 linux-7vph kernel: CPU0 attaching sched-domain:
May 23 12:15:10 linux-7vph kernel:  domain 0: span 0-1 level MC
May 23 12:15:10 linux-7vph kernel:   groups: 0 1
May 23 12:15:10 linux-7vph kernel:   domain 1: span 0-1 level CPU
May 23 12:15:10 linux-7vph kernel:    groups: 0-1 (__cpu_power = 2048)
May 23 12:15:10 linux-7vph kernel: CPU1 attaching sched-domain:
May 23 12:15:10 linux-7vph kernel:  domain 0: span 0-1 level MC
May 23 12:15:10 linux-7vph kernel:   groups: 1 0
May 23 12:15:10 linux-7vph kernel:   domain 1: span 0-1 level CPU
May 23 12:15:10 linux-7vph kernel:    groups: 0-1 (__cpu_power = 2048)
May 23 12:15:10 linux-7vph kernel: microcode: failed to init CPU1
May 23 12:15:10 linux-7vph kernel: CPU1 is up
May 23 12:15:10 linux-7vph kernel: ACPI: Waking up from system sleep 
state S4
May 23 12:15:10 linux-7vph kernel: pci 0000:00:02.0: restoring config 
space at offset 0x1 (was 0x900007, writing 0x900403)
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1a.0: power state 
changed by ACPI to D0
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1a.2: power state 
changed by ACPI to D0
May 23 12:15:10 linux-7vph kernel: HDA Intel 0000:00:1b.0: restoring 
config space at offset 0x1 (was 0x100106, writing 0x100102)
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1d.0: power state 
changed by ACPI to D0
May 23 12:15:10 linux-7vph kernel: ahci 0000:00:1f.2: restoring config 
space at offset 0x1 (was 0x2b00403, writing 0x2b00407)
May 23 12:15:10 linux-7vph kernel: iwlagn 0000:03:00.0: restoring config 
space at offset 0x1 (was 0x100106, writing 0x100506)
May 23 12:15:10 linux-7vph kernel: pci 0000:00:02.0: PME# disabled
May 23 12:15:10 linux-7vph kernel: pci 0000:00:02.0: setting latency 
timer to 64
May 23 12:15:10 linux-7vph kernel: pci 0000:00:02.1: PME# disabled
May 23 12:15:10 linux-7vph kernel: pci 0000:00:03.0: PME# disabled
May 23 12:15:10 linux-7vph kernel: e1000e 0000:00:19.0: PCI INT A -> GSI 
20 (level, low) -> IRQ 20
May 23 12:15:10 linux-7vph kernel: e1000e 0000:00:19.0: 
pci_enable_pcie_error_reporting failed 0xfffffffb
May 23 12:15:10 linux-7vph kernel: e1000e 0000:00:19.0: setting latency 
timer to 64
May 23 12:15:10 linux-7vph kernel: e1000e 0000:00:19.0: wake-up 
capability disabled by ACPI
May 23 12:15:10 linux-7vph kernel: e1000e 0000:00:19.0: PME# disabled
May 23 12:15:10 linux-7vph kernel: e1000e 0000:00:19.0: wake-up 
capability disabled by ACPI
May 23 12:15:10 linux-7vph kernel: e1000e 0000:00:19.0: PME# disabled
May 23 12:15:10 linux-7vph kernel: e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1a.0: PCI INT A -> 
GSI 20 (level, low) -> IRQ 20
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1a.0: setting 
latency timer to 64
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1a.1: PCI INT B -> 
GSI 21 (level, low) -> IRQ 21
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1a.1: setting 
latency timer to 64
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1a.2: PCI INT C -> 
GSI 22 (level, low) -> IRQ 22
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1a.2: setting 
latency timer to 64
May 23 12:15:10 linux-7vph kernel: ehci_hcd 0000:00:1a.7: PME# disabled
May 23 12:15:10 linux-7vph kernel: ehci_hcd 0000:00:1a.7: PCI INT D -> 
GSI 23 (level, low) -> IRQ 23
May 23 12:15:10 linux-7vph kernel: ehci_hcd 0000:00:1a.7: setting 
latency timer to 64
May 23 12:15:10 linux-7vph kernel: ehci_hcd 0000:00:1a.7: PME# disabled
May 23 12:15:10 linux-7vph kernel: HDA Intel 0000:00:1b.0: PCI INT B -> 
GSI 17 (level, low) -> IRQ 17
May 23 12:15:10 linux-7vph kernel: HDA Intel 0000:00:1b.0: setting 
latency timer to 64
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1d.0: PCI INT A -> 
GSI 16 (level, low) -> IRQ 16
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1d.0: setting 
latency timer to 64
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1d.1: PCI INT B -> 
GSI 17 (level, low) -> IRQ 17
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1d.1: setting 
latency timer to 64
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1d.2: PCI INT C -> 
GSI 18 (level, low) -> IRQ 18
May 23 12:15:10 linux-7vph kernel: uhci_hcd 0000:00:1d.2: setting 
latency timer to 64
May 23 12:15:10 linux-7vph kernel: ehci_hcd 0000:00:1d.7: PME# disabled
May 23 12:15:10 linux-7vph kernel: ehci_hcd 0000:00:1d.7: PCI INT D -> 
GSI 19 (level, low) -> IRQ 19
May 23 12:15:10 linux-7vph kernel: ehci_hcd 0000:00:1d.7: setting 
latency timer to 64
May 23 12:15:10 linux-7vph kernel: ehci_hcd 0000:00:1d.7: PME# disabled
May 23 12:15:10 linux-7vph kernel: pci 0000:00:1e.0: setting latency 
timer to 64
May 23 12:15:10 linux-7vph kernel: ahci 0000:00:1f.2: setting latency 
timer to 64
May 23 12:15:10 linux-7vph kernel: ata1: exception Emask 0x0 SAct 0x0 
SErr 0x0 action 0x16 frozen
May 23 12:15:10 linux-7vph kernel: ata2: exception Emask 0x0 SAct 0x0 
SErr 0x0 action 0x16 frozen
May 23 12:15:10 linux-7vph kernel: pci 0000:15:00.0: PCI INT A -> GSI 16 
(level, low) -> IRQ 16
May 23 12:15:10 linux-7vph kernel: ohci1394: fw-host0: OHCI-1394 1.1 
(PCI): IRQ=[17]  MMIO=[f4801000-f48017ff]  Max Packet=[2048]  IR/IT 
contexts=[4/4]
May 23 12:15:10 linux-7vph kernel: pci 0000:15:00.2: PME# disabled
May 23 12:15:10 linux-7vph kernel: pci 0000:15:00.3: PME# disabled
May 23 12:15:10 linux-7vph kernel: pci 0000:15:00.4: PME# disabled
May 23 12:15:10 linux-7vph kernel: pci 0000:15:00.5: PME# disabled
May 23 12:15:10 linux-7vph kernel: sd 0:0:0:0: [sda] Starting disk
May 23 12:15:10 linux-7vph kernel: ata1: SATA link up 1.5 Gbps (SStatus 
113 SControl 300)
May 23 12:15:10 linux-7vph kernel: ata2: SATA link up 1.5 Gbps (SStatus 
113 SControl 300)
May 23 12:15:10 linux-7vph kernel: ata1.00: ACPI cmd 
ef/02:00:00:00:00:a0 succeeded
May 23 12:15:10 linux-7vph kernel: ata1.00: ACPI cmd 
f5/00:00:00:00:00:a0 filtered out
May 23 12:15:10 linux-7vph kernel: ata1.00: ACPI cmd 
ef/5f:00:00:00:00:a0 succeeded
May 23 12:15:10 linux-7vph kernel: ata1.00: ACPI cmd 
ef/10:03:00:00:00:a0 filtered out
May 23 12:15:10 linux-7vph kernel: ata1.00: ACPI cmd 
ef/02:00:00:00:00:a0 succeeded
May 23 12:15:10 linux-7vph kernel: ata1.00: ACPI cmd 
f5/00:00:00:00:00:a0 filtered out
May 23 12:15:10 linux-7vph kernel: ata2.00: ACPI cmd 
e3/00:1f:00:00:00:a0 succeeded
May 23 12:15:10 linux-7vph kernel: ata1.00: ACPI cmd 
ef/5f:00:00:00:00:a0 succeeded
May 23 12:15:10 linux-7vph kernel: ata1.00: ACPI cmd 
ef/10:03:00:00:00:a0 filtered out
May 23 12:15:10 linux-7vph kernel: ata2.00: ACPI cmd 
e3/00:02:00:00:00:a0 succeeded
May 23 12:15:10 linux-7vph kernel: ata1.00: configured for UDMA/133
May 23 12:15:10 linux-7vph kernel: ata1: exception Emask 0x10 SAct 0x0 
SErr 0x0 action 0x9 t4
May 23 12:15:10 linux-7vph kernel: ata1: irq_stat 0x00400040, connection 
status changed
May 23 12:15:10 linux-7vph kernel: ata1.00: configured for UDMA/133
May 23 12:15:10 linux-7vph kernel: ata1: EH complete
May 23 12:15:10 linux-7vph kernel: ata2.00: ACPI cmd 
e3/00:1f:00:00:00:a0 succeeded
May 23 12:15:10 linux-7vph kernel: ata2.00: ACPI cmd 
e3/00:02:00:00:00:a0 succeeded
May 23 12:15:10 linux-7vph kernel: ata2.00: configured for UDMA/133
May 23 12:15:10 linux-7vph kernel: ata2: exception Emask 0x10 SAct 0x0 
SErr 0x0 action 0x9 t4
May 23 12:15:10 linux-7vph kernel: ata2: irq_stat 0x40000001
May 23 12:15:10 linux-7vph kernel: ata2.00: configured for UDMA/133
May 23 12:15:10 linux-7vph kernel: ata2: EH complete
May 23 12:15:10 linux-7vph kernel: Registered led device: iwl-phy0::radio
May 23 12:15:10 linux-7vph kernel: Registered led device: iwl-phy0::assoc
May 23 12:15:10 linux-7vph kernel: Registered led device: iwl-phy0::RX
May 23 12:15:10 linux-7vph kernel: Registered led device: iwl-phy0::TX
May 23 12:15:10 linux-7vph kernel: mac80211-phy0: failed to set key (0, 
00:1d:92:1d:1e:8e) to hardware (-22)
May 23 12:15:10 linux-7vph kernel: pci 0000:00:02.0: restoring config 
space at offset 0x1 (was 0x900407, writing 0x900403)
May 23 12:15:10 linux-7vph kernel: pci 0000:00:02.0: setting latency 
timer to 64
May 23 12:15:10 linux-7vph kernel: Restarting tasks ... <3>ata1.00: 
exception Emask 0x10 SAct 0x1f SErr 0x50000 action 0xe frozen
May 23 12:15:10 linux-7vph kernel: ata1.00: irq_stat 0x00400008, PHY RDY 
changed
May 23 12:15:10 linux-7vph kernel: ata1: SError: { PHYRdyChg CommWake }
May 23 12:15:10 linux-7vph kernel: ata1.00: cmd 
60/08:00:5f:89:67/01:00:0e:00:00/40 tag 0 ncq 135168 in
May 23 12:15:10 linux-7vph kernel:          res 
50/00:08:5f:08:c8/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
May 23 12:15:10 linux-7vph kernel: ata1.00: status: { DRDY }
May 23 12:15:10 linux-7vph kernel: ata1.00: cmd 
60/08:08:6f:88:6f/01:00:0e:00:00/40 tag 1 ncq 135168 in
May 23 12:15:10 linux-7vph kernel:          res 
50/00:08:5f:08:c8/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
May 23 12:15:10 linux-7vph kernel: ata1.00: status: { DRDY }
May 23 12:15:10 linux-7vph kernel: ata1.00: cmd 
60/08:10:5f:08:c8/00:00:0c:00:00/40 tag 2 ncq 4096 in
May 23 12:15:10 linux-7vph kernel:          res 
50/00:08:5f:08:c8/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
May 23 12:15:10 linux-7vph kernel: ata1.00: status: { DRDY }
May 23 12:15:10 linux-7vph kernel: ata1.00: cmd 
60/08:18:9f:98:6d/00:00:0e:00:00/40 tag 3 ncq 4096 in
May 23 12:15:10 linux-7vph kernel:          res 
50/00:08:5f:08:c8/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
May 23 12:15:11 linux-7vph kernel: ata1.00: status: { DRDY }
May 23 12:15:11 linux-7vph kernel: ata1.00: cmd 
60/e8:20:5f:8e:2b/00:00:0b:00:00/40 tag 4 ncq 118784 in
May 23 12:15:11 linux-7vph kernel:          res 
50/00:08:5f:08:c8/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
May 23 12:15:11 linux-7vph kernel: ata1.00: status: { DRDY }
May 23 12:15:11 linux-7vph kernel: ata1: hard resetting link
May 23 12:15:11 linux-7vph kernel: done.
May 23 12:15:11 linux-7vph kernel: ata1: SATA link up 1.5 Gbps (SStatus 
113 SControl 300)
May 23 12:15:11 linux-7vph kernel: ata1.00: ACPI cmd 
ef/02:00:00:00:00:a0 succeeded
May 23 12:15:11 linux-7vph kernel: ata1.00: ACPI cmd 
f5/00:00:00:00:00:a0 filtered out
May 23 12:15:11 linux-7vph kernel: ata1.00: ACPI cmd 
ef/5f:00:00:00:00:a0 succeeded
May 23 12:15:11 linux-7vph kernel: ata1.00: ACPI cmd 
ef/10:03:00:00:00:a0 filtered out
May 23 12:15:11 linux-7vph kernel: ata1.00: ACPI cmd 
ef/02:00:00:00:00:a0 succeeded
May 23 12:15:11 linux-7vph kernel: ata1.00: ACPI cmd 
f5/00:00:00:00:00:a0 filtered out
May 23 12:15:11 linux-7vph kernel: ata1.00: ACPI cmd 
ef/5f:00:00:00:00:a0 succeeded
May 23 12:15:11 linux-7vph kernel: ata1.00: ACPI cmd 
ef/10:03:00:00:00:a0 filtered out
May 23 12:15:11 linux-7vph kernel: ata1.00: configured for UDMA/133
May 23 12:15:11 linux-7vph kernel: ata1: exception Emask 0x0 SAct 0x0 
SErr 0x0 action 0x0 t4
May 23 12:15:11 linux-7vph kernel: ata1.00: configured for UDMA/133
May 23 12:15:11 linux-7vph kernel: XXX scsi_eh_flush_done_q: online=1(2) 
noretry=2 retries=0 allowed=5
May 23 12:15:11 linux-7vph kernel: scsi_eh_0: flush finish cmd: f6838ec0
May 23 12:15:11 linux-7vph kernel: sd 0:0:0:0: [sda] Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
May 23 12:15:11 linux-7vph kernel: sd 0:0:0:0: [sda] Sense Key : Aborted 
Command [current] [descriptor]
May 23 12:15:11 linux-7vph kernel: Descriptor sense data with sense 
descriptors (in hex):
May 23 12:15:11 linux-7vph kernel:         72 0b 00 00 00 00 00 0c 00 0a 
80 00 00 00 00 00
May 23 12:15:11 linux-7vph kernel:         0c c8 08 5f
May 23 12:15:11 linux-7vph kernel: sd 0:0:0:0: [sda] Add. Sense: No 
additional sense information
May 23 12:15:11 linux-7vph kernel: end_request: I/O error, dev sda, 
sector 241666399
May 23 12:15:11 linux-7vph kernel: XXX scsi_eh_flush_done_q: online=1(2) 
noretry=2 retries=0 allowed=5
May 23 12:15:11 linux-7vph kernel: scsi_eh_0: flush finish cmd: f6838680
May 23 12:15:11 linux-7vph kernel: sd 0:0:0:0: [sda] Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
May 23 12:15:11 linux-7vph kernel: sd 0:0:0:0: [sda] Sense Key : Aborted 
Command <2>EXT4-fs error (device sda6): __ext4_get_inode_loc: unable to 
read inode block - inode=2330983, block=9338933
May 23 12:15:11 linux-7vph kernel: [current] [descriptor]
May 23 12:15:11 linux-7vph kernel: Descriptor sense data with sense 
descriptors (in hex):
May 23 12:15:11 linux-7vph kernel:         72 0b 00 00 00 00 00 0c 00 0a 
80 00 00 00 00 00
May 23 12:15:11 linux-7vph kernel:         0c c8 08 5f
May 23 12:15:11 linux-7vph kernel: sd 0:0:0:0: [sda] Add. Sense: No 
additional sense information
May 23 12:15:11 linux-7vph kernel: end_request: I/O error, dev sda, 
sector 242190447
May 23 12:15:11 linux-7vph kernel: EXT4-fs error (device sda6): 
__ext4_get_inode_loc: XXX scsi_eh_flush_done_q: online=1(2) noretry=0 
retries=0 allowed=5
May 23 12:15:11 linux-7vph kernel: unable to read inode block - 
inode=2346524, block=9404418
May 23 12:15:11 linux-7vph kernel: scsi_eh_0: flush retry cmd: f6838800
May 23 12:15:11 linux-7vph kernel: XXX scsi_eh_flush_done_q: online=1(2) 
noretry=0 retries=0 allowed=5
May 23 12:15:11 linux-7vph kernel: scsi_eh_0: flush retry cmd: f403de00
May 23 12:15:11 linux-7vph kernel: XXX scsi_eh_flush_done_q: online=1(2) 
noretry=2 retries=0 allowed=5
May 23 12:15:11 linux-7vph kernel: scsi_eh_0: flush finish cmd: f403d200
May 23 12:15:11 linux-7vph kernel: sd 0:0:0:0: [sda] Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
May 23 12:15:11 linux-7vph kernel: sd 0:0:0:0: [sda] Sense Key : Aborted 
Command [current] [descriptor]
May 23 12:15:11 linux-7vph kernel: Descriptor sense data with sense 
descriptors (in hex):
May 23 12:15:11 linux-7vph kernel:         72 0b 00 00 00 00 00 0c 00 0a 
80 00 00 00 00 00
May 23 12:15:11 linux-7vph kernel:         0c c8 08 5f
May 23 12:15:11 linux-7vph kernel: sd 0:0:0:0: [sda] Add. Sense: No 
additional sense information
May 23 12:15:11 linux-7vph kernel: end_request: I/O error, dev sda, 
sector 187403871
May 23 12:15:11 linux-7vph kernel: ata1: EH complete
May 23 12:15:11 linux-7vph kernel: EXT4-fs error (device sda6): 
__ext4_get_inode_loc: unable to read inode block - inode=641187, 
block=2556122
May 23 12:15:11 linux-7vph kernel: EXT4-fs error (device sda6) in 
ext4_reserve_inode_write: IO failure
May 23 12:15:11 linux-7vph kernel: EXT4-fs error (device sda6) in 
ext4_reserve_inode_write: IO failure
May 23 12:15:11 linux-7vph kernel: EXT4-fs error (device sda6) in 
ext4_reserve_inode_write: IO failure
May 23 12:16:50 linux-7vph kernel: ata1: exception Emask 0x0 SAct 0x0 
SErr 0x0 action 0x10
May 23 12:16:50 linux-7vph kernel: CPU0 attaching NULL sched-domain.
May 23 12:16:50 linux-7vph kernel: CPU1 attaching NULL sched-domain.
May 23 12:16:50 linux-7vph kernel: CPU0 attaching sched-domain:
May 23 12:16:50 linux-7vph kernel:  domain 0: span 0-1 level MC
May 23 12:16:50 linux-7vph kernel:   groups: 0 1
May 23 12:16:50 linux-7vph kernel:   domain 1: span 0-1 level CPU
May 23 12:16:50 linux-7vph kernel:    groups: 0-1 (__cpu_power = 2048)
May 23 12:16:50 linux-7vph kernel: CPU1 attaching sched-domain:
May 23 12:16:50 linux-7vph kernel:  domain 0: span 0-1 level MC
May 23 12:16:50 linux-7vph kernel:   groups: 1 0
May 23 12:16:50 linux-7vph kernel:   domain 1: span 0-1 level CPU
May 23 12:16:50 linux-7vph kernel:    groups: 0-1 (__cpu_power = 2048)


Regards,
Niel
