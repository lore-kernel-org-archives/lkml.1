Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbZJDV6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbZJDV6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 17:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbZJDV6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 17:58:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758041AbZJDV6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 17:58:38 -0400
Date: Sun, 4 Oct 2009 14:57:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH] connector: Removed the destruct_data callback since it
 is always kfree_skb()
Message-Id: <20091004145755.90312e7e.akpm@linux-foundation.org>
In-Reply-To: <1254235692-1631-5-git-send-email-philipp.reisner@linbit.com>
References: <1254235692-1631-1-git-send-email-philipp.reisner@linbit.com>
	<1254235692-1631-2-git-send-email-philipp.reisner@linbit.com>
	<1254235692-1631-3-git-send-email-philipp.reisner@linbit.com>
	<1254235692-1631-4-git-send-email-philipp.reisner@linbit.com>
	<1254235692-1631-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 16:48:11 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:

> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Acked-by: Lars Ellenberg <lars.ellenberg@linbit.com>

Please don't send unchangelogged patches.

> index 163c3e3..210338e 100644
> --- a/drivers/connector/cn_queue.c
> +++ b/drivers/connector/cn_queue.c
> @@ -83,8 +83,8 @@ void cn_queue_wrapper(struct work_struct *work)
>  
>  	d->callback(msg, nsp);
>  
> -	d->destruct_data(d->ddata);
> -	d->ddata = NULL;
> +	kfree_skb(d->skb);
> +	d->skb = NULL;
>  
>  	kfree(d->free);
>  }

So..  why is this a good thing to do?  The patchset removes the option
of ever putting anything other than an skb* into the callback data, it
does this without any dicussion or justification and it does it under
the guise of "allowing permission checking in the receiver callbacks".

