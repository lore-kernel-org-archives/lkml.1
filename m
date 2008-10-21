Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYJUTUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYJUTUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYJUTU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:20:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49658 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbYJUTU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:20:27 -0400
Date: Tue, 21 Oct 2008 21:27:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alok Kataria <akataria@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
Message-ID: <20081021192746.GJ12825@one.firstfloor.org>
References: <1224552902.2640.88.camel@alok-dev1> <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1> <20081021174008.GH12825@one.firstfloor.org> <1224612294.6161.43.camel@alok-dev1> <20081021181536.GI12825@one.firstfloor.org> <1224616236.6161.60.camel@alok-dev1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224616236.6161.60.camel@alok-dev1>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 12:10:36PM -0700, Alok Kataria wrote:
> On Tue, 2008-10-21 at 11:15 -0700, Andi Kleen wrote:
> > > FWIU from the code, even if  cpu A's TSC is just 1 tick behind that of
> > > cpu B, we increment the nr_wraps value.
> > > And the code expects that there are no wraps in TSC throughout the
> > > 20msec measurement window.
> > > So IMO its fairly easy to fail this test.
> > 
> > Ok I think it would be better to enlarge the margin then to fix your
> > issue.
> > 
> 
> Yeah, i thought about that, but given the different kinds of native
> hardware that we have i think coming up with values that would be safe
> for all the cases would be difficult. And given that nobody has
> complained about this on native until now, i would prefer not to change

It would certainly be the better solution (or trusting the CPUID bit)

Hypervisors are pretty popular these days and there are many different
flavours and if each of them adds their own detection code Linux will soon 
get very crowded. It's just a non scalable bad solution.

> the status quo. Apart from that, even on VMware virtualized environment
> there can different configurations where this margin keeps on varying,
> under different scenarios, f.e. under overcommitment and all. So i don't
> think that changing threshold values maybe safe for all cases. 

When the margin changes then it likely won't be good enough for
gettimeofday(). There are a couple of testers for monotonity around,
would such a system with shifting marging surive running them
for a few days?


> 
> I think going with ignoring this check for specific systems is the best
> way to go further. 

Disagree.


> I hope you also agree with the CONSTANT_TSC check.

Yes constant_tsc is good, although the question is how much sanity 
check is still needed. I suspect even with it some sanity check
will still make sense.

And the question is if your HV even sets the bit?
Also you would need to change the Linux code to check it on Intel too.

-Andi

-- 
ak@linux.intel.com
