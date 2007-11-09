Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbXKITwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbXKITwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 14:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXKITwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 14:52:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50352 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbXKITwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 14:52:40 -0500
Date: Fri, 9 Nov 2007 11:52:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, jdi@l4x.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Subject: Re: [PATCH] FRV: Fix the extern declaration of kallsyms_num_syms
Message-Id: <20071109115207.e435f19b.akpm@linux-foundation.org>
In-Reply-To: <20071106214820.3854.17402.stgit@warthog.procyon.org.uk>
References: <20071106214820.3854.17402.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Nov 2007 21:48:20 +0000
David Howells <dhowells@redhat.com> wrote:

> From: David Howells <dhowells@redhat.com>
> 
> Fix the extern declaration of kallsyms_num_syms to indicate that the symbol
> does not reside in the small-data storage space, and so may not be accessed
> relative to the small data base register.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  kernel/kallsyms.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 474219a..fa84b83 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -32,7 +32,8 @@
>  
>  /* These will be re-linked against their real values during the second link stage */
>  extern const unsigned long kallsyms_addresses[] __attribute__((weak));
> -extern const unsigned long kallsyms_num_syms __attribute__((weak));
> +extern const unsigned long kallsyms_num_syms
> +__nongpreldata __attribute__((weak));

umm, this makes Linux an frv-only operating system...

>  extern const u8 kallsyms_names[] __attribute__((weak));
>  
>  extern const u8 kallsyms_token_table[] __attribute__((weak));
