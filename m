Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbXCSKx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbXCSKx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 06:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbXCSKx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 06:53:56 -0400
Received: from mail.screens.ru ([213.234.233.54]:40337 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbXCSKx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 06:53:56 -0400
Date: Mon, 19 Mar 2007 13:53:58 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take2] getrusage() : Fill ru_inblock and ru_oublock fields if possible
Message-ID: <20070319105358.GA152@tv-sign.ru>
References: <200703191139.40281.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703191139.40281.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19, Eric Dumazet wrote:
>
> +static inline unsigned long task_io_get_inblock(const struct task_struct *p)
> +{
> +	return p->ioac.read_bytes >> 9;
> +}
>
> [...snip...]
>
> @@ -2021,6 +2022,8 @@ static void k_getrusage(struct task_stru
>  			r->ru_nivcsw = p->signal->cnivcsw;
>  			r->ru_minflt = p->signal->cmin_flt;
>  			r->ru_majflt = p->signal->cmaj_flt;
> +			r->ru_inblock = p->signal->cinblock;
> +			r->ru_oublock = p->signal->coublock;
>  
>  			if (who == RUSAGE_CHILDREN)
>  				break;
> @@ -2032,6 +2035,8 @@ static void k_getrusage(struct task_stru
>  			r->ru_nivcsw += p->signal->nivcsw;
>  			r->ru_minflt += p->signal->min_flt;
>  			r->ru_majflt += p->signal->maj_flt;
> +			r->ru_inblock += task_io_get_inblock(p->signal);

p->signal is "struct signal_struct *", not "struct task_struct *" as
task_io_get_inblock() expects ?

Oleg.

