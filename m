Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbXC1Gj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbXC1Gj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 02:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbXC1Gj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 02:39:58 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37568 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbXC1Gj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 02:39:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 13/21] MSI: Do MSI masking in the arch code
References: <20070322105342.B8317DDF6A@ozlabs.org>
Date: Wed, 28 Mar 2007 00:39:21 -0600
In-Reply-To: <20070322105342.B8317DDF6A@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:40 +1100")
Message-ID: <m1y7lhrhwm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> It's an arch detail whether MSI irqs need to be masked using the PCI
> MSI registers.

Agreed.  It isn't an arch detail that they need to be unmasked in
the pci configuration space.

I assume this patch is motivated just to make arch support easier
and not for RTAS compatibility reason.

> This changes behaviour in that previously we unconditionally masked
> all MSIs, eventhough we only ever enable one, whereas now we only
> mask the irqs we're using.
>
> To be super paranoid I have the archs mask the irq before they write
> the msi message, just in case the device doesn't respect the MSI enable
> bit or MSI is already enabled or something else crazy.
>
> For MSI-X this might mean we mask the already masked MSI-X on the device,
> but that should be harmless.

I don't think this patch really makes sense.  I think we should mask
all possible vectors for msi and msi-x initially in the generic code
and then unmask them.

If we were trying to support Dave Miller's example of hypervisors
that don't let us touch the msi registers I think there would be a
point.  As it is I think this just makes the code more brittle.

Eric
