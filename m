Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbYGTHt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbYGTHt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 03:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYGTHtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 03:49:20 -0400
Received: from colo.lackof.org ([198.49.126.79]:55591 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbYGTHtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 03:49:19 -0400
Date: Sun, 20 Jul 2008 01:49:07 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-pci@vger.kernel.org,
       kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu, tglx@linutronix.de,
       davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       michael@ellerman.id.au, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 3/4] AHCI: Request multiple MSIs
Message-ID: <20080720074907.GA1218@colo.lackof.org>
References: <20080705132728.GO14894@parisc-linux.org> <1215264855-4372-3-git-send-email-matthew@wil.cx> <20080707164534.GF7521@colo.lackof.org> <20080707174803.GD14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707174803.GD14894@parisc-linux.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 11:48:03AM -0600, Matthew Wilcox wrote:
> On Mon, Jul 07, 2008 at 10:45:34AM -0600, Grant Grundler wrote:
> > If the system is busy, the readl is the cost of coalescing the
> > interrupts.  I suspect it's cheaper to take one readl than
> > handle 16 individual interrupts.
> 
> 16 would be a maximum imposed by the AHCI spec.  My ICH9 board has 6
> ports, but requests all 16 interrupts
> 
> > I'm just pointing out the only upside of the existing code and not trying
> > to argue against this patch.
> 
> There may well be an upside to the existing code, but it's pretty slim.
> The oprofile shows clearly that ahci_interrupt is the largest consumer of
> time during an iozone run.  The only thing that routine does is read the
> HOST_IRQ_STAT register, acquire the spinlock and loop calling
> ahci_port_intr().
> 
> I don't have a profile for this new code yet.  Hopefully we'll have one
> by the end of the day.

Willy,
where you able to get this profile?
I'm still curious.

> 
> > BTW, one more downside of the regular IRQ is it's possibly shared.
> > Using MSI guaratees exclusive IRQ and avoids spurious readl's
> > when AHCI is not busy but the other device is. This would be worth
> > noting (or as a reminder) in the change log or as a comment in
> > the code.
> 
> AHCI already allocates itself a new MSI if the machine supports MSI.
> This change merely extends AHCI to use multiple MSIs.

ok.

thanks,
grant

> 
> Thanks.
> 
> -- 
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
