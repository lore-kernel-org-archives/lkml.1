Return-Path: <linux-kernel-owner+w=401wt.eu-S1751647AbXC1FVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbXC1FVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 01:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbXC1FVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 01:21:06 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47082 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbXC1FVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 01:21:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: michael@ellerman.id.au
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
Subject: Re: [PATCH 9/21] MSI: Expand pci_msi_supported()
References: <20070322105340.53827DDF65@ozlabs.org>
	<m1slbqrn70.fsf@ebiederm.dsl.xmission.com>
	<1175058070.6386.12.camel@concordia.ozlabs.ibm.com>
Date: Tue, 27 Mar 2007 23:20:32 -0600
In-Reply-To: <1175058070.6386.12.camel@concordia.ozlabs.ibm.com> (Michael
	Ellerman's message of "Wed, 28 Mar 2007 15:01:10 +1000")
Message-ID: <m1odmerljz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> I don't think it's that confusing. I agree it was a bit weird that
> previously it was explicitly checking for < 0, so I fixed that.

The previous case was clearer.  This isn't a please do some work
for me function, where we expect occasional failure and we need
to return an error code when there are different types.

There is only one time of failure here, that we don't support MSI
on this device.

>> After this patch we are simply checking to see if there was a
>> return value at all.
>> 
>> Can we please change the return value here so it is actually boolean.
>> 1 for supported 0 for not supported.
>> 
>> There aren't any useful return values anyway so this would just make
>> the code easier to read and maintain.
>
> There aren't any useful return values as it's currently written, but
> there code be. And I'd like to keep that possibility.
>
> My next patch allows the arch routine to propagate its return value out
> to the caller, which is useful.
>
> And I don't think making it return 0/1 makes it any clearer. As it is
> now it's just:
>
> If MSI is supported we return 0.
> If MSI is not supported we return some error code which is != 0.
>
> The caller just does:
>
> if (pci_msi_supported(blah ..))
> 	error;

Exactly.  Which just reading through is non-obvious.

if (supported())
   fail();

Where if we said
if (!supported())
   fail();

The code would be clearer.

> Which is exactly the same whether it's 0/1 or 0/<error code>. And we
> have the option of returning a useful return value.

But the callers all ignore so it still isn't useful, and I'm not 
at all certain it makes any sense for it to be useful.

Eric
