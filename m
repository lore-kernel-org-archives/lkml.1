Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXJZL3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXJZL3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbXJZL3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:29:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41189 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875AbXJZL3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:29:36 -0400
Date: Fri, 26 Oct 2007 12:31:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
 runtime service support
Message-ID: <20071026123128.4fbe9568@the-village.bc.nu>
In-Reply-To: <1193360591.23935.212.camel@caritas-dev.intel.com>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	<alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	<1193360591.23935.212.camel@caritas-dev.intel.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 09:03:11 +0800
"Huang, Ying" <ying.huang@intel.com> wrote:

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

The SYSV description is wrong as well. SYSV has no calling convention. I
think you mean iABI or iBCS2 ?

Whats wrong with following the pattern of other calls like syscall(...)
and just having eficall() ?

Alan.
