Return-Path: <linux-kernel-owner+w=401wt.eu-S1762195AbXEYQFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762195AbXEYQFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbXEYQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:04:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:44042 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751043AbXEYQEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:04:52 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1/cRjIi6ZTcwti2wukI+BuC//vsfkGimK4yWGpLmR
	kFyY9mSagv8V6Z
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Fri, 25 May 2007 17:59:29 +0200
User-Agent: KMail/1.9.5
References: <20070524195616.234280@gmx.net> <200705251559.49807.uwe.bugla@gmx.de> <200705251652.19911.mb@bu3sch.de>
In-Reply-To: <200705251652.19911.mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251759.30065.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 25. Mai 2007 16:52 schrieben Sie:
> On Friday 25 May 2007 15:59:49 Uwe Bugla wrote:
> > Well if you're so clever in software development then please provide an
> > exception handling for the ssb module which is specifically NOT needed by
> > my onboard controller, OK?
> > Just provide compatibility to non-wireless NICs, i. e. to non-ssb
> > devices.
>
> What are you talking about?

First of all, what is an ssb device please? AFAICS it looks like an extension 
of b44.c as far as module selection is concerned in kernel configuration.

What it's function / purpose?
Does its function / purpose apply to every platform?

>
> > I think you cannot just bind ssb tightly to b44.c, can you?
>
> You have no clue about how the b44 hardware works, do you?

Should I? My broadcom 4401 is broken, but only in that specific mm1-tree.
It's not broken in 2.6.22-rc2 for instance. So that's your patch that breaks 
it.

>
> > In so far the way how ssb is attached is buggy and wrong, apart from the
> > fact that my controller is broken, disfunctional.
>
> Please explain in detail how ssb is wrong.

I do not state that ssb is wrong, but I state that the ATTACHMENT of ssb to 
b44.c is wrong. That's a big difference.
In all earlier kernels that b44 device has been fine, and ssb has never been 
seen.

>
> > That's how I understand Andrew Morton's guideline: "Test your patches on
> > three different machines before sending them in."
> > In so far I do expect that you at least take the effort of testing your
> > stuff with a PCI NIC or onboard NIC of the BCM4401 class of NICs before
> > you send your stuff in.
> >
> > In so far you just cannot delegate the testing to other people before you
> > are sending in that stuff.
> > That's what Andrew tried to explain to you.
>
> I tested this code on _all_ of my machines. These include:
> Big-Endian powerpc machine.
> Little-Endian i386 machine.
> OpenWRT router device (ssb is capable of booting this device,
> with some additional code, which is in the OpenWRT tree).
>
> So, now I count the machines (not that this number matters AT ALL):
> One, two, three. Oh, there we go. What a surprise...

Nice for you, but on my machine it is broken, the broadcom 4401 onboard NIC 
controller is unusable.

>
> > I am convinced that your solution runs on your machine, but the solution
> > that you provide looks very rude, doesn't it?
>
> No, explain why.
> In fact, it's considered to be a very elegant solution by various
> developers who actually have a clue about how the hardware works.
> ssb scales from a small MIPS embedded device to real big machines.
>
> > > Please provide more information on the actual _issue_.
> >
> > Sure, no problem:
> >
> > 02:05.0 Ethernet controller: Broadcom Corporation BCM4401 100Base-T (rev
> > 01) Subsystem: ASUSTeK Computer Inc. A7V8X motherboard
> >         Flags: bus master, fast devsel, latency 32, IRQ 17
> >         Memory at f1000000 (32-bit, non-prefetchable) [size=8K]
> >         Capabilities: <access denied>
> >
> > > In this whole mail you basically only state that:
> > > > IRQ 255 looks very idiotic, doesn't it?
> > >
> > > Explain that in detail, please. Why do you think it's wrong?
> >
> > The "traditional" IRQ table provides TWO cascaded blocks of 8 interrupt
> > numbers.
> > Gives a spectrum from 0 to 15, doesn't it?
> >
> > The ACPI system enlarges that, and on at least my system the highest
> > interrupt number is 21. Now if there were some more cards installed the
> > maximum number would perhaps amount to 25.
> >
> > In so far an IRQ value of 255 looks a bit very very strange, doesn't it?
>
> On your architecture, perhaps. I don't know.
>
> > > Which IRQ number do you get with the old b44 driver?
> >
> > IRQ 17
>
> Ok, now I show you the code which determines the IRQ number in ssb:
>
> 	sdev->irq = bus->host_pci->irq;
>
> That's simple, isn't it?
> It simply copies the IRQ number from the original PCI device.
>
> I bet your bug is _not_ caused by ssb, but by some other breakage
> in another subsystem. Maybe ACPI or APIC is broken? Try to boot
> the machine without ACPI and/or APIC.

But if APIC were broken all the other devices would not work too.
But they DO work!
Please correct me if I draw incorrect conclusions.

Do you mean to build a kernel without any ACPI functions?

>
>
> I just downloaded latest -mm to test it on my machine, but the machine
> keeps freezing with that kernel. But I get IRQ 21 for the b44 device.

Fine! Why do I get then a whole sum of correct interrupts while the only 
strange / false one (255) is exactly the one offered to b44.c?

And for what do I get that ssb module who's functionality I do not understand?

If you need futher info please ask. But the possibility that the whole APIC is 
broken is rather small I think. To exclude that I would rather rip out any 
APIC changes in 2.6.22-rc2-mm1, if there are any (didn't take a look for 
that - only found out that the whole system works fine with the exception of 
parts of the alsa architecture and this broken b44.c module.

Cheers

Uwe

Perhaps someone reading this could try to reproduce that problem on his 
machine.
Now who of the readers owes a Broadcom 4401 NIC and can please try to test 
kernel 2.6.22-rc2-mm1?

Those NICs have been used very very often as onboard controllers, especially 
on ASUS boards.
