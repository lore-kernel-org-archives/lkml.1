Return-Path: <linux-kernel-owner+w=401wt.eu-S932706AbXCPJfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbXCPJfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932991AbXCPJfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:35:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58167 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706AbXCPJfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:35:44 -0400
Date: Fri, 16 Mar 2007 15:05:42 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Ian Campbell <Ian.Campbell@xensource.com>, Horms <horms@verge.net.au>,
       fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [Fastboot] [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Message-ID: <20070316093542.GB5642@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070315050754.GB22329@verge.net.au> <20070315054726.GC6766@in.ibm.com> <1173961378.8591.63.camel@localhost.localdomain> <20070315132616.GH6766@in.ibm.com> <20070315234807.GB10861@verge.net.au> <aec7e5c30703151940x7447abbey80cb6e47250cca58@mail.gmail.com> <1174030097.28658.37.camel@localhost.localdomain> <aec7e5c30703160059u108d984dt6bfb831603a887c5@mail.gmail.com> <1174035001.28658.61.camel@localhost.localdomain> <aec7e5c30703160220i3e8a03cbh431622975acbe72d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30703160220i3e8a03cbh431622975acbe72d@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 06:20:14PM +0900, Magnus Damm wrote:
> On 3/16/07, Ian Campbell <Ian.Campbell@xensource.com> wrote:
> >On Fri, 2007-03-16 at 16:59 +0900, Magnus Damm wrote:
> >> On 3/16/07, Ian Campbell <Ian.Campbell@xensource.com> wrote:
> >> > On Fri, 2007-03-16 at 11:40 +0900, Magnus Damm wrote:
> >> > > Right. And maybe it's a good idea to make sure that this feature is
> >> > > actually supported by kexec-tools before adding code to the kernel?
> >> >
> >> > I sent patches to the fastboot list at the same time I sent these ones
> >> > to support differences in the underlying hypervisor architecture in the
> >> > tools.
> >>
> >> Oh, that's good news. I have not seen them yet...
> >>
> >> > They haven't appeared in the archives yet so I fear they have gone
> >> > astray. I'll resend when I get to the office in a bit.
> >>
> >> ... so please resend.
> >>
> >> We've just frozen the kexec-tools-testing tree for an upcoming
> >> release, but if you resend soon and your patches are trivial you may
> >> be able to talk us into merging your changes before the release..
> >
> >Will resend in about an hour.
> >
> >> > > My gut feeling about this is that you are begging for trouble. The
> >> > > kexec/kdump solution is fragile just by itself, and trying to go
> >> > > between architectures is just going to be painful.
> >> >
> >> > It works fine under Xen and I think going from 64Xen+32Kernel->32Kernel
> >> > makes more sense than going from 64Xen+32Kernel->64Kernel. As I said
> >> > originally I'm not so convinced it makes sense in the native case but I
> >> > see no reason to outlaw it (people get to keep both pieces etc...)
> >>
> >> For kexec I think it is just fine. But for kdump, are you sure things
> >> will work out ok? There are some differences between the i386 and
> >> x86_64 kexec-tools code and I wonder if feeding i386 info into an
> >> x86_64 kernel will work properly.
> >
> >It seems to work fine with Xen. A 32 bit kernel handles the 64 bit dump
> >just fine, my pre-kdump kernel is 32 bit but it doesn't have much to do
> >in this case I think.
> >
> >I don't know about native. My gut feeling is that if the mechanism of
> >actually kexecing between 64 and 32 bit works then there is no problem
> >with the crash dump part of the equation.
> >
> >The crash dump is pretty much opaque to the kernel -- it finds the
> >headers in memory and exports the relevant pieces via /proc/vmcore. The
> >crash kernel doesn't really care what those pieces are so long as they
> >constitute a valid ELF image.
> 
> Right, that's how it is supposed to work. But there are unfortunately
> differences between the architecture-specific implementations in the
> kexec-tools code. So the x86_64 version of kexec-tools behaves
> different compared to the i386 version.
> 
> For instance, x86_64 passes some acpi parameter on the command line to
> the crash kernel, but i386 does not. This may or may not be needed.
> There are differences like that or smaller sprinkled all over the
> place.

I think passing those acpi parameter to 32bit kernel should not harm.

Got a question. When running 32bit dom0 on 64bit hypervisor, which
kexec-tools elf loader will kick in? 32bit or 64bit? Looks like in this
case 64bit one. But shouldn't it be 32bit as 32bit OS is running and we
must be using the kexec-tools binary compiled for 32bit OS? And if 32bit
loader kicks in we will not be passing any acpi parameters.

Thanks
Vivek
