Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYJ2OST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYJ2OST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 10:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYJ2OSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 10:18:09 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46624 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbYJ2OSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 10:18:08 -0400
Subject: Re: [PATCH] x86: Fix CONFIG_PCI=n compile failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Glauber Costa <gcosta@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20081029070824.10c19a57@infradead.org>
References: <1225228943.3251.17.camel@localhost.localdomain>
	 <20081029073629.GB17992@elte.hu>
	 <1225288906.3257.4.camel@localhost.localdomain>
	 <20081029070824.10c19a57@infradead.org>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 09:18:03 -0500
Message-Id: <1225289883.3257.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-29 at 07:08 -0700, Arjan van de Ven wrote:
> On Wed, 29 Oct 2008 09:01:46 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > This is obviously some strange definition of the word "right" of
> > which I was previously unaware.  That patch moves forbid_dac plus a
> > load of quirk processing (also for a PCI bus) out from under
> > CONFIG_PCI only ... which will fix the compile error, sure.
> > 
> > However, if you'd be so kind, please explain how a DAC (meaning Dual
> > Addressing Cycle on the PCI bus) is useful (or even can be effected)
> > without a PCI bus?
> > 
> > All its really doing is contaminating pci-dma.c with clutter that only
> > needs to be there because someone can't get the separation right.o
> >
> 
> why do you even want that file for CONFIG_PCI=n ??

Um, my fault from long ago.  It's contaminated with the dma_ API pieces
that are bus generic.

The correct solution, I think, is to split it out into a bus generic
piece and a PCI specific piece.  I think all the intel/amd IOMMU stuff
should be in the PCI specific piece ... although I know there's a
theoretical case where the AMD iommu can be ht bus only with no PCI bus,
I don't think anyone's built such a beast, in which case it's safe to
condition iommu presence on CONFIG_PCI?

James


