Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbYGGCpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbYGGCpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 22:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYGGCp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 22:45:28 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41036 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYGGCp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 22:45:27 -0400
Date: Sun, 6 Jul 2008 20:45:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/4] PCI: Support multiple MSI
Message-ID: <20080707024525.GV14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org> <1215264855-4372-2-git-send-email-matthew@wil.cx> <1215396326.19157.15.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215396326.19157.15.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 12:05:25PM +1000, Michael Ellerman wrote:
> On Sat, 2008-07-05 at 09:34 -0400, Matthew Wilcox wrote:
> > Add the new API pci_enable_msi_block() to allow drivers to
> > request multiple MSIs.  Reimplement pci_enable_msi in terms
> > of pci_enable_msi_block.  Add a default implementation of
> > arch_setup_msi_block() that only allows one MSI to be requested.
> 
> I don't think you need arch_setup_msi_block() at all.
> 
> We already have an arch hook that takes a number of irqs, it's
> arch_setup_msi_irqs(), plural. It also has the type passed to it (MSI or
> MSI-X), so it can decide if it needs to allocate the irq numbers
> contiguously.
> 
> Or am I missing something?

I suppose I should audit the current implementors of arch_setup_msi_irqs
(er, maybe that's just you?) to be sure that there's no assumption that
MSI -> asked for one.  I'll look into doing it your way tomorrow (my
timezone ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
