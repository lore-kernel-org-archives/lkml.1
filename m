Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab0CJVvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:51:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41113 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab0CJVvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:51:36 -0500
Date: Wed, 10 Mar 2010 21:50:18 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 5/6] early_res: seperate common memmap func from e820.c
	to fw_memmap.c
Message-ID: <20100310215018.GD24353@flint.arm.linux.org.uk>
Mail-Followup-To: Yinghai Lu <yinghai@kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <1268256267-3769-1-git-send-email-yinghai@kernel.org> <1268256267-3769-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268256267-3769-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 01:24:26PM -0800, Yinghai Lu wrote:
> +/* How much should we pad RAM ending depending on where it is? */
> +static unsigned long __init ram_alignment(resource_size_t pos)
> +{
> +	unsigned long mb = pos >> 20;
> +
> +	/* To 64kB in the first megabyte */
> +	if (!mb)
> +		return 64*1024;
> +
> +	/* To 1MB in the first 16MB */
> +	if (mb < 16)
> +		return 1024*1024;
> +
> +	/* To 64MB for anything above that */
> +	return 64*1024*1024;
> +}

This doesn't make sense for generic code.

1. All architectures do not have RAM starting at physical address 0.
2. What about architectures which have relatively little memory (maybe
   16MB total) split into four chunks of 4MB spaced at 512MB ?

Other comments:

1. It doesn't support mem=size@base, which is used extensively on ARM.
2. How does memory get allocated for creating things like page tables?

Currently, bootmem supports ARM very well with support for flatmem,
sparsemem and discontigmem models (the latter being deprecated).  Can
this code support all three models?

Where are patches 1 to 4?

Lastly, why exactly is bootmem being eliminated?  Bootmem offers more
flexible functionality than this e820 code appears at first read-through
seems to.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
