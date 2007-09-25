Return-Path: <linux-kernel-owner+w=401wt.eu-S1759118AbXIYChn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118AbXIYChn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 22:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXIYChf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 22:37:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:27864 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbXIYChe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 22:37:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kn5pF+iomaUqElVt2tyOYZpm73AwMmGJJBcXNiTYjpEV9vNrwV1e+LJgzfQzhjCmZTHAKV32xRX3HES+I0EyfQgE+hGIlnZ7GKYfufo11lYP+jAap9xpZSBwaog+FH8PIdYw8yhysU8Bm+La2C42YcShWbFiOJf/5VYplbudseQ=
Message-ID: <95455e980709241937y7bc45eedgc0a977b156cf852d@mail.gmail.com>
Date: Tue, 25 Sep 2007 12:37:32 +1000
From: hce <webmail.hce@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: Ethernet driver on 2.6.22
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070924154430.f19136e1.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <95455e980709231552l73bd8c78u46d3a45266749902@mail.gmail.com>
	 <20070923183438.8807b5da.randy.dunlap@oracle.com>
	 <95455e980709231940m571c628cj887628aba4a21c4b@mail.gmail.com>
	 <20070923203910.8b414cc6.randy.dunlap@oracle.com>
	 <95455e980709241539m133d0098y5d3c7147188d9508@mail.gmail.com>
	 <20070924154430.f19136e1.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Tue, 25 Sep 2007 08:39:07 +1000 hce wrote:
>
> > On 9/24/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > On Mon, 24 Sep 2007 12:40:07 +1000 hce wrote:
> > >
> > > > Thanks Randy.
> > > >
> > > > On 9/24/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > > > On Mon, 24 Sep 2007 08:52:36 +1000 hce wrote:
> > > > >
> > > > > > Hi,
> > > > > >
> > > > > > I am upgrading from kernel 2.6.11 to 2.6.22 on ARM S3C2400A and found
> > > > > > a following issue on 2.6.22.
> > > > > >
> > > > > > On 2.6.11, I selected CONFIG_ISA,  CONFIG_NET_PCI and CONFIG_CS89X0 to
> > > > > > build  CS8900A Ethernet driver to kernel, it was running perfect.
> > > > > >
> > > > > > But on 2.6.22, I made the same configuration for CS8900A, the cs89x0.o
> > > > > > could not be compiled in to the kernel (or as a module when I tried to
> > > > > > CONFIG_CS89X0=m) unless I commented out depends statement in
> > > > > > drivers/net/Kconfig. I double checked all three are CONFIG_ISA=y,
> > > > > > CONFIG_NET_PCI=y and CONFIG_CS89X0=y. Any explanation please, was I
> > > > > > missing something here?
> > > > >
> > > > > I didn't look in 2.6.11 Kconfig files, but in 2.6.22, this driver is
> > > > > limited to 3 specific boards:
> > > > >
> > > > > config CS89x0
> > > > >         tristate "CS89x0 support"
> > > > >         depends on NET_PCI && (ISA || MACH_IXDP2351 || ARCH_IXDP2X01 || ARCH_PNX010X)
> > > >
> > > > The Kconfig for CS89x0 in 2.6.11 is exactly the same as 2.6.22.
> > > >
> > > > > Does ARM S3C2400A qualify as any of those?  (MACH_... or ARCH_...)
> > > >
> > > > I can run CS89x0 for ARM S3C2400 in 2.6.11, at least I can say yes,
> > > > the ARM S3C2400A qualifies those in 2.6.11, I don't know the 2.6.22
> > > > and I hope someone knows 2.6.22 well can answer it.
> > > >
> > > > > (latter: ARCH_PNX010X is not used anywhere else AFAICT)
> > > >
> > > > Yes, but you only need to enable ISA and NET_PCI to use CS89x0.
> > >
> > > Right.
> > >
> > > I don't have any problem building CS89x0 for X86_32:
> > > make defconfig then enable ISA (what!?!?  why not in defconfig?)
> > > and then enable CS89x0.
> >
> > I don't have my embedded system here, I'll try when I get there. But,
> > let me clarify it, did you mean to type "make defconfig" on linux
> > (kernel) directory, and enable ISA, NET_PCI and CS89x0 from the
> > prompt?
> >
> > My procedure was to edit .config to enable ISA, NET_PCI and CS89x0
> > from vim, then type "make menuconfig" and "make oldconfig" (The same
> > procedure I did in 2.6.11 which works fine). Does that make things
> > differently?
>
> You should do "make oldconfig" immediately after editing the .config
> file (AFAIK).  Or the "make menuconfig" might run the oldconfig
> changes for you.

Sorry, I was not clear. The procedure was actually I type "make
ARCH=arm menuconfig" first, then I could not find the CONFIG_ISA,
CONFIG_NET_SPI and CONFIG_CS89x0 on config screen, this is still
puzzles me why could "make menuconfig" displays all possible
configurations on 2.6.22? Could you please explain?

Because I was not able to add CONFIG_ISA, CONFIG_NET_SPI and
CONFIG_CS89x0 from "make menuconfig", I used vim to manually added
those and then "make oldconfig".

> Then I would just double-check the final .config file
> to make sure that it contains what you expect it to contain.

Yes, I did double-check with the .config file, all three are =y.

Thanks Randy.

Regards,

Jim
