Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbYBJJbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbYBJJbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYBJJbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:31:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40969 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYBJJba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:31:30 -0500
Date: Sun, 10 Feb 2008 04:31:28 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210093128.GA11350@infradead.org>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org> <20080210080225.GC7188@elte.hu> <20080210082132.GA9878@elte.hu> <20080210082624.GB10479@infradead.org> <20080210090817.GA15409@elte.hu> <20080210091757.GA17341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210091757.GA17341@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef UART_CAP_UUE
> +	if (up->capabilities & UART_CAP_UUE)
> +#else
> +	if (up->port.type == PORT_XSCALE)
> +#endif

This looks very odd.  Can anyone explain what's going on here?
Especially as UART_CAP_UUE is defined in drivers/serial/8250.h
unconditionally.

> diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
> new file mode 100644
> index 0000000..5079d32
> --- /dev/null
> +++ b/drivers/serial/kgdboc.c
> @@ -0,0 +1,164 @@
> +/*
> + * drivers/serial/kgdboc.c

Didn't you say there was no file left with these?

> diff --git a/include/asm-generic/kgdb.h b/include/asm-generic/kgdb.h
> new file mode 100644
> index 0000000..115972e
> --- /dev/null
> +++ b/include/asm-generic/kgdb.h

Didn't you agree to kill this file in one of the last mails?

> +#ifndef __ASSEMBLY__
> +static inline void arch_kgdb_breakpoint(void)
> +{
> +	asm("   int $3");
> +}
> +# define BREAK_INSTR_SIZE	1
> +# define CACHE_FLUSH_IS_SAFE	1
> +#endif

this ifdef should go away.

> +#endif				/* _ASM_KGDB_H_ */
> +#endif				/* __KERNEL__ */

and the __KERNEL__ aswell as these files are in no way exported
to userspace.

> +/*
> + *	kgdb_get_shadow_thread - Get the shadowed &task_struct of @threadid.
> + *	@regs: The &struct pt_regs of the current thread.
> + *	@threadid: The thread id of the shadowed process to get information on.
> + *
> + *	RETURN:
> + *	This returns a pointer to the &struct task_struct of the shadowed
> + *	thread, @threadid.
> + */
> +extern struct task_struct *kgdb_get_shadow_thread(struct pt_regs *regs,
> +						  int threadid);

So we have kerneldoc comments in both places now?  Didn't you say
you converted these to something else?

> +++ b/kernel/kgdb.c
> @@ -0,0 +1,2019 @@
> +/*
> + * kernel/kgdb.c

Another one.

