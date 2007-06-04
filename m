Return-Path: <linux-kernel-owner+w=401wt.eu-S1761897AbXFDTOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897AbXFDTOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761546AbXFDTNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:13:50 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:44995 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761536AbXFDTNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:13:49 -0400
Date: Mon, 4 Jun 2007 22:13:46 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/15] x86-64: Calgary - abstract how we find the iommu_table for a device
Message-ID: <20070604191346.GL4556@rhun.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <20070604113344.0e71ca8c.akpm@linux-foundation.org> <20070604190654.GA20299@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604190654.GA20299@havoc.gtf.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 03:06:54PM -0400, Jeff Garzik wrote:

> On Mon, Jun 04, 2007 at 11:33:44AM -0700, Andrew Morton wrote:
> > On Tue, 22 May 2007 04:05:54 -0400
> > muli@il.ibm.com wrote:
> > 
> > > From: Muli Ben-Yehuda <muli@il.ibm.com>
> > > 
> > > ... in preparation for doing it differently for CalIOC2.
> > > 
> > 
> > This patch gets
> > 
> > patching file arch/x86_64/kernel/pci-calgary.c
> > Hunk #2 FAILED at 374.
> > Hunk #3 FAILED at 403.
> > Hunk #4 FAILED at 457.
> > Hunk #5 FAILED at 473.
> > Hunk #6 FAILED at 489.
> > 5 out of 6 hunks FAILED -- saving rejects to file arch/x86_64/kernel/pci-calgary.c.rej
> > Failed to apply x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device
> > 
> > 
> > due to git-pciseg.patch.
> > 
> > So I'll drop git-pciseg until this patch gets to mainline and then
> > git-pciseg gets fixed up for it.
> 
> 
> Regardless of who it is, people have to stop fighting over
> ->sysdata.  It's unscalable, regardless of who it is.
> 
> Whoever wants to be upstream first should take the basic "x86
> sysdata" bits from jgarzik/misc-2.6.git#pciseg and push those
> upstream...  which I note includes Calgary work.
> 
> Then NUMA, Calgary and PCI domain stuff merely involve modifying the
> x86 version of struct pci_sysdata.
> 
> I would NAK any [PCI domain | NUMA | Calgary]-only approach to using
> ->sysdata.  It clearly does NOT belong to any one subsystem,
> regardless of who gets upstream first.

It's already being used in mainline by both NUMA and Calgary (but in
such a way that both work. Magic). Clearly the solution is what we did
for pciseg, have a struct sysdata that is extensible, but those pciseg
bits don't seem any closer to going upstream?

Cheers,
Muli
