Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752424AbYLRQeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbYLRQeZ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYLRQeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:34:15 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:40794 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYLRQeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:34:14 -0500
Subject: Re: [RFC Patch 1/9] Introducing generic hardware breakpoint handler
 interfaces
X-KeepSent: A914CE54:07AAD97A-80257523:005AEE9D;
 type=4; name=$KeepSent
To: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.0.2 August 07, 2008
Message-ID: <OFA914CE54.07AAD97A-ON80257523.005AEE9D-80257523.005B04E7@uk.ibm.com>
From: Richard J Moore <richardj_moore@uk.ibm.com>
Date: Thu, 18 Dec 2008 16:34:11 +0000
X-MIMETrack: Serialize by Router on D06ML065/06/M/IBM(Release 8.0.1|February 07, 2008) at
 18/12/2008 16:34:11
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"K.Prasad" <prasad@linux.vnet.ibm.com> wrote on 17/12/2008 03:47:03:

> [image removed]
>
> Re: [RFC Patch 1/9] Introducing generic hardware breakpoint handler
interfaces
>
> K.Prasad
>
> to:.
>
> David Daney
>
> 17/12/2008 03:47
>
> Cc:
>
> Linux Kernel Mailing List, Alan Stern, Roland McGrath, akpm, mingo,
> Richard J Moore>
>
> Please respond to prasad
>
> On Thu, Dec 04, 2008 at 11:38:17AM -0800, David Daney wrote:
> > K.Prasad wrote:
> > [...]
> >> + * len and type values are defined in include/asm/hw_breakpoint.h.
> >> + * Available values vary according to the architecture.  On i386 the
> >> + * possibilities are:
> >> + *
> >> + *   HW_BREAKPOINT_LEN_1
> >> + *   HW_BREAKPOINT_LEN_2
> >> + *   HW_BREAKPOINT_LEN_4
> >> + *   HW_BREAKPOINT_LEN_EXECUTE
> >> + *   HW_BREAKPOINT_RW
> >> + *   HW_BREAKPOINT_READ
> >> + *   HW_BREAKPOINT_EXECUTE
> >> + *
> >> + * On other architectures HW_BREAKPOINT_LEN_8 may be available, and
the
> >> + * 1-, 2-, and 4-byte lengths may be unavailable.  There also may be
> >> + * HW_BREAKPOINT_WRITE.  You can use #ifdef to check at compile time.
> >> + */
> >
> > On MIPS we support breakpoint lengths that are powers of 2 between 8
and
> > 4096.  Do you really want symbolic values for these?  The debuggers
have
> > to do calculations with the length values, so translating between the
> > symbolic values and numeric values would be tedious at best.
> >
> >
> > David Daney
>
> Given that the possible values for length are finite and small on
> x86(just three of them), it was chosen to be defined as constants.
>
> For architectures such as MIPS where a range of lengths can be possibly
> monitored using HW Breakpoints, the arch_validate_hwbkpt_settings()
> maybe suitably written to validate the input and the 'length' may also
> be specified in numeric terms to the kernel interface (say
> register_kernel_hw_breakpoint()).
>
> Thanks,
> K.Prasad
>

I think you need to cater for an arch-specific filter that validates the
appearance of breakpoint interrupt. On the System Z, for example, one
specifies a range using the pair of control registers, one for the start
and the other of the end. You might think that this limits you to having
only one contiguous range of addresses which generate a h/w bp interrupt.
Not so. We use an algorithm, which employes a wrapping range
(i.e start addr > end addr) and we continually resize the gap, whenever we
take a BP interrupt, to begin at the next valid BP. That way we avoid too
many erroneous interrupts and we also benignly filter the erroneous ones.

Other architectures that employ a variable range could do something
similar.
I'm thinking here of IA64 for example.

The other thing that occurs to me is whether you should also include
HW_BREAKPOINT_IO for completeness. Of course not everyone supports
breakpointing the I/O address space, but some do, so it ought to be catered

for.


Richard
zVM CP Development

