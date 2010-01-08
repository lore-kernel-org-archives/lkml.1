Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121Ab0AHXTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0AHXTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 18:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892Ab0AHXTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 18:19:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670Ab0AHXTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 18:19:46 -0500
Date: Fri, 8 Jan 2010 15:18:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Johan Hovold <jhovold@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [tip:urgent] fix kfifo_out_locked race bug
Message-Id: <20100108151847.7fdf0fd8.akpm@linux-foundation.org>
In-Reply-To: <1262698715.4532.7.camel@wall-e>
References: <20100104174352.GA26606@localhost>
	<1262632804.4814.17.camel@wall-e>
	<20100105004344.082bb69f@redhat.com>
	<20100105110418.GA10442@localhost>
	<1262689759.21020.2.camel@wall-e>
	<20100105111401.GB10442@localhost>
	<1262690734.22009.3.camel@wall-e>
	<20100105113525.GA19371@localhost>
	<1262692881.23577.15.camel@wall-e>
	<1262698715.4532.7.camel@wall-e>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jan 2010 14:38:35 +0100
Stefani Seibold <stefani@seibold.net> wrote:

> This patch fix a wrong optimization in include/linux/kfifo.h which could
> cause a race in kfifo_out_locked.
> 
> Please apply it to the 2.6.33-rc* tree.
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  kfifo.h |    7 -------
>  1 file changed, 7 deletions(-)
> 
> --- linux-2.6.33-rc2.orig/include/linux/kfifo.h	2009-12-27
> 23:37:04.921185257 +0100
> +++ kfifo.h	2010-01-05 14:32:31.414316321 +0100
> @@ -228,13 +228,6 @@ static inline __must_check unsigned int 
>  
>  	ret = kfifo_out(fifo, to, n);
>  
> -	/*
> -	 * optimization: if the FIFO is empty, set the indices to 0
> -	 * so we don't wrap the next time
> -	 */
> -	if (kfifo_is_empty(fifo))
> -		kfifo_reset(fifo);
> -
>  	spin_unlock_irqrestore(lock, flags);
>  
>  	return ret;
> 

Thanks.  Some nits:

- the patch is wordwrapped.  I fixed that up.

- you removed the cc's of the particpants in the earlier dicsussion. 
  I restored them here.

- the changelog didn't describe the bug - what was the race??

- I added "Reported-by: Johan Hovold <jhovold@gmail.com>" to the changelog

- the "[tip:urgent]" tag in the Subject: line is something which
  Ingo's patch tools add to outgoing email notifications and wasn't
  appropriate here.  Plain old "[patch]" would be typical.

