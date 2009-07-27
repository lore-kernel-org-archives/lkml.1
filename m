Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362AbZG0PYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbZG0PYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZG0PYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:24:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbZG0PYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:24:10 -0400
Date: Mon, 27 Jul 2009 11:24:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Patch RFC 01/37] semaphore: Add DEFINE_SEMAPHORE,
	semaphore_init, semaphore_init_locked
Message-ID: <20090727152407.GA31597@infradead.org>
References: <20090726081459.455111897@linutronix.de> <20090726081553.328151390@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090726081553.328151390@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 08:17:11AM -0000, Thomas Gleixner wrote:
> The full cleanup of init_MUTEX[_LOCKED] and DECLARE_MUTEX has not been
> done. Some of the users are real semaphores and we should name them as
> such instead of confusing everyone with "MUTEX".

> +#define DEFINE_SEMAPHORE(name)	\
> +	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
> +

> +static inline void semaphore_init(struct semanphore *sem)
> +{
> +	sema_init(sem, 1);
> +}
> +
> +/*
> + * semaphore_init_locked() is mostly a sign for a mutex which is
> + * abused as completion.
> + */
> +static inline void __deprecated semaphore_init_locked(struct semanphore *sem)
> +{
> +	sema_init(sem, 0);
> +}

The CS literature doesn't really know about a default value for counting
semaphores.  I think you're better off converting init_MUTEX and
init_MUTEX_locked to explicit sema_init use than adding these and
introducing another semaphore_* namespace in addition to the sema_* we
already have.  Adding a DEFINE_SEMAPHORE makes sense, but it should take
a second argument for it's initial value.

