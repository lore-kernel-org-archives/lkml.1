Return-Path: <linux-kernel-owner+w=401wt.eu-S965652AbXCPRGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965652AbXCPRGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965655AbXCPRGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:06:37 -0400
Received: from mail.screens.ru ([213.234.233.54]:57856 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965712AbXCPRGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:06:36 -0400
Date: Fri, 16 Mar 2007 20:10:23 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch added to -mm tree
Message-ID: <20070316171023.GA218@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
>
> @@ -2021,6 +2022,8 @@ static void k_getrusage(struct task_stru
>  			r->ru_nivcsw = p->signal->cnivcsw;
>  			r->ru_minflt = p->signal->cmin_flt;
>  			r->ru_majflt = p->signal->cmaj_flt;
> +			r->ru_inblock = task_io_get_inblock(p);
> +			r->ru_oublock = task_io_get_oublock(p);
>
>  			if (who == RUSAGE_CHILDREN)
>  				break;
> @@ -2032,6 +2035,8 @@ static void k_getrusage(struct task_stru
>  			r->ru_nivcsw += p->signal->nivcsw;
>  			r->ru_minflt += p->signal->min_flt;
>  			r->ru_majflt += p->signal->maj_flt;
> +			r->ru_inblock += task_io_get_inblock(p);
> +			r->ru_oublock += task_io_get_oublock(p);
>  			t = p;
>  			do {
>  				utime = cputime_add(utime, t->utime);
> @@ -2040,6 +2045,8 @@ static void k_getrusage(struct task_stru
>  				r->ru_nivcsw += t->nivcsw;
>  				r->ru_minflt += t->min_flt;
>  				r->ru_majflt += t->maj_flt;
> +				r->ru_inblock += task_io_get_inblock(t);
> +				r->ru_oublock += task_io_get_oublock(t);

I can't understand this. Consider k_getrusage(RUSAGE_BOTH). The end result
is that r->ru_inblock == 3 * task_io_get_inblock(p).

No?

Oleg.

