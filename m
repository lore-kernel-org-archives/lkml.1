Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYJCECR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYJCECR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 00:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbYJCECE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 00:02:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:42599 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYJCECC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 00:02:02 -0400
Date: Thu, 2 Oct 2008 21:01:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002210117.0f5062f7@infradead.org>
In-Reply-To: <20081002132457.46ad8d05.akpm@linux-foundation.org>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
	<20081001235501.2b7f50fe.akpm@linux-foundation.org>
	<20081002061236.3c71c877@infradead.org>
	<20081002132457.46ad8d05.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 13:24:57 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Of course, that could all be wrong and we could be stuck somewhere
> else.  A good way to diagnose this stuff would be
> 
> --- a/kernel/sched.c~a
> +++ a/kernel/sched.c
> @@ -5567,10 +5567,14 @@ EXPORT_SYMBOL(yield);
>  void __sched io_schedule(void)
>  {
>  	struct rq *rq = &__raw_get_cpu_var(runqueues);
> +	unsigned long in, out;
>  
>  	delayacct_blkio_start();
>  	atomic_inc(&rq->nr_iowait);
> +	in = jiffies;
>  	schedule();
> +	out = jiffies;
> +	WARN_ON(time_after(out, in + 1 * HZ));
>  	atomic_dec(&rq->nr_iowait);
>  	delayacct_blkio_end();
>  }
> _
> 
> perhaps for varying values of "1".

I'll run with this. (well with a value of "1000" for 1 ;-)

Also I'll tell latencytop to give me the full backtrace as well ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
