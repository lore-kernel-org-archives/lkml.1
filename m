Return-Path: <linux-kernel-owner+w=401wt.eu-S933150AbXA2F7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbXA2F7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 00:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933158AbXA2F7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 00:59:51 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33024 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933150AbXA2F7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 00:59:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, jeff@garzik.org, greg@kroah.com,
       tony.luck@intel.com, grundler@parisc-linux.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 0/6] MSI portability cleanups
References: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
	<20070128.153707.30184351.davem@davemloft.net>
	<m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
	<20070128.212554.23015561.davem@davemloft.net>
Date: Sun, 28 Jan 2007 22:58:28 -0700
In-Reply-To: <20070128.212554.23015561.davem@davemloft.net> (David Miller's
	message of "Sun, 28 Jan 2007 21:25:54 -0800 (PST)")
Message-ID: <m1hcuaml17.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Sun, 28 Jan 2007 22:18:59 -0700
>
>> Regardless of my opinion on the sanity of the hypervisor architects.
>> I have not seen anything that indicates it will be hard to support
>> the hypervisor doing everything or most of everything for us, so
>> I see no valid technical objection to it.  Nor have I ever.
>> 
>> So I have no problem with additional patches in that direction.
>
> Ok, that's great to hear.
>
> I know your bi-directional approach isn't exactly what Ben
> wants but he can support his machines with it.  Maybe after
> some time we can agree to move from that more towards the
> totally abstracted scheme.

Moving farther has been my intention the entire time, even
while writing those patches.  I'm just not prepared to do it in
one giant patch where bug hunting becomes impossible.

I think I have moved msi.c to the point it won't be a horror to
work with, so we can start seriously looking at what it will
take to support hypervisors that do this.

I don't believe there is anything generic we can do in the general
hypervisor case, so we need a way for the architecture code in
the case where it is inappropriate to write directly to the msi
and msi-x registers to have a completely different implementation of:
pci_enable_msi, pci_disable_msi, pci_enable_msix, psi_disable_msix,
and whatever other driver interface bits we have in there.

One small step at a time and we should get there soon.

Eric

