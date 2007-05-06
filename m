Return-Path: <linux-kernel-owner+w=401wt.eu-S933559AbXEFKKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbXEFKKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 06:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933566AbXEFKKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 06:10:13 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:53123 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559AbXEFKKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 06:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GBQnD+v+CINCNmLL4iUqV7FXHk1BHBUjfzkmtUqgermKqNc9ypRrNJ7b+tRVAM7LcxCoqMAvgoWmX2xeS82qqIPze765xmOFZwxxeLtopmUyxIOOYb2DmIdj4UCLj2Tq45GCKXvk+UeeEV8UBN5nLy5M6/obOz/jntAvjy9OZUc=
Message-ID: <a781481a0705060310h3a9cb49asbbc8b7f5ddb38a8e@mail.gmail.com>
Date: Sun, 6 May 2007 15:40:10 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tom Zanussi" <zanussi@comcast.net>
Subject: Re: [PATCH] relay: use plain timer instead of delayed work
Cc: akpm@linux-foundation.org, oleg@tv-sign.ru, linux-kernel@vger.kernel.org
In-Reply-To: <1178426780.29337.67.camel@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1178426780.29337.67.camel@ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

On 5/6/07, Tom Zanussi <zanussi@comcast.net> wrote:
> [...]
> relay doesn't need to use schedule_delayed_work() for waking readers
> when a simple timer will do.
>
> Signed-off-by: Tom Zanussi <zanussi@comcast.net>
> [...]
> diff --git a/include/linux/relay.h b/include/linux/relay.h
> index 759a0f9..cac0732 100644
> --- a/include/linux/relay.h
> +++ b/include/linux/relay.h
> @@ -38,7 +38,7 @@ struct rchan_buf
>         size_t subbufs_consumed;        /* count of sub-buffers consumed */
>         struct rchan *chan;             /* associated channel */
>         wait_queue_head_t read_wait;    /* reader wait queue */
> -       struct delayed_work wake_readers; /* reader wake-up work struct */
> +       struct timer_list timer;        /* reader wake-up timer */
>         struct dentry *dentry;          /* channel file dentry */
>         struct kref kref;               /* channel buffer refcount */
>         struct page **page_array;       /* array of current buffer pages */

I suspect you could now safely get rid of the "#include
<linux/wait.h>" at the top of relay.h too. And although timer.h comes
via #include <linux/sched.h>, you might want to do that explicitly
too.

Satyam
