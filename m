Return-Path: <linux-kernel-owner+w=401wt.eu-S1763971AbXF1MK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763971AbXF1MK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 08:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759308AbXF1MKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 08:10:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759045AbXF1MKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 08:10:17 -0400
Date: Thu, 28 Jun 2007 08:08:03 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Adrian Bunk <bunk@stusta.de>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm,
       Andi Kleen <ak@suse.de>, linux-arch@vger.kernel.org
Subject: Re: Userspace compiler support of "long long"
Message-ID: <20070628120803.GI7012@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de> <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de> <20070627173240.GR1094@stusta.de> <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com> <20070628035754.GB22063@parisc-linux.org> <6B8385EC-8CD4-4E8B-94EF-293A02A62189@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6B8385EC-8CD4-4E8B-94EF-293A02A62189@mac.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 07:53:51AM -0400, Kyle Moffett wrote:
> On Jun 27, 2007, at 23:57:54, Matthew Wilcox wrote:
> >On Wed, Jun 27, 2007 at 06:30:52PM -0400, Kyle Moffett wrote:
> >>Then all 64-bit archs have:
> >>typedef   signed long      __s64;
> >>typedef unsigned long      __u64;
> >>
> >>While all 32-bit archs have:
> >>typedef   signed long long __s64;
> >>typedef unsigned long long __u64;
> >
> >include/asm-parisc/types.h:typedef unsigned long long __u64;
> >
> >For both 32 and 64-bit.
> >
> >include/asm-sh64/types.h:typedef unsigned long long __u64;
> >include/asm-x86_64/types.h:typedef unsigned long long  __u64;
> >
> >So that's three architectures that violate your first assertion.
> 
> Oh, ok, that makes it even easier to say this with certainty:   
> Changing the other 64-bit archs to use "long long" for their 64-bit  
> numbers will not cause additional warnings.  I'm also almost certain  
> there are no architectures which use "long long" for 128-bit  
> integers. (Moreover, I can't find hardly anything which does 128-bit  
> integers at all).

unsigned long and unsigned long long have the same size, precision
and alignment on all LP64 arches, that's true.  But they have
different ranks and more importantly they mangle differently in C++.
So, whether some user exposed type uses unsigned long or unsigned long long
is part of the ABI, whether that's size_t, uintptr_t, uint64_t, u_int64_t
or any other type, you can't change it without breaking the ABI.

	Jakub
