Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbZA2Vfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbZA2Vfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758878AbZA2Vfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:35:37 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:58072 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbZA2Vfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:35:36 -0500
Date: Thu, 29 Jan 2009 22:35:33 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -next/mmotm/resend] kmemtrace: fix printk formats
In-Reply-To: <4981E86F.60909@oracle.com>
Message-ID: <Pine.LNX.4.64.0901292234520.17617@anakin>
References: <200901291030.n0TAUhRI003046@imap1.linux-foundation.org>
 <4981E86F.60909@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kmemtrace printk warnings:
> 
> kernel/trace/kmemtrace.c:142: warning: format '%4ld' expects type 'long int', but argument 3 has type 'size_t'
> kernel/trace/kmemtrace.c:147: warning: format '%4ld' expects type 'long int', but argument 3 has type 'size_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc:      Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  kernel/trace/kmemtrace.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next-20090123.orig/kernel/trace/kmemtrace.c
> +++ linux-next-20090123/kernel/trace/kmemtrace.c
> @@ -139,12 +139,12 @@ kmemtrace_print_alloc_compress(struct tr
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	/* Requested */
> -	ret = trace_seq_printf(s, "%4ld   ", entry->bytes_req);
> +	ret = trace_seq_printf(s, "%4zd   ", entry->bytes_req);
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	/* Allocated */
> -	ret = trace_seq_printf(s, "%4ld   ", entry->bytes_alloc);
> +	ret = trace_seq_printf(s, "%4zd   ", entry->bytes_alloc);
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;

%4zu?

size_t is unsigned, ssize_t is signed.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
