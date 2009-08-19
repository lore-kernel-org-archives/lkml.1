Return-Path: <linux-kernel-owner+w=401wt.eu-S1751404AbZHSJHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbZHSJHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZHSJHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:07:04 -0400
Received: from www.tglx.de ([62.245.132.106]:38490 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbZHSJHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:07:03 -0400
Date: Wed, 19 Aug 2009 11:06:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Beulich <JBeulich@novell.com>
cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: make use of inc/dec conditional
In-Reply-To: <4A8BDB51020000780001086E@vpn.id2.novell.com>
Message-ID: <alpine.LFD.2.00.0908191105260.3361@localhost.localdomain>
References: <4A8BCA850200007800010836@vpn.id2.novell.com> <1250668860.7583.327.camel@twins> <4A8BDB51020000780001086E@vpn.id2.novell.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009, Jan Beulich wrote:
> >>> Peter Zijlstra <peterz@infradead.org> 19.08.09 10:01 >>>
> >On Wed, 2009-08-19 at 08:48 +0100, Jan Beulich wrote:
> >> According to gcc's instruction selection, inc/dec can be used without
> >> penalty on most CPU models, but should be avoided on others. Hence we
> >> should have a config option controlling the use of inc/dec, and
> >> respective abstraction macros to avoid making the resulting code too
> >> ugly. There are a few instances of inc/dec that must be retained in
> >> assembly code, due to that code's dependency on the instruction not
> >> changing the carry flag.
> >> 
> >> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> >> 
> >> ---
> >>  arch/x86/Kconfig.cpu                |    4 ++++
> >>  arch/x86/include/asm/asm.h          |   27 +++++++++++++++++++++++++++
> >>  arch/x86/include/asm/atomic_32.h    |    8 ++++----
> >>  arch/x86/include/asm/atomic_64.h    |   16 ++++++++--------
> >>  arch/x86/include/asm/checksum_32.h  |    2 +-
> >>  arch/x86/include/asm/spinlock.h     |    6 +++---
> >>  arch/x86/lib/checksum_32.S          |   11 ++++++-----
> >>  arch/x86/lib/clear_page_64.S        |    3 ++-
> >>  arch/x86/lib/copy_page_64.S         |    5 +++--
> >>  arch/x86/lib/copy_user_64.S         |   17 +++++++++--------
> >>  arch/x86/lib/copy_user_nocache_64.S |   17 +++++++++--------
> >>  arch/x86/lib/memcpy_64.S            |   11 ++++++-----
> >>  arch/x86/lib/memset_64.S            |    7 ++++---
> >>  arch/x86/lib/rwlock_64.S            |    5 +++--
> >>  arch/x86/lib/semaphore_32.S         |    7 ++++---
> >>  arch/x86/lib/string_32.c            |   23 ++++++++++++-----------
> >>  arch/x86/lib/strstr_32.c            |    5 +++--
> >>  17 files changed, 108 insertions(+), 66 deletions(-)
> >
> >What's the performance gain? This seems like a rather large and ugly
> >patch if the result is borderline.
> 
> The performance gain isn't very significant, but if the compiler cares to
> avoid/use certain instructions on certain CPU models, the kernel shouldn't
> artificially introduce uses of those instructions.
> 
> And while the patch is maybe large, I don't think the resulting code is
> significantly more ugly than it already was (if it was). I'd consider
> removing the .S/.c changes, though, but I think the inline assembly
> changes to headers should go in at least.

You still do not tell on which machines the INC/DEC instructions
should be avoided and why. GCC avoiding it is not a convincing
argument.

Thanks,

	tglx
