Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbXCPH7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbXCPH7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbXCPH7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:59:44 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:32638 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbXCPH7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:59:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bjVc2lUmTBRzMPHaZ3cAO1AWLplqtuNy2zXTv0ECpdmNT1rJKB5g2VRn73Oa7MWm612R8DZ+uS+1RoD+VM0HjHIQpYEuyajtUsZ8pnmLqG5vTLjKdxnTEUIZiUNF4550lvpaH+ULTA8hbJF2z3zGLwZBBgxSuiheWT+uDr71/NY=
Message-ID: <aec7e5c30703160059u108d984dt6bfb831603a887c5@mail.gmail.com>
Date: Fri, 16 Mar 2007 16:59:42 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Ian Campbell" <Ian.Campbell@xensource.com>
Subject: Re: [Fastboot] [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Cc: Horms <horms@verge.net.au>, "Vivek Goyal" <vgoyal@in.ibm.com>,
       fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1174030097.28658.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1173891609.8591.41.camel@localhost.localdomain>
	 <20070315014635.GC28396@verge.net.au>
	 <20070315045536.GA6766@in.ibm.com>
	 <20070315050754.GB22329@verge.net.au>
	 <20070315054726.GC6766@in.ibm.com>
	 <1173961378.8591.63.camel@localhost.localdomain>
	 <20070315132616.GH6766@in.ibm.com>
	 <20070315234807.GB10861@verge.net.au>
	 <aec7e5c30703151940x7447abbey80cb6e47250cca58@mail.gmail.com>
	 <1174030097.28658.37.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Ian Campbell <Ian.Campbell@xensource.com> wrote:
> On Fri, 2007-03-16 at 11:40 +0900, Magnus Damm wrote:
> > Right. And maybe it's a good idea to make sure that this feature is
> > actually supported by kexec-tools before adding code to the kernel?
>
> I sent patches to the fastboot list at the same time I sent these ones
> to support differences in the underlying hypervisor architecture in the
> tools.

Oh, that's good news. I have not seen them yet...

> They haven't appeared in the archives yet so I fear they have gone
> astray. I'll resend when I get to the office in a bit.

... so please resend.

We've just frozen the kexec-tools-testing tree for an upcoming
release, but if you resend soon and your patches are trivial you may
be able to talk us into merging your changes before the release..

> The tools already have support for introducing a SHIM when kexecing
> between different architectures (at least in the 64->32 direction if I
> understand kexec-tools-testing/purgatory/arch/i386/compat_x86_64.S and
> k-t-t.../kexec/arch/i386/compat_x86_64.S correctly). This is really just
> an extension of that.

Right, the mode switching code in purgatory.

> > My gut feeling about this is that you are begging for trouble. The
> > kexec/kdump solution is fragile just by itself, and trying to go
> > between architectures is just going to be painful.
>
> It works fine under Xen and I think going from 64Xen+32Kernel->32Kernel
> makes more sense than going from 64Xen+32Kernel->64Kernel. As I said
> originally I'm not so convinced it makes sense in the native case but I
> see no reason to outlaw it (people get to keep both pieces etc...)

For kexec I think it is just fine. But for kdump, are you sure things
will work out ok? There are some differences between the i386 and
x86_64 kexec-tools code and I wonder if feeding i386 info into an
x86_64 kernel will work properly.

Thanks!

/ magnus
