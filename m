Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXCPIuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXCPIuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXCPIuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:50:07 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:34268 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbXCPIuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:50:05 -0400
Subject: Re: [Fastboot] [PATCH 1/1] Allow i386 crash kernels to handle
	x86_64 dumps
From: Ian Campbell <Ian.Campbell@XenSource.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Horms <horms@verge.net.au>, Vivek Goyal <vgoyal@in.ibm.com>,
       fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <aec7e5c30703160059u108d984dt6bfb831603a887c5@mail.gmail.com>
References: <1173891609.8591.41.camel@localhost.localdomain>
	 <20070315014635.GC28396@verge.net.au> <20070315045536.GA6766@in.ibm.com>
	 <20070315050754.GB22329@verge.net.au> <20070315054726.GC6766@in.ibm.com>
	 <1173961378.8591.63.camel@localhost.localdomain>
	 <20070315132616.GH6766@in.ibm.com> <20070315234807.GB10861@verge.net.au>
	 <aec7e5c30703151940x7447abbey80cb6e47250cca58@mail.gmail.com>
	 <1174030097.28658.37.camel@localhost.localdomain>
	 <aec7e5c30703160059u108d984dt6bfb831603a887c5@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 08:50:01 +0000
Message-Id: <1174035001.28658.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2007 08:50:04.0753 (UTC) FILETIME=[175DAC10:01C767A8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 16:59 +0900, Magnus Damm wrote:
> On 3/16/07, Ian Campbell <Ian.Campbell@xensource.com> wrote:
> > On Fri, 2007-03-16 at 11:40 +0900, Magnus Damm wrote:
> > > Right. And maybe it's a good idea to make sure that this feature is
> > > actually supported by kexec-tools before adding code to the kernel?
> >
> > I sent patches to the fastboot list at the same time I sent these ones
> > to support differences in the underlying hypervisor architecture in the
> > tools.
> 
> Oh, that's good news. I have not seen them yet...
> 
> > They haven't appeared in the archives yet so I fear they have gone
> > astray. I'll resend when I get to the office in a bit.
> 
> ... so please resend.
> 
> We've just frozen the kexec-tools-testing tree for an upcoming
> release, but if you resend soon and your patches are trivial you may
> be able to talk us into merging your changes before the release..

Will resend in about an hour.

> > > My gut feeling about this is that you are begging for trouble. The
> > > kexec/kdump solution is fragile just by itself, and trying to go
> > > between architectures is just going to be painful.
> >
> > It works fine under Xen and I think going from 64Xen+32Kernel->32Kernel
> > makes more sense than going from 64Xen+32Kernel->64Kernel. As I said
> > originally I'm not so convinced it makes sense in the native case but I
> > see no reason to outlaw it (people get to keep both pieces etc...)
> 
> For kexec I think it is just fine. But for kdump, are you sure things
> will work out ok? There are some differences between the i386 and
> x86_64 kexec-tools code and I wonder if feeding i386 info into an
> x86_64 kernel will work properly.

It seems to work fine with Xen. A 32 bit kernel handles the 64 bit dump
just fine, my pre-kdump kernel is 32 bit but it doesn't have much to do
in this case I think.

I don't know about native. My gut feeling is that if the mechanism of
actually kexecing between 64 and 32 bit works then there is no problem
with the crash dump part of the equation.

The crash dump is pretty much opaque to the kernel -- it finds the
headers in memory and exports the relevant pieces via /proc/vmcore. The
crash kernel doesn't really care what those pieces are so long as they
constitute a valid ELF image.

My patch to kexec-tools-testing just changes e_machine to match the type
of the pre-crash system. The dump kernel pays no attention to this field
apart from the one sanity check which my patch from this thread
addresses.

>From userspace the contents of /proc/vmcore should be identical to what
you would see if you had done a 64->64 dump instead of a 64->32 one. I
don't think it is any different to copying /proc/vmcore to a different
system for analysis so any userspace tools should be able to cope.

Ian.

