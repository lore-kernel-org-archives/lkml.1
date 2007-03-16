Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbXCPJUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbXCPJUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbXCPJUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:20:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:53700 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbXCPJUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OzgslSh/MtKriiXku1eIQy+y5oMDOmxKrSOSc1MUmMnzSCJpM7wHUYTLe68c7axY7CS3pWZN6wf73ECKJJpAUBxcugr5RqKNV+TU5asSg9ObhjGkFoh3iFIFARZYWIsulpYsxuQthYnf7ZeChMJMV72azfCJg112AvtSRrK4nlo=
Message-ID: <aec7e5c30703160220i3e8a03cbh431622975acbe72d@mail.gmail.com>
Date: Fri, 16 Mar 2007 18:20:14 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Ian Campbell" <Ian.Campbell@xensource.com>
Subject: Re: [Fastboot] [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Cc: Horms <horms@verge.net.au>, "Vivek Goyal" <vgoyal@in.ibm.com>,
       fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1174035001.28658.61.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1173891609.8591.41.camel@localhost.localdomain>
	 <20070315050754.GB22329@verge.net.au>
	 <20070315054726.GC6766@in.ibm.com>
	 <1173961378.8591.63.camel@localhost.localdomain>
	 <20070315132616.GH6766@in.ibm.com>
	 <20070315234807.GB10861@verge.net.au>
	 <aec7e5c30703151940x7447abbey80cb6e47250cca58@mail.gmail.com>
	 <1174030097.28658.37.camel@localhost.localdomain>
	 <aec7e5c30703160059u108d984dt6bfb831603a887c5@mail.gmail.com>
	 <1174035001.28658.61.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Ian Campbell <Ian.Campbell@xensource.com> wrote:
> On Fri, 2007-03-16 at 16:59 +0900, Magnus Damm wrote:
> > On 3/16/07, Ian Campbell <Ian.Campbell@xensource.com> wrote:
> > > On Fri, 2007-03-16 at 11:40 +0900, Magnus Damm wrote:
> > > > Right. And maybe it's a good idea to make sure that this feature is
> > > > actually supported by kexec-tools before adding code to the kernel?
> > >
> > > I sent patches to the fastboot list at the same time I sent these ones
> > > to support differences in the underlying hypervisor architecture in the
> > > tools.
> >
> > Oh, that's good news. I have not seen them yet...
> >
> > > They haven't appeared in the archives yet so I fear they have gone
> > > astray. I'll resend when I get to the office in a bit.
> >
> > ... so please resend.
> >
> > We've just frozen the kexec-tools-testing tree for an upcoming
> > release, but if you resend soon and your patches are trivial you may
> > be able to talk us into merging your changes before the release..
>
> Will resend in about an hour.
>
> > > > My gut feeling about this is that you are begging for trouble. The
> > > > kexec/kdump solution is fragile just by itself, and trying to go
> > > > between architectures is just going to be painful.
> > >
> > > It works fine under Xen and I think going from 64Xen+32Kernel->32Kernel
> > > makes more sense than going from 64Xen+32Kernel->64Kernel. As I said
> > > originally I'm not so convinced it makes sense in the native case but I
> > > see no reason to outlaw it (people get to keep both pieces etc...)
> >
> > For kexec I think it is just fine. But for kdump, are you sure things
> > will work out ok? There are some differences between the i386 and
> > x86_64 kexec-tools code and I wonder if feeding i386 info into an
> > x86_64 kernel will work properly.
>
> It seems to work fine with Xen. A 32 bit kernel handles the 64 bit dump
> just fine, my pre-kdump kernel is 32 bit but it doesn't have much to do
> in this case I think.
>
> I don't know about native. My gut feeling is that if the mechanism of
> actually kexecing between 64 and 32 bit works then there is no problem
> with the crash dump part of the equation.
>
> The crash dump is pretty much opaque to the kernel -- it finds the
> headers in memory and exports the relevant pieces via /proc/vmcore. The
> crash kernel doesn't really care what those pieces are so long as they
> constitute a valid ELF image.

Right, that's how it is supposed to work. But there are unfortunately
differences between the architecture-specific implementations in the
kexec-tools code. So the x86_64 version of kexec-tools behaves
different compared to the i386 version.

For instance, x86_64 passes some acpi parameter on the command line to
the crash kernel, but i386 does not. This may or may not be needed.
There are differences like that or smaller sprinkled all over the
place.

/ magnus
