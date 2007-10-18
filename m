Return-Path: <linux-kernel-owner+w=401wt.eu-S932790AbXJRWSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbXJRWSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760581AbXJRWSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:18:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59323 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758088AbXJRWSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:18:07 -0400
Date: Thu, 18 Oct 2007 15:17:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, paulus@ozlabs.org, lethal@linux-sh.org,
       kyle@parisc-linux.org, grundler@parisc-linux.org
Subject: Re: [PATCH 1/2] bug.h: Introduce HAVE_ARCH_WARN
Message-Id: <20071018151752.09147de5.akpm@linux-foundation.org>
In-Reply-To: <20071011171211.GB10877@lixom.net>
References: <20071011171211.GB10877@lixom.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 12:12:11 -0500
Olof Johansson <olof@lixom.net> wrote:

> HAVE_ARCH_WARN is used to determine if an arch already has a __WARN()
> macro, or if a generic one is needed.
> 
> With this, some of the arch-specific WARN_ON() implementations can be
> made common instead (see follow-up patch for powerpc).
> 

Those HAVE_ARCH_foo things are unpleasant.

> 
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index d56fedb..c6b8386 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -31,14 +31,19 @@ struct bug_entry {
>  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
>  #endif
>  
> +#ifndef HAVE_ARCH_WARN
> +#define __WARN() do {							\
> +	printk("WARNING: at %s:%d %s()\n", __FILE__,			\
> +		__LINE__, __FUNCTION__);				\
> +	dump_stack();							\
> +} while (0)
> +#endif

Can't we just do #ifndef __WARN?
