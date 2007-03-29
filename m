Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbXC2NcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbXC2NcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 09:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbXC2NcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 09:32:21 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47675 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbXC2NcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 09:32:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: michael@ellerman.id.au
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
Subject: Re: [PATCH 13/21] MSI: Do MSI masking in the arch code
References: <20070322105342.B8317DDF6A@ozlabs.org>
	<m1y7lhrhwm.fsf@ebiederm.dsl.xmission.com>
	<1175158720.16660.69.camel@concordia.ozlabs.ibm.com>
Date: Thu, 29 Mar 2007 07:31:09 -0600
In-Reply-To: <1175158720.16660.69.camel@concordia.ozlabs.ibm.com> (Michael
	Ellerman's message of "Thu, 29 Mar 2007 18:58:40 +1000")
Message-ID: <m18xdgkwgy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

>
> The main motivation was to have the arch in control of as much direct
> register writing as possible. Even though our HV does allow us to write
> to config space, it's not obviously safe for Linux to be flipping bits
> and also calling the HV to configure things. What's worse, I don't have
> hardware that supports the mask bits, so I can't test it.

I agree that there are limits here, on what we can feed into a hypervisor
and not confuse it.  Mostly my thinking is to assume someone has been
scribbling with the msi capability before we got there  and to place
everything in a know good state and not assume that device reset has
already done the work for us.  Since we aren't the pci  device reset
we can choose the defaults that make sense for us.

Worse case we can just put the capability in the state that pci device
reset would have put it in.

> I also thought this would save me from having custom MSI irq_chips for
> the powerpc backends. But I think I need them now anyway, so I guess
> that's not a concern.

Well we could still do the basic setup in arch_setup_msi_irq so I don't think
it has ever been an irq_chips style operations.

> So I guess we'll drop this one, although I might try and tidy up the
> implementation of "mask all MSIs" in msi_capability_init() as another
> patch.

I have no problem with that.  The msix version of this still needs
to be written as well.

Eric
