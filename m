Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZA3Hqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZA3Hqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 02:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZA3HqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 02:46:24 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:33313 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZA3HqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 02:46:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n/xhaePv1dioum3TvCFso7/XnXzvnMxq9N386SZXj7qQoScK8Y48Zyn5tvNllyo7rT
         CH8w40hen+TDUE4ry8eOEVkoa6pbcqt9TSSwDpmBrE6fU7wSLjKXS+PEjR6EnaeTwqHv
         yDACOdEUkcGv7RZDFxj9STL2MY0pDcQvEyWgI=
Date: Fri, 30 Jan 2009 09:46:45 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -next/mmotm/resend] kmemtrace: fix printk formats
Message-ID: <20090130074645.GA5218@localhost>
References: <200901291030.n0TAUhRI003046@imap1.linux-foundation.org> <4981E86F.60909@oracle.com> <Pine.LNX.4.64.0901292234520.17617@anakin> <49822479.9030908@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49822479.9030908@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 01:49:45PM -0800, Randy Dunlap wrote:
> Geert Uytterhoeven wrote:
> > 
> > %4zu?
> 
> Ugh, yes.  Thanks.
> Here's the updated patch.
> 
> -- 
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
> +	ret = trace_seq_printf(s, "%4zu   ", entry->bytes_req);
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	/* Allocated */
> -	ret = trace_seq_printf(s, "%4ld   ", entry->bytes_alloc);
> +	ret = trace_seq_printf(s, "%4zu   ", entry->bytes_alloc);
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
>

I didn't notice this either, thanks.

Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>


	Eduard

