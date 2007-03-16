Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbXCPCkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbXCPCkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 22:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXCPCkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 22:40:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:59191 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbXCPCkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 22:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rQa71NtSjDImxrVCOmp7wDKkcYaVbLbAXsdlZPLqRcMdsJCi/lWhHLM/gJTa5SxhQKWlMwh97ciIllMh4UyBpzPb3ctST9wyG1NEMmX9pcDzkXt5EQ5rM+ePpyfkK/mBo6m5jdQ+HXtDK51brnYEQZbkyyopVqOgyMGngE5Twtw=
Message-ID: <aec7e5c30703151940x7447abbey80cb6e47250cca58@mail.gmail.com>
Date: Fri, 16 Mar 2007 11:40:07 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: Horms <horms@verge.net.au>
Subject: Re: [Fastboot] [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Cc: "Vivek Goyal" <vgoyal@in.ibm.com>, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org,
       "Ian Campbell" <Ian.Campbell@xensource.com>
In-Reply-To: <20070315234807.GB10861@verge.net.au>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Horms <horms@verge.net.au> wrote:
> On Thu, Mar 15, 2007 at 06:56:16PM +0530, Vivek Goyal wrote:
> > On Thu, Mar 15, 2007 at 12:22:57PM +0000, Ian Campbell wrote:
> > > On Thu, 2007-03-15 at 11:17 +0530, Vivek Goyal wrote:
> > > > > > But I think changing this macro might run into issues. It is
> > > > > > being used at few places in kernel, for example while loading
> > > > > > module. This will essentially mean that we allow loading 64bit
> > > > > > x86_64 modules on 32bit i386 systems?
> > >
> > > Yes, not sure how I missed that fact...
> > >
> > > > Kexec will also not allow loading an x86_64 kernel on a 32bit machine.
> > >
> > > For crash kernel only or for regular kexec too?
> > >
> >
> > I think for both. One of the possible reasons I think is that one never
> > knows is underlying machine has got 64bit extensions or not. So even if
> > we load the kernel it will never boot. Secondly, we might not be able to
> > handle 64bit address in 32bit kernel/user space?
>
> Perhaps I am miss-understanding what you are saying, but I do
> recally kexecing from 32->64 and 64->32 bit kernels on x86_64 hardware.
> I can run these checks again if it helps.

I recall kexecing a bzImage for x86_64 on i386, but I'm not 100% sure.
I think it worked because the bzImage loader code was regular 32 bit
x86 code, but that may be wrong as well.

> Won't the above change break non i386 archtectures as
> vmcore_elf_check_arch_cross isn't defined for them?

Right. And maybe it's a good idea to make sure that this feature is
actually supported by kexec-tools before adding code to the kernel?

My gut feeling about this is that you are begging for trouble. The
kexec/kdump solution is fragile just by itself, and trying to go
between architectures is just going to be painful.

/ magnus
