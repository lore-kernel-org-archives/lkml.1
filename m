Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbXDBPjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbXDBPjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932404AbXDBPjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:39:20 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:38696 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253AbXDBPjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:39:20 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Mon, 2 Apr 2007 09:38:40 -0600
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Luck, Tony" <tony.luck@intel.com>, "Thomas Meyer" <thomas@m3y3r.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>
References: <617E1C2C70743745A92448908E030B2A0148323B@scsmsx411.amr.corp.intel.com> <m1r6rbz7mg.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6rbz7mg.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020938.40482.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2007 21:29, Eric W. Biederman wrote:
> "Luck, Tony" <tony.luck@intel.com> writes:
> 
> >> What I'm proposing we do is move the irq allocation code out of
> >> pci_enable_device and the irq freeing code out of pci_disable_device
> >> in the future.
> >
> > Sounds rational ... in a world that wasn't dominated by PCI it would
> > seem to be the logical approach (since the irq code would have much
> > more utility independent of the PCI code).
> 
> Right.  We can even do this earlier in the pci code.  Just doing this
> on demand when the device driver needs it is problematic.  As devices
> drivers like to keep the requested over a pci_disable_device pci_enable_device
> pair.
> 
> The big practical issue is that we will like wind up allocating an irq
> number to all usable irqs on ia64.  Which means we will like need many
> more irq numbers...  Although I guess if we keep it at the pci layer
> we should be fairly safe.

The main reason we wait until pci_enable_device() to allocate an
IRQ number is that ia64 currently only has about 180 device vectors,
and there are machines with more PCI slots than that.

I also think it's nice that we don't do anything with a device until
we have a driver to claim it.  But there certainly have been cases
where delaying IRQ allocation has caused troubles.

I really like the idea of moving to the IRQ == GSI model for ia64.
But of course, we'll have to get rid of the 180-vector limit to
make that work, too.

Bjorn
