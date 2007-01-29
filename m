Return-Path: <linux-kernel-owner+w=401wt.eu-S933131AbXA2FUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbXA2FUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 00:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933135AbXA2FUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 00:20:34 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47985 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136AbXA2FUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 00:20:33 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, jeff@garzik.org, greg@kroah.com,
       tony.luck@intel.com, grundler@parisc-linux.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 0/6] MSI portability cleanups
References: <m1bqkiq25v.fsf@ebiederm.dsl.xmission.com>
	<1170022154.26655.63.camel@localhost.localdomain>
	<m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
	<20070128.153707.30184351.davem@davemloft.net>
Date: Sun, 28 Jan 2007 22:18:59 -0700
In-Reply-To: <20070128.153707.30184351.davem@davemloft.net> (David Miller's
	message of "Sun, 28 Jan 2007 15:37:07 -0800 (PST)")
Message-ID: <m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Sun, 28 Jan 2007 16:26:44 -0700
>
>> Yes.  In general the mainline linux kernel does not support certain
>> classes of stupidity.  TCP offload engines, firmware drivers for
>> hardware we care about, a fixed ABI to binary only modules, etc.
>> It is the responsibility of the OS to setup MSI so we do it, not
>> the firmware so we do it.
>
> I absolutely disagree with you Eric, and I think you're being
> rediculious.
>
> If the hypervisor doesn't control the MSI PCI config space
> register writes, this allows the device to spam PCI devices
> which belong to other domains.
>
> It's a freakin' reasonable design trade off decision, get over
> it! :-)

I completely agree with you in the case you have described, it does
mean that the hypervisor needs to trust all of the MSI capable
hardware in the system but it if that is the best your hardware can
support it is a reasonable trade-off.

With the MSI-X registers in a random part of some memory mapped bar
and not guaranteed to be page aligned, things are more difficult to
isolate purely in a software based hypervisor.

> Yes it can be done at the hardware level, and many hypervisor
> based systems do that, but it's not the one-and-only true
> way to implment inter-domain protection behind a single
> PCI host controller.

The reason I consider the case crazy is that every example I have
been given is where the hardware is doing the filtering above the
PCI device.  So the hypervisor has no need to filter the pci config
traffic or to write to the msi config registers for us.  Yet the
defined hypervisor interface is.  Given the reduction in flexibility
of an interface where the hypervisor writes to the config registers
for the OS as compared to an interface where the hypervisor provides
a destination for MSI messages from a particular device upon request,
I think it is silly to design an interface when you full hardware
support to act like an interface built for a hypervisor that had
to do everything in software.

Regardless of my opinion on the sanity of the hypervisor architects.
I have not seen anything that indicates it will be hard to support
the hypervisor doing everything or most of everything for us, so
I see no valid technical objection to it.  Nor have I ever.

So I have no problem with additional patches in that direction.

Eric
