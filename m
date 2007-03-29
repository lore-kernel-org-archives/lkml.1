Return-Path: <linux-kernel-owner+w=401wt.eu-S965949AbXC2EmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965949AbXC2EmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 00:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965955AbXC2EmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 00:42:20 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34904 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965949AbXC2EmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 00:42:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: michael@ellerman.id.au
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
Subject: Re: [PATCH 10/21] MSI: Add an arch_msi_supported()
References: <20070322105340.C6E43DDF66@ozlabs.org>
	<m1fy7psyjg.fsf@ebiederm.dsl.xmission.com>
	<1175141581.16660.24.camel@concordia.ozlabs.ibm.com>
Date: Wed, 28 Mar 2007 22:41:22 -0600
In-Reply-To: <1175141581.16660.24.camel@concordia.ozlabs.ibm.com> (Michael
	Ellerman's message of "Thu, 29 Mar 2007 14:13:01 +1000")
Message-ID: <m1mz1wmzkd.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> I agree with most of that. I thought of doing that change, but didn't
> want to have the powerpc code stuck behind a huge pile of driver
> changes.
>
> My only other worry is that at some point we'll get a driver that does
> want to choose the entries it's allocated, and at that point we'll have
> to put back the msix_entry code (or something similar). I don't have any
> idea of when/if that sort of hardware/driver requirement is likely to
> surface though, if it's "not for a while" it might be worth ripping out
> the complexity until we really need it.

Yes.

Allocating everything and just requesting the irqs you really want is
works as well.  So drivers like that would need to be common and the
savings significant before it would really be worthwhile to change
the API back the way it is now.

>> I was tempted to drop nvec as well since our irq numbers are virtual,
>> we could always delay the failure into request_irq.  But there are
>> a few embedded architectures like the arm where the number irqs
>> numbers may stay limited for a long time and if the driver will never
>> use all of the irqs we get to save some resources and some work.  So
>> that makes sense.
>
> I think nvec should stay.

Agreed.

>> So can we please at least move this patch down to the end with the
>> rest of the RTAS arch support?
>> 
>> Moving it towards the end will allow it to be reviewed in the context
>> where it will be used and it will give us a chance to simplify
>> pci_enable_msix before we get there.
>
> I'm happy to move it to the end of the series. I'm also happy to stop
> passing the msix_entry into the arch.
>
> But I don't want to predicate the merge of our powerpc stuff on the
> removal of msix_entry entirely, there's too much risk that we'll slip to
> v23.

Sure.   But if we can kill msix_entry in the same time frame it would
be a good thing.

Eric


