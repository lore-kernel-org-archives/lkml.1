Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbYEDTtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbYEDTtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYEDTtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:49:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:36529 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYEDTtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:49:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=P1ttxKjlf9GrkUOnVTdkdhVpr34wXGpGTnm3lfSGeesbqWQz0pE1Arb95S32M/EEJIQXOam+i7K3kIFl1vh+u5K+6EzXT8uZKHoTl1C2/MGb+OgP0eFbzsGzGrQkFoNrdgwE93RAHBq16G0ao0DqnsXVdzw4r9+eLPbCJIwEV48=
Message-ID: <481E1228.4020106@gmail.com>
Date: Sun, 04 May 2008 21:44:40 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: Suspend to memory is freezing my machine
References: <fa.4esVkXHbwOL+Pzatd+lYSGawfns@ifi.uio.no> <fa.zsdi5UBi6URzBaRSfFXIc6F7kHk@ifi.uio.no> <fa.plXIUcQIe19WMbpH4aKYo6JX1RQ@ifi.uio.no> <481DF438.30307@shaw.ca> <481DF570.8050700@gmail.com> <481DF9E1.8050008@shaw.ca> <481E05F7.5010504@gmail.com>
In-Reply-To: <481E05F7.5010504@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacek Luczak pisze:
> Robert Hancock pisze:
>> Jacek Luczak wrote:
>>> Robert Hancock pisze:
>>>> Jacek Luczak wrote:
>>>>> Rafael J. Wysocki pisze:
>>>>>> On Sunday, 4 of May 2008, Zdenek Kabelac wrote:
>>>>>>> Hello
>>>>>> Hi,
>>>>>>
>>>>>>> With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get
>>>>>>> occasionally
>>>>>>> complete freeze of my T61 during suspend. (dual core, 2GB).
>>>>>> How reproducible is this?
>>>>>>
>>>>>>> I'm running kernel with no_console_suspend - but all I can see is
>>>>>>> blinking cursor on an empty screen - thus even when I run kernel with
>>>>>>> most debug options turned on, I can't pass more details so far.  I
>>>>>>> run
>>>>>>> suspend with with SD card in - so maybe some update in the MMC driver
>>>>>>> might be responsible for this ?
>>>>>>>
>>>>>>> Also - I think that option no_console_suspend doens't work
>>>>>>> correctly -
>>>>>>> as many times with suspend I do not see any log message on my console
>>>>>>> screen. However sometimes the log is shown.
>>>>>> It would be helpful if you could verify if:
>>>>>>
>>>>>> (1) The problem occurs without no_console_suspend.
>>>>>> (2) The problem occurs without the SD card.
>>>>>>
>>>>> Hi Rafael,
>>>>>
>>>>> same problem here, although I was able to resume system (it's
>>>>> basically Intel
>>>>> machine) , but it was unusable - I was able to switch between
>>>>> terminals and see
>>>>> output from kernel. So there was:
>>>>>     - Disabling irq #19;
>>>>>     - some kind of lock spinning on disk:
>>>>> IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA
>>>>> Storage
>>>>> Controller IDE (rev 02)
>>>>>     but I can't provide more output of that lock now - no sign in logs.
>>>>>
>>>>> I've made some successful suspend/resume all without sound card active
>>>>> without
>>>>> problem. Those appear with sound card active, but I must take closer
>>>>> look - will
>>>>> send info later.
>>>> Can you post your dmesg and /proc/interrupts output from normal bootup ?
>>> Sure I can ;)
>>>
>>> 1) /proc/interrupts
>>>
>>>            CPU0       CPU1
>>>   0:   11846981          0   IO-APIC-edge      timer
>>>   1:      30098          0   IO-APIC-edge      i8042
>>>   8:          3          0   IO-APIC-edge      rtc
>>>   9:         13          0   IO-APIC-fasteoi   acpi
>>>  12:    1776540          0   IO-APIC-edge      i8042
>>>  14:         39          0   IO-APIC-edge      ata_piix
>>>  15:          0          0   IO-APIC-edge      ata_piix
>>>  16:      54570      44642   IO-APIC-fasteoi   i915@pci:0000:00:02.0
>>>  17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
>>>  18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
>>>  19:      98243          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb5
>>>  21:    1650574          0   IO-APIC-fasteoi   HDA Intel
>>>  23:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1,
>>> uhci_hcd:usb2
>>> 220:      14263          0   PCI-MSI-edge      iwl3945
>>> 221:    1166041    1333296   PCI-MSI-edge      eth0
>>> NMI:          0          0   Non-maskable interrupts
>>> LOC:    1104887    7534969   Local timer interrupts
>>> RES:     633378     701351   Rescheduling interrupts
>>> CAL:         16      28315   function call interrupts
>>> TLB:       1721       2620   TLB shootdowns
>>> TRM:          0          0   Thermal event interrupts
>>> SPU:          0          0   Spurious interrupts
>>> ERR:          0
>>> MIS:          0
>>>
>>> 2) dmesg can here -> http://212.109.128.251/~difrost/linux-next/dmesg.log
>>> 3) Kernel:
>>> Linux difrost 2.6.25-07422-gb66e1f1-dirty #14 SMP Fri May 2 22:04:17
>>> CEST 2008
>>> i686 i686 i386 GNU/Linux
>>> It's marked dirty because due to http://lkml.org/lkml/2008/5/2/405
>>> patch applied.
>>>
>>> -Jacek
>>>
>> Well, if IRQ 19 got disabled, that's your SATA controller, so resume
>> likely isn't going to work. Could be a libata problem? CCing linux-ide.
> 
> Yep, I know, that's why I pointed that out. Irq was disabled somehow in suspend
> or resume process.
> 
>> BTW, if your BIOS offers an option to enable AHCI on your SATA
>> controller then that would be a more optimal configuration (could get
>> NCQ support), but that is an aside.
> 
> With AHCI I've got pretty bad timings (and I don't really know why!):
> 
> [root|20:49|~]$ cat sda_ahci_t
> 
> /dev/sda:
>  Timing cached reads:   1560 MB in  2.00 seconds = 780.51 MB/sec
>  Timing buffered disk reads:  102 MB in  3.02 seconds =  33.74 MB/sec
> [root|20:49|~]$ cat sda_piix_t
> 
> /dev/sda:
>  Timing cached reads:   1544 MB in  2.00 seconds = 772.35 MB/sec
>  Timing buffered disk reads:  134 MB in  3.04 seconds =  44.05 MB/sec

