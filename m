Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbYKCPe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbYKCPe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbYKCPes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:34:48 -0500
Received: from ns2.suse.de ([195.135.220.15]:46042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbYKCPer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:34:47 -0500
Message-ID: <490F1A10.3010302@suse.de>
Date: Mon, 03 Nov 2008 16:34:40 +0100
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: "M. Vefa Bicakci" <bicave@superonline.com>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Olaf Dabrunz <odabrunz@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Update: "nobody cared" on Toshiba Satellite A100
References: <48FB3ED5.60904@superonline.com> <1224431722.26279.4.camel@sven.thebigcorporation.com> <48FB6321.7030501@superonline.com> <48FC38AE.3030007@suse.de> <48FD0152.60907@superonline.com> <48FDFB97.1050208@suse.de> <490E1207.9050508@superonline.com>
In-Reply-To: <490E1207.9050508@superonline.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

M. Vefa Bicakci wrote:
> Hello,
> 
> Stefan Assmann wrote:
>> To get some more information I have some more things to suggest:
> 
> I am sorry for not letting you know of the results of my tests so far.
> As you know, this problem is not predictable, and I have to wait a long
> time or reboot multiple times before I can get a "nobody cared" message.
> 
> The contents of this e-mail were not written in chronological order.
> I have tried your suggestions in the following order: third, first
> and second.
> 
>> 1. try the noapic option
> 
> With the "noapic" option, there is yet another unpredictable problem.
> Sometimes booting with the "noapic" option is okay, whereas sometimes
> it causes "nobody cared" messages to get printed after the initramfs
> phase.
> 
> With the "noapic" option, the problematic IRQ has switched from 18
> to 11 and sometimes 10.
> 
> I have not tested a kernel with the "noapic" option long enough to see
> whether a "nobody cared" message would pop up hours or days after the
> computer boots.

What looks interesting:

irq 11: nobody cared (try booting with the "irqpoll" option)
[...]
handlers:
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8878b60>] (irq_handler+0x0/0x490 [firewire_ohci])
Disabling IRQ #11

irq 10: nobody cared (try booting with the "irqpoll" option)
[...]
handlers:
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f887f940>] (sdhci_irq+0x0/0x610 [sdhci])
[<f8890820>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8afa8e0>] (yenta_interrupt+0x0/0xf0 [yenta_socket])
[<f8b89640>] (tifm_7xx1_isr+0x0/0x140 [tifm_7xx1])
[<f8cbe7a0>] (azx_interrupt+0x0/0x130 [snd_hda_intel])
[<f88e31a0>] (e100_intr+0x0/0xe0 [e100])
[<f8e6ea90>] (i915_driver_irq_handler+0x0/0x230 [i915])
Disabling IRQ #10

irq 18: nobody cared (try booting with the "irqpoll" option)
[...]
handlers:
[<f8890830>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f88c5940>] (sdhci_irq+0x0/0x610 [sdhci])
[<f8afa8e0>] (yenta_interrupt+0x0/0xf0 [yenta_socket])
[<f8bd4640>] (tifm_7xx1_isr+0x0/0x140 [tifm_7xx1])
Disabling IRQ #18

If you compare the handlers from all the different warnings you'll see
that they all share the USB handler.

>> 2. try the irqpoll option
> 
> I have compiled 2.6.27.4 with the spurious interrupt patch you provided,
> and I have booted it with the irqpoll option. Currently I am waiting for
> a "nobody cared" message.
> 
> By the way, would I get any messages from the kernel if one of the IRQs
> was not handled properly and hence the functionality enabled by "irqpoll"
> was used?

No, I don't think there is any notification.

> 
>> 3. try the latest 2.6.26 kernel to verify this has been introduced with
>> 2.6.27
> 
> I have done some testing with Sidux's 2.6.27-6.slh.4, vanilla 2.6.27.7 and
> vanilla 2.6.27.2, the last two of which had a modified version your patch
> applied. The modification was the replacement of 99900 with 99 instead of
> the 999 that you suggested in your patch. I hope that this has not caused
> false positives. I didn't use any kernel command line options. 
> 
> Version:                                "nobody cared"?
> 2.6.27.2 (vanilla, no patch)            Yes
> 2.6.26.7 (vanilla, with patch)          Yes
> 2.6.26-6.slh.4 (Sidux, no patch)        Yes
> 
> Here's the chronology:
> 
> I first tried 2.6.27.2 without the patch. I got the "nobody cared"
> message approximately 3.5 hours after the boot. Because of the
> relative quickness, I didn't see the need to try it with the patch.
> 
> I then tried 2.6.26.7 with the patch, and I got the "nobody cared"
> message after 9.5 hours.

I expected this to happen much quicker if it would be a generic problem.
Looks like one of the drivers is doing something fishy under certain
circumstances. And which driver appeared in all of the messages? USB!

> Then I wanted to make sure that my changing the 999 into 99 did
> not cause a false positive. I tried Sidux's 2.6.26.6 based kernel,
> unmodified - that is without the patch applied. I got the "nobody
> cared" message after approximately three days.
> 
> ===
> 
> So, this might not be regression caused by 2.6.27 after all.
> Before switching to 2.6.27-rcX series, I used 2.6.25.X, and I used to
> attach my USB keyboard to one of the USB ports on the right side of the
> laptop. During the time of the switch to 2.6.27-rcX, I started to use
> the USB ports on the rear panel of the laptop to reduce desktop clutter,
> and I started to get the "nobody cared" message. Not thinking about the
> possibility of port or controller specific issues, I thought that this
> could be a regression. (I will try 2.6.25.19 after I'm done with 2.6.27.4
> and irqpoll.)
> 
> Is there anything I can do to get more information about this problem?
> There seems to be too many variables and unpredictable behavior. If you
> could provide me with a step by step systematic method to debug this
> problem, I would really appreciate it.

We need to narrow down where exactly this problem was introduced. To do
that it's helpful to bisect the kernel. A good start on how to do it
can be found at http://www.kernel.org/doc/local/git-quick.html.

Since I have a strong hunch that this is a USB issue please try the
following first. Boot your system with one of the mentioned kernels and
unload all USB modules. Then try to reproduce. If you cannot reproduce
the problem it's pretty clear where the problem originates.

> Again, thank you for your help.
> 
> M. Vefa Bicakci
> 

  Stefan

-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail : sassmann@suse.de | GF: Markus Rex, HRB 16746 (AG Nuernberg)
