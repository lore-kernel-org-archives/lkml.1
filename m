Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbXKYWWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbXKYWWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXKYWWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:22:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34910 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbXKYWWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:22:34 -0500
Date: Sun, 25 Nov 2007 22:22:05 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/27] ptrace: arch_has_single_step
Message-ID: <20071125222205.GA1597@infradead.org>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071125215507.4B89226F8C5@magilla.localdomain>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2007 at 01:55:07PM -0800, Roland McGrath wrote:
> This defines the new macro arch_has_single_step() in linux/ptrace.h, a
> default for when asm/ptrace.h does not define it.  It declares the new
> user_enable_single_step and user_disable_single_step functions.
> This is not used yet, but paves the way to harmonize on this interface
> for the arch-specific calls on all machines.

Why should arch_has_single_step be a function-like macro?  I can't thing
of a case were this wouln't be a compile-time constant.  And given that
this is hopefully a transitionary ifdef because eventually all architectures
would use the generic code I'd prefer ifdefs in the code that clearly mark
this as transitional in this case.

> +static inline void user_enable_single_step(struct task_struct *task)

> +static inline void user_disable_single_step(struct task_struct *task)

And I don't think these should be provided at all as generic stubs. If
an arch doesn't use the generic code it simply shouldn't compile the
code using this.

Whats the reason for the user_ prefix btw, most architectures seems to
have these functions already anyway, just without the user_ prefix.

