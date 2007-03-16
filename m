Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbXCPDW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbXCPDW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 23:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXCPDW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 23:22:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53950 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbXCPDWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 23:22:55 -0400
Date: Fri, 16 Mar 2007 08:52:30 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Horms <horms@verge.net.au>, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, Ian Campbell <Ian.Campbell@xensource.com>
Subject: Re: [Fastboot] [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Message-ID: <20070316032230.GC10515@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <1173891609.8591.41.camel@localhost.localdomain> <20070315014635.GC28396@verge.net.au> <20070315045536.GA6766@in.ibm.com> <20070315050754.GB22329@verge.net.au> <20070315054726.GC6766@in.ibm.com> <1173961378.8591.63.camel@localhost.localdomain> <20070315132616.GH6766@in.ibm.com> <20070315234807.GB10861@verge.net.au> <aec7e5c30703151940x7447abbey80cb6e47250cca58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30703151940x7447abbey80cb6e47250cca58@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 11:40:07AM +0900, Magnus Damm wrote:
> On 3/16/07, Horms <horms@verge.net.au> wrote:
> >On Thu, Mar 15, 2007 at 06:56:16PM +0530, Vivek Goyal wrote:
> >> On Thu, Mar 15, 2007 at 12:22:57PM +0000, Ian Campbell wrote:
> >> > On Thu, 2007-03-15 at 11:17 +0530, Vivek Goyal wrote:
> >> > > > > But I think changing this macro might run into issues. It is
> >> > > > > being used at few places in kernel, for example while loading
> >> > > > > module. This will essentially mean that we allow loading 64bit
> >> > > > > x86_64 modules on 32bit i386 systems?
> >> >
> >> > Yes, not sure how I missed that fact...
> >> >
> >> > > Kexec will also not allow loading an x86_64 kernel on a 32bit 
> >machine.
> >> >
> >> > For crash kernel only or for regular kexec too?
> >> >
> >>
> >> I think for both. One of the possible reasons I think is that one never
> >> knows is underlying machine has got 64bit extensions or not. So even if
> >> we load the kernel it will never boot. Secondly, we might not be able to
> >> handle 64bit address in 32bit kernel/user space?
> >
> >Perhaps I am miss-understanding what you are saying, but I do
> >recally kexecing from 32->64 and 64->32 bit kernels on x86_64 hardware.
> >I can run these checks again if it helps.
> 

I stand corrected. I can kexec an bzImage 32->64bit. That's a different
thing that it ran into some initrd issues later but fundamentally kexec
could load 64bit kernel bzImage and do the successful transition.

So it will now be left to the user. If he tries to kexec to a 64bit kernel
on a machine not supporting 32bit extensions, then kexec will not give
any advance warning.

Thanks
Vivek
