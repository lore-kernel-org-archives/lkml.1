Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYBJThp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYBJThp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYBJThh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:37:37 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:60241 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYBJThg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:37:36 -0500
Date: Sun, 10 Feb 2008 12:37:34 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Greg KH <greg@kroah.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Camuso <tcamuso@redhat.com>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Message-ID: <20080210193734.GD5299@parisc-linux.org>
References: <20080128225334.GD4720@kroah.com> <20080129025615.GC20198@parisc-linux.org> <20080129030340.GE20198@parisc-linux.org> <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com> <47AB299D.4000500@redhat.com> <20080209124138.GA28967@parisc-linux.org> <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com> <20080210072116.GA12375@kroah.com> <20080210145122.GC5299@parisc-linux.org> <20080210191313.GA9045@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210191313.GA9045@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 12:13:13PM -0700, Grant Grundler wrote:
> Just wondering...why don't we just pass "struct bus*" through to the
> raw_pci* ops?
> My thinking is if a PCI bus controller or bridge is discovered, then we should
> always create a matching "struct bus *".

ACPI may need to access PCI config space before we've done a PCI bus
walk.  There's an opregion that AML may access that is for PCI config
space, and an apparently unrelated method might happen to contain such a
piece of AML.

> > --- a/arch/x86/kernel/quirks.c
> > +++ b/arch/x86/kernel/quirks.c
> > @@ -27,7 +27,7 @@ static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
> >  	pci_write_config_byte(dev, 0xf4, config|0x2);
> >  
> >  	/* read xTPR register */
> > -	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
> > +	raw_pci_read(0, 0, 0x40, 0x4c, 2, &word);
> 
> Why are we using raw_pci_read here instead of pci_read_config_dword()?
> If the pci_write_config_byte() above works, then I expect the read
> to work too.

I have no idea.  I didn't want to change the semantics in this patch.
Presumably the original author would have an idea why they needed to do
this.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
