Return-Path: <linux-kernel-owner+w=401wt.eu-S1422969AbXBBAGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422969AbXBBAGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 19:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423012AbXBBAGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 19:06:31 -0500
Received: from vsmtp14.tin.it ([212.216.176.118]:47716 "EHLO vsmtp14.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422969AbXBBAGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 19:06:30 -0500
Message-ID: <45C0FAE300242D46@vsmtp14.tin.it> (added by postmaster@virgilio.it)
From: "Lapo TIN" <lapolapolapo@tin.it>
To: <linux-smp@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: "'Robert Hancock'" <hancockr@shaw.ca>
Subject: Re: smp and irq conflict
Date: Fri, 2 Feb 2007 01:04:53 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
Thread-Index: AcdGWtW4uct+YWZpQIy/bCIU9BU3EgAAf0LA
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <45C277E0.2040604@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I need to capture at 25 frame per second from each channel...
So 25 x 8 total frames per second on the pci.


So do you think I have to change the motherboard ?
What is important ? the chipset ? is there specification I need ?


-----Messaggio originale-----
Da: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] Per conto di Robert Hancock
Inviato: venerdì 2 febbraio 2007 0.30
A: Lapo TIN
Cc: linux-smp@vger.kernel.org; linux-kernel@vger.kernel.org
Oggetto: Re: smp and irq conflict

Lapo TIN wrote:
> Dear all,
> I have a problem with IRQs.
> 
> My pc has a CPU PentiumD945 (dual core) and a 2.6.19smp kernel.
> I have two video acquisition board (four bt8t8 each) in the only two pci
> slots of my motherboard. Thus I have a total of 8 bttv modules that are
> working together, and the /proc/interrupts is as follows:
> # cat /proc/interrupts
>            CPU0       CPU1
>   0:      13575          0   IO-APIC-edge      timer
>   1:          2          0   IO-APIC-edge      i8042
>   4:         11          0   IO-APIC-edge      serial
>   8:          1          0   IO-APIC-edge      rtc
>   9:          0          0   IO-APIC-fasteoi   acpi
>  12:          4          0   IO-APIC-edge      i8042
>  14:      22286          0   IO-APIC-edge      ide0
>  17:       7073       2097   IO-APIC-fasteoi   uhci_hcd:usb5, eth0
>  18:       2525          0   IO-APIC-fasteoi   bttv0, bttv7
>  19:       2829          0   IO-APIC-fasteoi   bttv1, bttv4
>  20:       2526          0   IO-APIC-fasteoi   bttv2, bttv5
>  21:       2226          0   IO-APIC-fasteoi   bttv3, bttv6
>  22:          2          0   IO-APIC-fasteoi   ehci_hcd:usb1,
uhci_hcd:usb4
>  23:         86          0   IO-APIC-fasteoi   uhci_hcd:usb2
>  24:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
> NMI:          0          0
> LOC:      13484      13502
> ERR:          0
> MIS:          0
> You can see that IRQ18 is shared between bttv0 and bttv7, IRQ19 between
> bttv1 and bttv4 and so on.
> 
> Sometimes it crashes. It seems a matter of conflict in IRQ.
> With only one video board everything is ok, but with two, they shared irq
> and something goes wrong... 
> How can I tell to the kernel to not to share the IRQ for these boards ?
> I think (I don't know if I'm right) that this could be the problem.

Usually the IRQ routing is hard-wired on the motherboard, so there's no 
way to avoid the devices sharing IRQs. Unless the driver is badly buggy 
this should not cause problems anyway.

What kind of video bit rate are you capturing? 8 video capture chips is 
a pretty heavy load on the PCI bus, maybe something just gets overwhelmed?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

