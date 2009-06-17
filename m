Return-Path: <linux-kernel-owner+w=401wt.eu-S1765858AbZFQM23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765858AbZFQM23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765097AbZFQM2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:28:18 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50920 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765567AbZFQM2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:28:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19000.57673.618229.523229@cargo.ozlabs.ibm.com>
Date: Wed, 17 Jun 2009 22:27:53 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: benh@kernel.crashing.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/6] perf_counter: tools: Makefile tweaks for 64-bit
	powerpc
In-Reply-To: <20090617120831.GB26454@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
	<19000.55666.866148.559620@cargo.ozlabs.ibm.com>
	<20090617120831.GB26454@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> ah, it does this:
> 
> /*
>  * This is here because we used to use l64 for 64bit powerpc
>  * and we don't want to impact user mode with our change to ll64
>  * in the kernel.
>  */
> #if defined(__powerpc64__) && !defined(__KERNEL__)
> # include <asm-generic/int-l64.h>
> #else
> # include <asm-generic/int-ll64.h>
> #endif
> 
> That's crappy really.

We were concerned that changing the userland-visible type of __u64
from unsigned long to unsigned long long, etc., would be breaking the
ABI, even if only in a small way - I thought it could possibly change
C++ mangled function names, for instance, and it would cause fresh
compile warnings on existing user code that prints __u64 with %lx,
which has always been the correct thing to do on ppc64.

A counter-argument would be, I guess, that __u64 et al. are purely for
use in describing the kernel/user interface, so we have a little more
latitude than with the type of e.g. u_int64_t.  I dunno.  I don't
recall getting much of an answer from the glibc guys about what they
thought of the idea of changing it.

Anyway, of the 64-bit architectures, alpha, ia64, and mips64 also have
__u64 as unsigned long in userspace, so this issue will still crop up
even if we change it on powerpc.

Paul.
