Return-Path: <linux-kernel-owner+w=401wt.eu-S932706AbXHVXBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbXHVXBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761614AbXHVXBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:01:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761587AbXHVXA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:00:59 -0400
Date: Wed, 22 Aug 2007 15:58:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jakub Jelinek <jakub@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, Kees Cook <kees@outflux.net>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] i386 and x86_64: randomize brk()
Message-Id: <20070822155833.5142e588.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708221750340.7792@jikos.suse.cz>
References: <Pine.LNX.4.64.0708221750340.7792@jikos.suse.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 18:05:01 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> From: Jiri Kosina <jkosina@suse.cz>
> 
> i386 and x86_64: randomize brk()
> 
> This patch randomizes the location of the heap (brk) for i386 and x86_64. 
> The range is randomized in the range starting at current brk location up 
> to 0x02000000 offset on both architectures. This, together with 
> pie-executable-randomization.patch and 
> pie-executable-randomization-fix.patch, should make the address space 
> randomization on i386 and x86_64 complete (modulo vDSO randomization).
> 
> The code is based on execshield code written by Ingo Molnar.

My main concern right now is to try to stabilise the rc3-mm1 mess, so I
think I'll duck this for now.  

> +#ifdef ARCH_HAS_RANDOMIZE_BRK
> +	if (current->flags & PF_RANDOMIZE)
> +		arch_randomize_brk();
> +#endif

erk, please no.

It'd be better to put

static inline void arch_randomize_brk(void)
{
}

into all the other architecture's elf.h, then lose all the ifdefs.


