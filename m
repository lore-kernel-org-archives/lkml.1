Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbYJXTua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbYJXTua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYJXTuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:50:13 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:45051 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbYJXTuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:50:11 -0400
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
	set.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <20081024193414.GH27492@one.firstfloor.org>
References: <1224728478.13953.79.camel@alok-dev1>
	 <20081023081052.GI27492@one.firstfloor.org>
	 <1224805162.21776.45.camel@alok-dev1> <49010D1E.8070400@zytor.com>
	 <20081024002511.GC27492@one.firstfloor.org> <49011AD7.7000901@zytor.com>
	 <20081024072320.GE27492@one.firstfloor.org> <4901EA14.9070300@zytor.com>
	 <20081024192532.GG27492@one.firstfloor.org> <49021FCD.8080209@zytor.com>
	 <20081024193414.GH27492@one.firstfloor.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 24 Oct 2008 12:50:10 -0700
Message-Id: <1224877810.28224.18.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 12:34 -0700, Andi Kleen wrote:
> On Fri, Oct 24, 2008 at 12:19:41PM -0700, H. Peter Anvin wrote:
> > Andi Kleen wrote:
> > >
> > >In the field they will just continue using clock=pit, like they
> > >always did on vmware. And also they will not update the Linux kernel.
> > >
> >
> > That is a totally bogus assumption.  You will typically have the host
> > platform (Vmware in this case) move much much slower than the guests.
> 
> The people running on older hypervisors will just continue using
> PIT timer. They won't get nohz, but i guess without updates
> they don't expect new features.

As hpa rightly said, people could still upgrade the kernel and not the
hypervisor and would expect things to work correctly.
So this is just about making sure that the new features in kernel which
are on by default don't break when we run on older products.
> 
> > >This is strictly for new installations. And I frankly don't
> > >see why Linux needs to get white listed workarounds when the
> > >Hypervisor couldn't as well be fixed. We have the bizarre
> > >situation here where a HV vendor tries to add workarounds
> > >to Linux instead of fixing it on their products.
> >
> > ... just like every other hardware vendor.
> 
> Hardware vendors can't fix it without long lead time.
> Software vendors can as easily as Linux.
> 
> Also we're talking about an optimization here (enabling NOHZ), not a
> correctness issue. So your analogy to hardware workarounds
> is already dubious.

Its not like we are trying to add VMware checks all over the kernel to
enhance the performance or something of that sought.  Its just about the
timer emulation which needs to be tweaked a little. 

Also i think you would agree that fixing timer related issues like the
acpi_pm thing are inherently difficult to fix on virtualized hardware
without the kernel cooperating. The constraints here are different since
the physical cpu can be time shared btween vcpu's, which can break a lot
of assumptions related to timing. I like, hpa's approach of using cpuid
bits (synthetic/real) to get these things communicated to the kernel so
that things are consistent with  how the OS communicates with the
hardware.

Another thing that I may like to highlight is that, with the advent of
hardware assisted virtualization, the kernel should be able to
virtualize the processor, without requiring any major changes for para
virtualizing the cpu.  And thats the approach we will like to take as
well, i.e. communicate most of the things to the kernel using standard
communication methods like CPUid/MSR's. And i think this is just a step
towards that. 

So in short we should view virtualization platform as just a special
hardware as far as the kernel is concerned.

Thanks,
Alok

> 
> -Andi
> --
> ak@linux.intel.com

