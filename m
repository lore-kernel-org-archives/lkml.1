Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbXJZItS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbXJZItS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 04:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbXJZItL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 04:49:11 -0400
Received: from www.tglx.de ([62.245.132.106]:47171 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXJZItJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 04:49:09 -0400
Date: Fri, 26 Oct 2007 10:48:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Huang, Ying" <ying.huang@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
 runtime service support
In-Reply-To: <1193360591.23935.212.camel@caritas-dev.intel.com>
Message-ID: <alpine.LFD.0.9999.0710261027260.3186@localhost.localdomain>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>  <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain> <1193360591.23935.212.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Huang, Ying wrote:

> On Thu, 2007-10-25 at 18:09 +0200, Thomas Gleixner wrote:
> > > EFI runtime
> > > services initialization are implemented in efi.c. Some x86_64
> > > specifics are worth noting here. On x86_64, parameters passed to UEFI
> > > firmware services need to follow the UEFI calling convention. For this
> > > purpose, a set of functions named lin2win<x> (<x> is the number of
> > > parameters) are implemented. EFI function calls are wrapped before
> > > calling the firmware service.
> > 
> > Why needs this to be called lin2win? We do not call Windows, we call
> > EFI services, so please use a naming convention which is related to
> > the functionality of the code.
> > 
> > > + *
> > > + *  Function calling ABI conversion from SYSV to Windows for x86_64
> > 
> > Again, these are wrappers to access EFI and not Windows.
> 
> EFI uses the Windows x86_64 calling convention. The lin2win may be a
> more general naming convention that can be used for some other code (the
> NDISwrapper?) in the future. Do you agree?

I agree not at all. I do not care whether the EFI creators smoked the
Windows-crackpipe or some other hallucinogen when they decided to use
this calling convention. We definitely do not want to think about
NDISwrapper or any other Windows related hackery in the kernel.

I still do not understand why we need all this EFI hackery at all
aside of the possible usage for saving a crash dump on FLASH, which we
could do directly from the kernel as well.

    tglx
