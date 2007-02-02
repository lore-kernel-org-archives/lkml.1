Return-Path: <linux-kernel-owner+w=401wt.eu-S1423099AbXBBF0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423099AbXBBF0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 00:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423104AbXBBF0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 00:26:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:59319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423099AbXBBF0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 00:26:16 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: smp and irq conflict
Date: Fri, 2 Feb 2007 00:22:58 -0500
User-Agent: KMail/1.9.5
Cc: "Lapo TIN" <lapolapolapo@tin.it>, linux-smp@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <45BE4003005C2845@vsmtp2.tin.it> <20070201203246.ece495f0.akpm@linux-foundation.org>
In-Reply-To: <20070201203246.ece495f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702020022.58843.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 23:32, Andrew Morton wrote:
> On Thu, 1 Feb 2007 18:46:00 +0100 "Lapo TIN" <lapolapolapo@tin.it> wrote:
> 
> > Dear all,
> > I have a problem with IRQs.
> > 
> > My pc has a CPU PentiumD945 (dual core) and a 2.6.19smp kernel.
> > I have two video acquisition board (four bt8t8 each) in the only two pci
> > slots of my motherboard. Thus I have a total of 8 bttv modules that are
> > working together, and the /proc/interrupts is as follows:
> > # cat /proc/interrupts
> >            CPU0       CPU1
> >   0:      13575          0   IO-APIC-edge      timer
> >   1:          2          0   IO-APIC-edge      i8042
> >   4:         11          0   IO-APIC-edge      serial
> >   8:          1          0   IO-APIC-edge      rtc
> >   9:          0          0   IO-APIC-fasteoi   acpi
> >  12:          4          0   IO-APIC-edge      i8042
> >  14:      22286          0   IO-APIC-edge      ide0
> >  17:       7073       2097   IO-APIC-fasteoi   uhci_hcd:usb5, eth0
> >  18:       2525          0   IO-APIC-fasteoi   bttv0, bttv7
> >  19:       2829          0   IO-APIC-fasteoi   bttv1, bttv4
> >  20:       2526          0   IO-APIC-fasteoi   bttv2, bttv5
> >  21:       2226          0   IO-APIC-fasteoi   bttv3, bttv6

The assignment of the interrupt pins from the bttv cards
is dictated by how the motherboard routed the physical wires
from the PCI slots to the IO APIC pins.

Sometimes these can be re-routed by an interrupt router
on the board controlled by PIRQ tables or ACPI PCI
Interrupt Link devices -- but in the case of a dekstop
board with an IOAPIC they are usually just hard
coded in a "barber poll" fashion like above,
and you will not be able to change them
except by moving cards between slots.

The complete output from dmesg -s64000 will tell us.

-Len

> >  22:          2          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb4
> >  23:         86          0   IO-APIC-fasteoi   uhci_hcd:usb2
> >  24:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
> > NMI:          0          0
> > LOC:      13484      13502
> > ERR:          0
> > MIS:          0
> > You can see that IRQ18 is shared between bttv0 and bttv7, IRQ19 between
> > bttv1 and bttv4 and so on.
> > 
> > Sometimes it crashes. It seems a matter of conflict in IRQ.
> > With only one video board everything is ok, but with two, they shared irq
> > and something goes wrong... 
> > How can I tell to the kernel to not to share the IRQ for these boards ?
> > I think (I don't know if I'm right) that this could be the problem.
> > 
> > I even tried with another motherboard, and doing cat /proc/interrupts the
> > situation was the same, except for 'eth0' that was together with bttv0 and
> > bttv7... so it was even worst ! it crashes after few minutes.
> > 
> > I tried to read IO-APIC.txt in Documentation/i386/ folder, but I didn't
> > understand how to avoid the coupling of IRQ.
> > Thanks
> 
> Should be OK.  Can you provide us with any kernel output from these crashes?
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
