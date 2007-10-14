Return-Path: <linux-kernel-owner+w=401wt.eu-S1764268AbXJNXgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764268AbXJNXgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 19:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbXJNXge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 19:36:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:33069 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbXJNXgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 19:36:33 -0400
Subject: Re: MSI interrupts and disable_irq
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, Jeff Garzik <jgarzik@pobox.com>,
       Ayaz Abdulla <aabdulla@nvidia.com>, nedev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <86802c440710141615g60fb9775oba590deb1a9fabde@mail.gmail.com>
References: <46FC15A9.1070803@nvidia.com> <46FDBCB4.9090802@pobox.com>
	 <4710901F.8010206@colorfullife.com>
	 <86802c440710132259o6e82f6s4bed7b25bd5636e9@mail.gmail.com>
	 <4711C217.2010605@colorfullife.com> <1192398473.6188.10.camel@pasglop>
	 <86802c440710141615g60fb9775oba590deb1a9fabde@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 09:36:12 +1000
Message-Id: <1192404972.7014.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-10-14 at 16:15 -0700, Yinghai Lu wrote:
> On 10/14/07, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> >
> > On Sun, 2007-10-14 at 09:15 +0200, Manfred Spraul wrote:
> > > Yinghai Lu wrote:
> > > > On 10/13/07, Manfred Spraul <manfred@colorfullife.com> wrote:
> > > >
> > > >> Someone around with a MSI capable board? The forcedeth driver does
> > > >>     dev->irq = pci_dev->irq
> > > >> in nv_probe(), especially before pci_enable_msi().
> > > >> Does pci_enable_msi() change pci_dev->irq? Then we would disable the
> > > >> wrong interrupt....
> > > >>
> > > >
> > > > the request_irq==>setup_irq will make dev->irq = pci_dev->irq.
> > > >
> > > >
> > > Where is that?
> > > Otherwise I would propose the attached patch. My board is not
> > > MSI-capable, thus I can't test it myself.
> >
> > Why not just copy pcidev->irq to dev->irq once ?
> 
> it seems e1000 is using np->pci_dev->irq directly too.

Heh, allright, doesn't matter, I was just proposing to avoid one more
indirection :-)

Ben.


