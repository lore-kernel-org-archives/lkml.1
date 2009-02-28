Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbZB1Dha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbZB1Dha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 22:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZB1DhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 22:37:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752975AbZB1DhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 22:37:19 -0500
Date: Fri, 27 Feb 2009 19:36:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
In-Reply-To: <20090228030413.5B915FC3DA@magilla.sf.frob.com>
Message-ID: <alpine.LFD.2.00.0902271932520.3111@localhost.localdomain>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com> <20090228030413.5B915FC3DA@magilla.sf.frob.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Feb 2009, Roland McGrath wrote:
> --- a/arch/x86/include/asm/seccomp_64.h
> +++ b/arch/x86/include/asm/seccomp_64.h
> +/*
> + * This indicates we are inside a 32-bit system call (only testable
> + * synchronously by current), whereas TIF_IA32 indicates we are a 32-bit
> + * task.  A 32-bit task can make a 64-bit syscall by ljmp into 64-bit
> + * USER_CS, and a 64-bit task can make a 32-bit syscall by int $0x80.
> + */
> +#define IS_COMPAT_TASK	is_compat_task()
> +
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> +#if defined TIF_32BIT && !defined IS_COMPAT_TASK
> +# define IS_COMPAT_TASK	test_thread_flag(TIF_32BIT)
> +#endif
> +
> +#ifdef IS_COMPAT_TASK

Ok, please explain this madness.

The whole crazy IS_COMPAT_TASK dance seems to be too messy for words. Why? 
What's going on?

		Linus
