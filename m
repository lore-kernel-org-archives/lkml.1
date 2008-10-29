Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbYJ2POE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbYJ2POE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYJ2PNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:13:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:52574 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbYJ2PNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:13:51 -0400
Date: Wed, 29 Oct 2008 08:13:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Glauber Costa <gcosta@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Fix CONFIG_PCI=n compile failure
Message-ID: <20081029081347.63048b8d@infradead.org>
In-Reply-To: <1225289883.3257.9.camel@localhost.localdomain>
References: <1225228943.3251.17.camel@localhost.localdomain>
	<20081029073629.GB17992@elte.hu>
	<1225288906.3257.4.camel@localhost.localdomain>
	<20081029070824.10c19a57@infradead.org>
	<1225289883.3257.9.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 09:18:03 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2008-10-29 at 07:08 -0700, Arjan van de Ven wrote:
> > On Wed, 29 Oct 2008 09:01:46 -0500
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > This is obviously some strange definition of the word "right" of
> > > which I was previously unaware.  That patch moves forbid_dac plus
> > > a load of quirk processing (also for a PCI bus) out from under
> > > CONFIG_PCI only ... which will fix the compile error, sure.
> > > 
> > > However, if you'd be so kind, please explain how a DAC (meaning
> > > Dual Addressing Cycle on the PCI bus) is useful (or even can be
> > > effected) without a PCI bus?
> > > 
> > > All its really doing is contaminating pci-dma.c with clutter that
> > > only needs to be there because someone can't get the separation
> > > right.o
> > >
> > 
> > why do you even want that file for CONFIG_PCI=n ??
> 
> Um, my fault from long ago.  It's contaminated with the dma_ API
> pieces that are bus generic.
> 
> The correct solution, I think, is to split it out into a bus generic
> piece and a PCI specific piece.  

agreed

> I think all the intel/amd IOMMU stuff
> should be in the PCI specific piece ... although I know there's a
> theoretical case where the AMD iommu can be ht bus only with no PCI
> bus, I don't think anyone's built such a beast, in which case it's
> safe to condition iommu presence on CONFIG_PCI?

I would think that's not relevant; AMD seems to have PCI in it's cpu
package already, never mind what it is connected to.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
