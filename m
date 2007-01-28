Return-Path: <linux-kernel-owner+w=401wt.eu-S932815AbXA1UY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbXA1UY2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 15:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932834AbXA1UY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 15:24:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:56105 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815AbXA1UY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 15:24:27 -0500
Subject: Re: [PATCH 0/6] MSI portability cleanups
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
       linuxppc-dev@ozlabs.org, Brice Goglin <brice@myri.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
References: <1169714047.65693.647693675533.qpush@cradle>
	 <m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 07:23:25 +1100
Message-Id: <1170015805.26655.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The other big change is that I added a field to irq_desc to point
> at the msi_desc.  This removes the conflicts with the existing pointer
> fields and makes the irq -> msi_desc mapping useable outside of msi.c

I'm not even sure we would have needed that with Michael's mecanism in
fact. One other reason why I prefer it.

Basically, backends like MPIC etc... don't need it. The irq chip
operations are normal MPIC operations and don't need to know they are
done on an MSI nor what MSI etc... and thus we don't need it. Same with
RTAS.

On the other hand, x86 needs it, but then, x86 uses it's own MSI
specific irq_chip, in which case it can use irq_desc->chip_data as long
as it does it within the backend.

So I may have missed a case where a given backend might need both that
irq -> msi_desc mapping -and- use irq_desc->chip_data for other things,
but that's one thing I was hoping we could avoid with Michael's code.

> The only architecture problem that isn't solvable in this context is
> the problem of supporting the crazy hypervisor on the ppc RTAS, which
> asks us to drive the hardware but does not give us access to the
> hardware registers.

So you are saying that we should use your model while admitting that it
can't solve our problems...

I really don't understand why you seem so totally opposed to Michael's
approach which definitely looks to me like the sane thing to do. Note
that in the end, Michael's approach isn't -that- different from yours,
just a bit more abstracted.

Ben.


