Return-Path: <linux-kernel-owner+w=401wt.eu-S965780AbXD1L2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965780AbXD1L2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965796AbXD1L2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:28:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43518 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965780AbXD1L2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:28:53 -0400
Date: Sat, 28 Apr 2007 12:32:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-ID: <20070428123222.2ad96f77@the-village.bc.nu>
In-Reply-To: <20070428111835.GA4471@one.firstfloor.org>
References: <20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com>
	<4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<20070427221803.2a117c23.akpm@linux-foundation.org>
	<p73tzv022qw.fsf@bingen.suse.de>
	<20070428030213.4787031f.akpm@linux-foundation.org>
	<20070428111504.24641d03@the-village.bc.nu>
	<20070428111835.GA4471@one.firstfloor.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > At least one way to handle BUG_ON() type situations more cleanly (for
> > some anyway) is to fake a hot-unplug/plug event. Thats something that
> 
> That would have a high risk of deadlock on some lost lock.

Well I was assuming you'd code this up in the driver not arbitarily - and
you need to do that for IRQ anyway. So something like


	writel(0xFFFFFFFF, &mdev->irq_mask);
	pci_mark_failed(pdev, PCI_TRY_REPLUG|PCI_TRY_D3);
	spin_unlock(&mylock);
	return -EXPLODED;

with pci_mark_failed firing off any replug via a work queue

Alan
