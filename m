Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393AbYKHH55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbYKHH55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 02:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYKHH5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 02:57:46 -0500
Received: from colo.lackof.org ([198.49.126.79]:39561 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbYKHH5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 02:57:45 -0500
Date: Sat, 8 Nov 2008 00:57:30 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Nobin Mathew <nobin.mathew@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
Subject: Re: sharing interrupt between PCI device
Message-ID: <20081108075729.GA15107@colo.lackof.org>
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no> <4910E8AC.7050407@shaw.ca> <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com> <49115AFC.2030400@gmail.com> <8d6898730811050120k10a20e4em744be45e04cfba94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d6898730811050120k10a20e4em744be45e04cfba94@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 02:50:01PM +0530, Nobin Mathew wrote:
> Hi
> 
> 
> Code is here
> first one USB Virual input devices
> 
> http://lxr.linux.no/linux+v2.6.27.4/drivers/usb/core/hcd-pci.c
> 
> Second one is hp-ilo driver
> 
> http://lxr.linux.no/linux+v2.6.27.4/drivers/misc/hpilo.c

I looked for usage of request_irq() and didn't see it in either driver.

I was looking for the parameters passed to the request_irq() call.
If the IRQ and the "dev_id" parameter are the same for both drivers,
I'm not sure how the generic IRQ management code could tell them apart
and then might disable the wrong instance when free_irq() is called.
Perhaps you already know where the respective request_irq() calls are
and can easily determine that both are passing in a NULL for
the "dev_id" parameter?


If that's not the case, I would be looking for bugs in the generic
shared IRQ code.  But given shared IRQ experience with older kernels,
I'm not inclined to believe there is a problem in the generic IRQ code
on newer kernels unless presented with contrary evidence.

hth,
grant



> 
> Thanks
> Nobin Mathew.
> 
> 
> On Wed, Nov 5, 2008 at 2:06 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> > On 11/05/2008 08:49 AM, Nobin Mathew wrote:
> >> Hi
> >>
> >> This is the system information X86_64 platform Xeon dual core processor.
> >>
> >> I saw the pci_disable_device () it is calling pcibios_disable_device
> >> () and this is is defined as
> >>
> >> void pcibios_disable_device (struct pci_dev *dev)
> >> {
> >>         pcibios_disable_resources(dev);
> >>         if (pcibios_disable_irq)
> >>                 pcibios_disable_irq(dev);
> >> }
> >>
> >> In i386 platform, I could not find a definition for these calls in
> >> x86_64 platform, i think it is using i386 platform code.
> >
> > Well, will you show us the code, so that we needn't to crystal gaze? It's pretty
> > hard to say what happens, if we don't see what you do in the driver...
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
