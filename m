Return-Path: <linux-kernel-owner+w=401wt.eu-S1763784AbYESNki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763784AbYESNki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763423AbYESNaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:30:39 -0400
Received: from www.tglx.de ([62.245.132.106]:44184 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764173AbYESNah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:30:37 -0400
Date: Mon, 19 May 2008 15:30:24 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: hjk@linutronix.de, corbet@lwn.net, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] [11/11] Convert uio to fasync_unlocked
Message-ID: <20080519133023.GB3188@local>
References: <20080519231.561421028@firstfloor.org> <20080519123120.C7BBD1B41FF@basil.firstfloor.org> <87lk26bgtb.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lk26bgtb.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 02:48:32PM +0200, Andi Kleen wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> > Just calls fasync_helper
> >
> > Cc: hjk@linutronix.de
> 
> Sorry that one was missing a quilt refresh. Here's the real patch.
> Not very exciting.

Patch looks alright to me, but Greg KH should be cc'ed for UIO patches
as well.

> 
> -Andi
> 
> ---
> 
> Convert uio to fasync_unlocked
> 
> Just calls fasync_helper
> 
> Cc: hjk@linutronix.de
  Cc: gregkh@suse.de
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

 Acked-by: Hans J. Koch <hjk@linutronix.de>

> 
> Index: linux/drivers/uio/uio.c
> ===================================================================
> --- linux.orig/drivers/uio/uio.c
> +++ linux/drivers/uio/uio.c
> @@ -541,7 +541,7 @@ static const struct file_operations uio_
>  	.read		= uio_read,
>  	.mmap		= uio_mmap,
>  	.poll		= uio_poll,
> -	.fasync		= uio_fasync,
> +	.unlocked_fasync = uio_fasync,
>  };
>  
>  static int uio_major_init(void)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
