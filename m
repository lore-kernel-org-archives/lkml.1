Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbYJUQld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbYJUQld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYJUQl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:41:26 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:50037 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbYJUQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:41:25 -0400
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <874p36fflp.fsf@basil.nowhere.org>
References: <1224552902.2640.88.camel@alok-dev1>
	 <874p36fflp.fsf@basil.nowhere.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 21 Oct 2008 09:41:24 -0700
Message-Id: <1224607284.6161.22.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 02:43 -0700, Andi Kleen wrote:
> Alok Kataria <akataria@vmware.com> writes:
> 
> > This patch set makes some changes to the TSC code, so that it is always
> > used as the default clocksource when running under VMware.
> 
> Does this imply that vmware always emulates TSC reads?
> Or how do you guarantee reliable TSC on a system where the underlying
> TSC isn't?

Yes the hypervisor takes care of providing constant rate TSC to the
guest.

> 
> It would be far nicer if VMware just emulated the "constant_tsc" bit
> in the AMD CPUID leaf, instead of adding all that gunk to Linux.
> Right now it's only checked for AMD CPUs, but that could be changed.

I am not sure if we might want to skip the tsc_sync code for all the
cpus which have this constant_tsc bit set, can we ?
Since i have seen that we can have cases where tsc is marked unstable as
its not found to be perfectly stable between cpus, we have to make sure
that we avoid this check when on VMware. Even with slight difference in
TSC between cpus, we know that TSC is the best available clocksource as
the hypervisor (VMware) makes sure that the drift is always marginal (if
ever there is).

Thanks,
Alok

> 
> Otherwise with more and more hypervisors we mind end up with more
> and more unscalable detection code.
> 
> -Andi
> 
> --
> ak@linux.intel.com

