Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbXKYWYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbXKYWYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbXKYWYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:24:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34917 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbXKYWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:24:10 -0500
Date: Sun, 25 Nov 2007 22:23:52 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 10/27] ptrace: generic resume
Message-ID: <20071125222352.GB1597@infradead.org>
References: <20071125215507.4B89226F8C5@magilla.localdomain> <20071125220109.10BC726F8C5@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071125220109.10BC726F8C5@magilla.localdomain>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2007 at 02:01:09PM -0800, Roland McGrath wrote:
> This makes ptrace_request handle all the ptrace requests that wake
> up the traced task.  These do low-level ptrace implementation magic
> that is not arch-specific and should be kept out of arch code.  The
> implementations on each arch usually do the same thing.  The new
> generic code makes use of the arch_has_single_step macro and generic
> entry points to handle PTRACE_SINGLESTEP.

Nice, I've been trying to get people to move this to common code for
a while :)


> +#ifdef PTRACE_SINGLESTEP
> +#define is_singlestep(request)		((request) == PTRACE_SINGLESTEP)
> +#else
> +#define is_singlestep(request)		0
> +#endif
> +
> +#ifdef PTRACE_SYSEMU
> +#define is_sysemu_singlestep(request)	((request) == PTRACE_SYSEMU_SINGLESTEP)
> +#else
> +#define is_sysemu_singlestep(request)	0
> +#endif

Could we by any chance just force every architecture using generic code
to implement PTRACE_SINGLESTEP and PTRACE_SYSEMU?  This will lead to
both far less messy code and a more consistant user interface.

