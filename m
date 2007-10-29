Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbXJ2BFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbXJ2BFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 21:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbXJ2BFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 21:05:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:7013 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbXJ2BF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 21:05:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,339,1188802800"; 
   d="scan'208";a="307365857"
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
	runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20071026123128.4fbe9568@the-village.bc.nu>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	 <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	 <1193360591.23935.212.camel@caritas-dev.intel.com>
	 <20071026123128.4fbe9568@the-village.bc.nu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Oct 2007 09:05:38 +0800
Message-Id: <1193619938.23935.303.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 29 Oct 2007 01:02:42.0118 (UTC) FILETIME=[686C6660:01C819C7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 12:31 +0100, Alan Cox wrote:
> On Fri, 26 Oct 2007 09:03:11 +0800
> "Huang, Ying" <ying.huang@intel.com> wrote:
> 
> > On Thu, 2007-10-25 at 18:09 +0200, Thomas Gleixner wrote:
> > > > EFI runtime
> > > > services initialization are implemented in efi.c. Some x86_64
> > > > specifics are worth noting here. On x86_64, parameters passed to UEFI
> > > > firmware services need to follow the UEFI calling convention. For this
> > > > purpose, a set of functions named lin2win<x> (<x> is the number of
> > > > parameters) are implemented. EFI function calls are wrapped before
> > > > calling the firmware service.
> > > 
> > > Why needs this to be called lin2win? We do not call Windows, we call
> > > EFI services, so please use a naming convention which is related to
> > > the functionality of the code.
> > > 
> > > > + *
> > > > + *  Function calling ABI conversion from SYSV to Windows for x86_64
> > > 
> > > Again, these are wrappers to access EFI and not Windows.
> > 
> > EFI uses the Windows x86_64 calling convention. The lin2win may be a
> > more general naming convention that can be used for some other code (the
> > NDISwrapper?) in the future. Do you agree?
> 
> The SYSV description is wrong as well. SYSV has no calling convention. I
> think you mean iABI or iBCS2 ?

The SYSV description comes from the following document:
http://www.x86-64.org/documentation/abi-0.98.pdf


> Whats wrong with following the pattern of other calls like syscall(...)
> and just having eficall() ?

Yes. This is better.

Best Regards,
Huang Ying
