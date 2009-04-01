Return-Path: <linux-kernel-owner+w=401wt.eu-S933481AbZDASiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481AbZDASiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbZDAShx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:37:53 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:43114 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759862AbZDAShw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:37:52 -0400
Date: Wed, 1 Apr 2009 12:37:49 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI changes for 2.6.30
Message-ID: <20090401183749.GC8188@ldl.fc.hp.com>
References: <20090331121331.3673cf59@hobbes> <alpine.LFD.2.00.0904010957520.4130@localhost.localdomain> <20090401101309.67d0bea5@hobbes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401101309.67d0bea5@hobbes>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes <jbarnes@virtuousgeek.org>:
> On Wed, 1 Apr 2009 10:01:12 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Tue, 31 Mar 2009, Jesse Barnes wrote:
> > >
> > > Please consider pulling my PCI tree from
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
> > > linux-next
> > 
> > This produces
> > 
> >   WARNING: drivers/built-in.o(.text+0x69a1): Section mismatch in
> > reference from the function dev_rescan_store() to the
> > function .devinit.text:pci_rescan_bus() The function
> > dev_rescan_store() references the function __devinit
> > pci_rescan_bus(). This is often because dev_rescan_store lacks a
> > __devinit annotation or the annotation of pci_rescan_bus is wrong.
> > 
> > Hmm?
> 
> Arg how did I miss that?  Maybe the last build I did was missing
> hotplug support or something... Anyway looking now (at first glance I
> think pci_rescan_bus needs to drop __devinit).

This was my fault. pci_rescan_bus() definitely does not want
__devinit.

But I'm confused -- didn't we used to have an option in
menuconfig under Kernel Hacking that would turn on section
mismatch warnings? I used to have that turned on, and don't
remember turning it off, and I can't find it now.

I'm told that we're supposed to set it on the make command line,
like:

	make CONFIG_DEBUG_SECTION_MISMATCH=y -j16

or something. Has this changed recently or am I just imagining
things (or just plain stupid?)

Thanks.

/ac

