Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbXC0Nxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbXC0Nxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 09:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXC0Nxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 09:53:39 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41657 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbXC0Nxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 09:53:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, bunk@stusta.de, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC: 2.6.21 patch] let PCI_MSI depend on EXPERIMENTAL
References: <20070327010247.GW16477@stusta.de>
	<20070326.182422.115910859.davem@davemloft.net>
	<m14po71ir7.fsf@ebiederm.dsl.xmission.com>
	<4608AA30.1010407@garzik.org>
Date: Tue, 27 Mar 2007 07:53:13 -0600
In-Reply-To: <4608AA30.1010407@garzik.org> (Jeff Garzik's message of "Tue, 27
	Mar 2007 01:22:56 -0400")
Message-ID: <m1tzw6yera.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Eric W. Biederman wrote:
>> aka.  Drivers have started supporting MSI, People have started using
>> and testing MSI, and there has been MSI maintenance.  People care.
>
> Agreed, well put.
>
>
>> The most recent regressions involving MSI have been fixes propagating
>> their way through the kernel, and I can't think of a one of them
>> that was MSI specific.  Just that the bug didn't happen to show
>> up clearly without MSI enabled.
>
> Yep.
>
>
>> So default it to off, although I suspect we are approaching the
>> point where it would actually be safe to default it to on.  We
>> need a kernel release that doesn't have msi issues yet.
>
> Now that we are finally getting a handle on the MSI bumps-in-the-road, IMO it
> would be counterproductive to default it to 'off' now.

Let's see the Kconfig entry currently reads:

> config PCI_MSI
>         bool "Message Signaled Interrupts (MSI and MSI-X)"
>         depends on PCI
>         depends on (X86_LOCAL_APIC && X86_IO_APIC) || IA64 || SPARC64
>         help
>            This allows device drivers to enable MSI (Message Signaled
>            Interrupts).  Message Signaled Interrupts enable a device to
>            generate an interrupt using an inbound Memory Write on its
>            PCI bus instead of asserting a device IRQ pin.
> 
>            Use of PCI MSI interrupts can be disabled at kernel boot time
>            by using the 'pci=nomsi' option.  This disables MSI for the
>            entire system.
> 
>            If you don't know what to do here, say N.

So I don't know if we are defaulting it to off but we are advising it be
turned off.  So all of the bug reports are coming from people who presumably
know what they are doing and deliberately turn it on.

Once things quite down and we fix the chipset support detection then I think
we can default it to on.  Once that settles down we can remove the manual
option entirely except possibly under CONFIG_EMBEDDED.

We certainly don't have the question does this chipset support MSI handled
well enough to do better right now.  I think non-x86 might but we certainly
don't.

Eric

