Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbXGNQZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbXGNQZM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 12:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbXGNQZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 12:25:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42097 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbXGNQY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 12:24:59 -0400
Date: Sat, 14 Jul 2007 17:24:56 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] Immediate Value - Architecture Independent Code
Message-ID: <20070714162456.GB13831@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070714012439.285079881@polymtl.ca> <20070714012623.231272637@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714012623.231272637@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 09:24:41PM -0400, Mathieu Desnoyers wrote:
> +#ifdef __KERNEL__

no need for this.  unless you add the header to header-y in the Kbuild
file it's not exported to userspace at all.

> +#ifdef CONFIG_IMMEDIATE
> +#include <asm/immediate.h>
> +#else
> +#include <asm-generic/immediate.h>
> +#endif

Nack on this one. linux/*.h should never include asm-generic headers.

Either put the !CONFIG_IMMEDIATE code directly into this file or let
every arch have a one-liner immediate.h that includes the asm-generic
one.  The first method is probably a lot nicer.

> +/*
> + * modules_mutex nests inside immediate_mutex. immediate_mutex protects builtin
> + * immediates and module immediates.
> + */
> +DEFINE_MUTEX(immediate_mutex);

Why is this non-static?

> +
> +/*
> + * Sets a range of immediates to a enabled state : set the enable bit.
> + */
> +static void _immediate_update_range(
> +	const struct __immediate *begin, const struct __immediate *end)

static void _immediate_update_range(const struct __immediate *begin,
		const struct __immediate *end)

same for a few more functions here.

> +#ifdef CONFIG_MODULES

...

> +#endif
> +
> +#ifdef CONFIG_MODULES

please put all this code into a single ifdef block.


note that the exported functions probably want some kerneldoc documentation.
