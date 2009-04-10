Return-Path: <linux-kernel-owner+w=401wt.eu-S935822AbZDJGQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935822AbZDJGQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760943AbZDJGQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:16:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758384AbZDJGQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:16:34 -0400
Date: Thu, 9 Apr 2009 23:12:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: liqin.chen@sunplusct.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [PATCH 2/14] score - New architecure port to SunplusCT S+CORE
Message-Id: <20090409231208.558c0983.akpm@linux-foundation.org>
In-Reply-To: <OF522DF4EC.299F045D-ON48257592.00284C5F-48257592.00289156@sunplusct.com>
References: <OF522DF4EC.299F045D-ON48257592.00284C5F-48257592.00289156@sunplusct.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 15:21:00 +0800 liqin.chen@sunplusct.com wrote:

> From: Chen Liqin <liqin.chen@sunplusct.com>
> 
> asm/asm.h, asm/atomic.h, asm/auxvec.h, asm/bitops.h, asm/bug.h,
> asm/bugs.h, asm/byteorder.h, asm/cacheflush.h, asm/cache.h
> and asm/checksum.h for the score architecture.
> 
>
> ...
>
> +#define PG_dcache_dirty                        PG_arch_1
> +
> +#define Page_dcache_dirty(page)                \
> +       test_bit(PG_dcache_dirty, &(page)->flags)
> +#define SetPageDcacheDirty(page)       \
> +       set_bit(PG_dcache_dirty, &(page)->flags)
> +#define ClearPageDcacheDirty(page)     \
> +       clear_bit(PG_dcache_dirty, &(page)->flags)

We have ugly macros in include/linux/page-flags.h which expand a page
flag out into its accessors, with standardised naming: TESTSCFLAG,
CLEARPAGEFLAG_NOOP, etc.

It would be best of those were reused here.

>
> ...
>
