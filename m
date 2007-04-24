Return-Path: <linux-kernel-owner+w=401wt.eu-S1422999AbXDXSca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422999AbXDXSca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423000AbXDXSca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:32:30 -0400
Received: from brick.kernel.dk ([80.160.20.94]:21932 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422999AbXDXSc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:32:29 -0400
Date: Tue, 24 Apr 2007 20:29:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vasily Tarasov <vtaras@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, OVZDL <devel@openvz.org>
Subject: Re: [PATCH] cfq: get rid of cfqq hash
Message-ID: <20070424182906.GF27887@kernel.dk>
References: <1177422791.435404.4031.nullmailer@me> <20070424170227.GB27887@kernel.dk> <20070424172228.GC27887@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424172228.GC27887@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24 2007, Jens Axboe wrote:
> -		if (key != CFQ_KEY_ASYNC)
> +		if (!is_sync)
>  			cfq_mark_cfqq_idle_window(cfqq);
> +		else
> +			cfq_mark_cfqq_sync(cfqq);

Woops, should be

        if (is_sync) {
                cfq_mark_cfqq_idle_window(cfqq);
                cfq_mark_cfqq_sync(cfqq);
        }

of course.

> +static struct cfq_io_context *
> +cfq_get_io_context_noalloc(struct cfq_data *cfqd, struct task_struct *tsk)
> +{
> +	struct cfq_io_context *cic = NULL;
> +	struct io_context *ioc;
> +
> +	ioc = tsk->io_context;
> +	if (ioc)
> +		cic = cfq_cic_rb_lookup(cfqd, ioc);
> +
> +	return cic;
> +}

I'll change that to just call cfq_cic_rb_lookup(), returning NULL for
NULL ioc.

-- 
Jens Axboe

