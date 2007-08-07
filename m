Return-Path: <linux-kernel-owner+w=401wt.eu-S935010AbXHGTDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935010AbXHGTDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbXHGTDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:03:45 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:32849 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546AbXHGTDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:03:44 -0400
Date: Tue, 7 Aug 2007 21:03:57 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       Ollie Wild <aaw@google.com>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 3/3] mm: variable length argument support
Message-ID: <20070807190357.GA31139@aepfle.de>
References: <20070613100334.635756997@chello.nl> <20070613100835.014096712@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070613100835.014096712@chello.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, Peter Zijlstra wrote:

> From: Ollie Wild <aaw@google.com>
> 
> Remove the arg+env limit of MAX_ARG_PAGES by copying the strings directly
> from the old mm into the new mm.

> +++ linux-2.6-2/include/linux/binfmts.h	2007-06-13 11:52:46.000000000 +0200
> @@ -6,11 +6,13 @@
>  struct pt_regs;
>  
>  /*
> - * MAX_ARG_PAGES defines the number of pages allocated for arguments
> - * and envelope for the new program. 32 should suffice, this gives
> - * a maximum env+arg of 128kB w/4KB pages!
> + * These are the maximum length and maximum number of strings passed to the
> + * execve() system call.  MAX_ARG_STRLEN is essentially random but serves to
> + * prevent the kernel from being unduly impacted by misaddressed pointers.
> + * MAX_ARG_STRINGS is chosen to fit in a signed 32-bit integer.
>   */
> -#define MAX_ARG_PAGES 32
> +#define MAX_ARG_STRLEN (PAGE_SIZE * 32)
> +#define MAX_ARG_STRINGS 0x7FFFFFFF

This adds a new usage of PAGE_SIZE to an exported header.
How can this be fixed for 2.6.23?
