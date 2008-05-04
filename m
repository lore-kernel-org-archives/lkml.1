Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYEDRqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYEDRqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 13:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYEDRqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 13:46:45 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:4937 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYEDRqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 13:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=dUlOd1L4UjgKnGCK9TD4iUdXC7QIfjjXwaeG5DKo5iduUp/X/RMsiSn5edvPIqIjhgXlP9oZzXJnnZk5ub1YXhrh/K27TYOh1YEL05Jaobq8vNmT37jbvKSMvWkDnUa1qcJeWRCKqSGW5kjoS51LEllUveOQwIddN0RfssV5APQ=
Message-ID: <481DF570.8050700@gmail.com>
Date: Sun, 04 May 2008 19:42:08 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Suspend to memory is freezing my machine
References: <fa.4esVkXHbwOL+Pzatd+lYSGawfns@ifi.uio.no> <fa.zsdi5UBi6URzBaRSfFXIc6F7kHk@ifi.uio.no> <fa.plXIUcQIe19WMbpH4aKYo6JX1RQ@ifi.uio.no> <481DF438.30307@shaw.ca>
In-Reply-To: <481DF438.30307@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock pisze:
> Jacek Luczak wrote:
>> Rafael J. Wysocki pisze:
>>> On Sunday, 4 of May 2008, Zdenek Kabelac wrote:
>>>> Hello
>>> Hi,
>>>
>>>> With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get occasionally
>>>> complete freeze of my T61 during suspend. (dual core, 2GB).
>>> How reproducible is this?
>>>
>>>> I'm running kernel with no_console_suspend - but all I can see is
>>>> blinking cursor on an empty screen - thus even when I run kernel with
>>>> most debug options turned on, I can't pass more details so far.  I run
>>>> suspend with with SD card in - so maybe some update in the MMC driver
>>>> might be responsible for this ?
>>>>
>>>> Also - I think that option no_console_suspend doens't work correctly -
>>>> as many times with suspend I do not see any log message on my console
>>>> screen. However sometimes the log is shown.
>>> It would be helpful if you could verify if:
>>>
>>> (1) The problem occurs without no_console_suspend.
>>> (2) The problem occurs without the SD card.
>>>
>>
>> Hi Rafael,
>>
>> same problem here, although I was able to resume system (it's
>> basically Intel
>> machine) , but it was unusable - I was able to switch between
>> terminals and see
>> output from kernel. So there was:
>>     - Disabling irq #19;
>>     - some kind of lock spinning on disk:
>> IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA
>> Storage
>> Controller IDE (rev 02)
>>     but I can't provide more output of that lock now - no sign in logs.
>>
>> I've made some successful suspend/resume all without sound card active
>> without
>> problem. Those appear with sound card active, but I must take closer
>> look - will
>> send info later.
> 
> Can you post your dmesg and /proc/interrupts output from normal bootup ?

Sure I can ;)

1) /proc/interrupts

           CPU0       CPU1
  0:   11846981          0   IO-APIC-edge      timer
  1:      30098          0   IO-APIC-edge      i8042
  8:          3          0   IO-APIC-edge      rtc
  9:         13          0   IO-APIC-fasteoi   acpi
 12:    1776540          0   IO-APIC-edge      i8042
 14:         39          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:      54570      44642   IO-APIC-fasteoi   i915@pci:0000:00:02.0
 17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:      98243          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb5
 21:    1650574          0   IO-APIC-fasteoi   HDA Intel
 23:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
220:      14263          0   PCI-MSI-edge      iwl3945
221:    1166041    1333296   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:    1104887    7534969   Local timer interrupts
RES:     633378     701351   Rescheduling interrupts
CAL:         16      28315   function call interrupts
TLB:       1721       2620   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0

2) dmesg can here -> http://212.109.128.251/~difrost/linux-next/dmesg.log
3) Kernel:
Linux difrost 2.6.25-07422-gb66e1f1-dirty #14 SMP Fri May 2 22:04:17 CEST 2008
i686 i686 i386 GNU/Linux
It's marked dirty because due to http://lkml.org/lkml/2008/5/2/405 patch applied.

-Jacek
