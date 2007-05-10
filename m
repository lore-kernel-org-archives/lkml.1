Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbXEJMBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbXEJMBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbXEJMBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:01:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49069 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbXEJMBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:01:03 -0400
Date: Thu, 10 May 2007 13:00:55 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 07/10] Linux Kernel Markers - Documentation
Message-ID: <20070510120055.GB18453@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070510015555.973107048@polymtl.ca> <20070510020917.172554217@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510020917.172554217@polymtl.ca>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +They can be used for tracing (LTTng, LKET over SystemTAP), overall performance
> +accounting (SystemTAP). They could also be used to implement
> +efficient hooks for SELinux or any other subsystem that would have this
> +kind of need.
> +
> +Using the markers for system audit (SELinux) would require to pass a
> +variable by address that would be later checked by the marked routine.

I don't think you should mention abuses like the selinux one, nor odd
projects that aren't merged.  Just make this a generic:

"The can be used for tracing or performance accounting"

> +* Usage
> +
> +In order to use the macro MARK, you should include linux/marker.h.

It's trace_mark now.

> +* Optimization for a given architecture
> +
> +You will find, in asm-*/marker.h, optimisations for given architectures
> +(currently i386 and powerpc). They use a load immediate instead of a data load,
> +which saves a data cache hit, but also requires cross CPU code modification. In
> +order to support embedded systems which use read-only memory for their code, the
> +optimization can be disabled through menu options.

I'm not sure this belong in here.  As we already have good example it's
probably not needed at all.

> +#include <linux/sched.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/marker.h>
> +#include <asm/atomic.h>
> +
> +#define NUM_PROBES ARRAY_SIZE(probe_array)

no need for this macro.

> +static int __init probe_init(void)
> +{
> +	int result;
> +	uint8_t eID;

please call the loop variable i and use int for it.

