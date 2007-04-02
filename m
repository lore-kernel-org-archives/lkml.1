Return-Path: <linux-kernel-owner+w=401wt.eu-S965763AbXDBTwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965763AbXDBTwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 15:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965760AbXDBTwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 15:52:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55480 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965763AbXDBTwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 15:52:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, "Luck, Tony" <tony.luck@intel.com>,
       "Thomas Meyer" <thomas@m3y3r.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <617E1C2C70743745A92448908E030B2A0148323B@scsmsx411.amr.corp.intel.com>
	<m1r6rbz7mg.fsf@ebiederm.dsl.xmission.com>
	<200704020938.40482.bjorn.helgaas@hp.com>
Date: Mon, 02 Apr 2007 13:50:00 -0600
In-Reply-To: <200704020938.40482.bjorn.helgaas@hp.com> (Bjorn Helgaas's
	message of "Mon, 2 Apr 2007 09:38:40 -0600")
Message-ID: <m1fy7ieetz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bjorn.helgaas@hp.com> writes:

>
> The main reason we wait until pci_enable_device() to allocate an
> IRQ number is that ia64 currently only has about 180 device vectors,
> and there are machines with more PCI slots than that.

If we don't reserve irqs that the hardware doesn't support we should
be able to simply move the allocation and have about the same cost as
we do today.

> I also think it's nice that we don't do anything with a device until
> we have a driver to claim it.  But there certainly have been cases
> where delaying IRQ allocation has caused troubles.

Agreed.  It is the second call to pci_enable_device() by a driver where
things really start to unravel in the wait until we need it plan.

> I really like the idea of moving to the IRQ == GSI model for ia64.
> But of course, we'll have to get rid of the 180-vector limit to
> make that work, too.

Mostly that is a matter of porting the code from x86_64 where that is
already the case.  I'm pretty certain I have worked through all of
the bit issues, but there might be a few small problems that crop up.

If need by I will do the patches as I find time.  But if someone else gets
there before I do that would be great :)

Eric
