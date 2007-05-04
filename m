Return-Path: <linux-kernel-owner+w=401wt.eu-S1031364AbXEDIKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031364AbXEDIKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031366AbXEDIKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:10:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031364AbXEDIKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:10:20 -0400
Date: Fri, 4 May 2007 01:10:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Move sig_kernel_* et al macros to linux/signal.h
Message-Id: <20070504011003.113b1580.akpm@linux-foundation.org>
In-Reply-To: <20070430040238.B5B971801A4@magilla.sf.frob.com>
References: <20070430040238.B5B971801A4@magilla.sf.frob.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 21:02:38 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> This patch moves the sig_kernel_* and related macros from kernel/signal.c
> to linux/signal.h, and cleans them up slightly.  I need the sig_kernel_*
> macros for default signal behavior in the utrace code, and want to avoid
> duplication or overhead to share the knowledge.
> 
> ...
>
> +#ifdef SIGEMT
> +#define SIGEMT_MASK	rt_sigmask(SIGEMT)
> +#else
> +#define SIGEMT_MASK	0
> +#endif
> +
> +#if SIGRTMIN > BITS_PER_LONG
> +#define rt_sigmask(sig)	(1ULL << ((sig)-1))
> +#else
> +#define rt_sigmask(sig)	sigmask(sig)
> +#endif
> +#define siginmask(sig, mask) (rt_sigmask(sig) & (mask))

Should we undef rt_sigmask and siginmask after using them here?

