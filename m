Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYKHR1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYKHR1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 12:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYKHR1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 12:27:34 -0500
Received: from colo.lackof.org ([198.49.126.79]:42057 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYKHR1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 12:27:33 -0500
Date: Sat, 8 Nov 2008 10:27:16 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Nobin Mathew <nobin.mathew@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>, jirislaby@gmail.com
Subject: Re: sharing interrupt between PCI device
Message-ID: <20081108172716.GA28039@colo.lackof.org>
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no> <4910E8AC.7050407@shaw.ca> <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 01:19:29PM +0530, Nobin Mathew wrote:
> Hi
> 
> This is the system information X86_64 platform Xeon dual core processor.
> 
> I saw the pci_disable_device () it is calling pcibios_disable_device
> () and this is is defined as
> 
> void pcibios_disable_device (struct pci_dev *dev)
> {
>         pcibios_disable_resources(dev);
>         if (pcibios_disable_irq)
>                 pcibios_disable_irq(dev);
> }
> 
> In i386 platform, I could not find a definition for these calls in
> x86_64 platform, i think it is using i386 platform code.

cscope would have helped you out here.
See arch/x86/pci/acpi.c:

int __init pci_acpi_init(void)
{
...
        pcibios_enable_irq = acpi_pci_irq_enable;
        pcibios_disable_irq = acpi_pci_irq_disable;
...
}

So I see how the IRQ is enabled and disabled. I still don't see where
an interrupt handler is bound to IRQ 225 (output you posted today in
another email). Nobin, can you dump /proc/interrupts when both drivers
are loaded and also send the dmesg output after both are loaded?

The "lspci" output Jiri asked for would be very helpful too.

thanks,
grant

> 
> Thanks
> Nobin Mathew
> 
> 
> 
> 
> 
> On Wed, Nov 5, 2008 at 5:58 AM, Robert Hancock <hancockr@shaw.ca> wrote:
> > Nobin Mathew wrote:
> >>
> >> Hi,
> >>
> >> I think this question is already asked in this mailing list and Sorry
> >> for asking this again.
> >>
> >> My problem is this:
> >>
> >> I have two PCI devices ( also two kernel drivers for those) which
> >> shares the interupt. When I remove one driver other device stops
> >> working, which is happening due to pci_disable_device () in removed
> >> driver. This call is disabling the shared interrupt.
> >
> > pci_disable_device shouldn't be disabling the interrupt line, at least not
> > in this case. Without more details on the platform or drivers, it's
> > difficult to say why this would happen.
> >
> >>
> >> We can avoid this by just removing the pci_disable_device () in the
> >> driver, but i dont think this is a good way (correct me if I am
> >> wrong).
> >>
> >> Can you suggest some ways to overcome this issue.
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
