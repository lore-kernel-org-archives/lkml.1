Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZFWWmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZFWWmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZFWWmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:42:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184AbZFWWl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:41:59 -0400
Date: Tue, 23 Jun 2009 15:40:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, rgetz@blackfin.uclinux.org
Subject: Re: [PATCH 1/4] asm/sections: add text/data checking functions for
 arches to override
Message-Id: <20090623154022.61e83c33.akpm@linux-foundation.org>
In-Reply-To: <1245255744-21039-1-git-send-email-vapier@gentoo.org>
References: <1245255744-21039-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 12:22:21 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> Some ports (like the Blackfin arch) have a discontiguous memory map which
> means there may be text or data that falls outside of the standard range
> of the start/end text/data symbols.  Creating some helper functions allows
> these non-standard ports to declare these regions without adversely
> affecting anyone else.
> 

The patches look OK to me.

I assumed they're for 2.6.32.

> index 4ce48e8..ee19462 100644
> --- a/include/asm-generic/sections.h
> +++ b/include/asm-generic/sections.h
> @@ -20,4 +20,20 @@ extern char __start_rodata[], __end_rodata[];
>  #define dereference_function_descriptor(p) (p)
>  #endif
>  
> +/* random extra sections (if any).  Override
> + * in asm/sections.h */
> +#ifndef arch_is_kernel_text
> +static inline int arch_is_kernel_text(unsigned long addr)
> +{
> +	return 0;
> +}
> +#endif
> +
> +#ifndef arch_is_kernel_data
> +static inline int arch_is_kernel_data(unsigned long addr)
> +{
> +	return 0;
> +}
> +#endif

I suppose that for completeness and consistency etc really we should have

#define arch_is_kernel_text arch_is_kernel_text
#define arch_is_kernel_data arch_is_kernel_data

in here.