Here's the latest report (all on latest git):
	1) I've switched to AHCI mode and suspend/resume works OK (because SATA
controller irq is not disabled).

	2) now /proc/interrupts look like that:
           CPU0       CPU1
  0:     110708          0   IO-APIC-edge      timer
  1:       4008          0   IO-APIC-edge      i8042
  8:          3          0   IO-APIC-edge      rtc
  9:      15091          0   IO-APIC-fasteoi   acpi
 12:      77467          0   IO-APIC-edge      i8042
 14:         44          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:          0          0   IO-APIC-fasteoi   i915@pci:0000:00:02.0
 17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:     100001          0   IO-APIC-fasteoi   uhci_hcd:usb5
 21:        282          0   IO-APIC-fasteoi   HDA Intel
 23:          1          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
219:        858          0   PCI-MSI-edge      iwl3945
220:       8616          0   PCI-MSI-edge      eth0
221:       6423          0   PCI-MSI-edge      ahci
NMI:          0          0   Non-maskable interrupts
LOC:      15777      64510   Local timer interrupts
RES:       9045      24560   Rescheduling interrupts
CAL:         30      28255   function call interrupts
TLB:        341        145   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0

	3) The IRQ #19 remains disabled after resume and produce:
irq 19: nobody cared (try booting with the "irqpoll" option)
Pid: 13, comm: kacpi_notify Not tainted 2.6.26-rc1-07561-gafa26be-dirty #16
 [<c013ea27>] __report_bad_irq+0x24/0x69
 [<c013ea2e>] __report_bad_irq+0x2b/0x69
 [<c013ec25>] note_interrupt+0x1b9/0x210
 [<c013e36c>] handle_IRQ_event+0x1a/0x3f
 [<c013f195>] handle_fasteoi_irq+0x84/0xa2
 [<c0104fde>] do_IRQ+0x4f/0x65
 [<c01034ff>] common_interrupt+0x23/0x28
 [<c013007b>] timekeeping_resume+0x9b/0x127
 [<c020b090>] acpi_os_read_port+0x29/0x44
 [<c02177c9>] acpi_hw_register_read+0x61/0x119
 [<c020f76e>] acpi_ev_fixed_event_detect+0x2a/0xa0
 [<c021001a>] acpi_ev_sci_xrupt_handler+0x9/0x17
 [<c020b053>] acpi_irq+0xb/0x1f
 [<c013e36c>] handle_IRQ_event+0x1a/0x3f
 [<c013f181>] handle_fasteoi_irq+0x70/0xa2
 [<c0104fde>] do_IRQ+0x4f/0x65
 [<c020b623>] acpi_os_execute_deferred+0x0/0x25
 [<c01034ff>] common_interrupt+0x23/0x28
 [<c020b623>] acpi_os_execute_deferred+0x0/0x25
 [<c020b0b8>] acpi_os_write_port+0xd/0x2c
 [<c020b640>] acpi_os_execute_deferred+0x1d/0x25
 [<c01290fa>] run_workqueue+0x69/0xda
 [<c0129221>] worker_thread+0xb6/0xc2
 [<c012bca6>] autoremove_wake_function+0x0/0x2d
 [<c012916b>] worker_thread+0x0/0xc2
 [<c012ba42>] kthread+0x38/0x5d
 [<c012ba0a>] kthread+0x0/0x5d
 [<c010370f>] kernel_thread_helper+0x7/0x10
 =======================
handlers:
[<c027d100>] (usb_hcd_irq+0x0/0x53)
Disabling IRQ #19

This might happen due to "ACPI: EC: GPE storm detected, disabling EC GPE", but
here it should revert to polling mode (which is done during boot, but not during
resume). I'm not expert here.

Full dmesg here -> http://212.109.128.251/~difrost/linux-next/dmesg_ahci.log

-Jacek

PS: Site note: Why there's such big difference on hdparm timings with PATA and
AHCI mode?
