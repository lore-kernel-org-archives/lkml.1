Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbXJYBOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbXJYBOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 21:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbXJYBOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 21:14:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631AbXJYBOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 21:14:31 -0400
Date: Wed, 24 Oct 2007 18:14:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] wait: use lock bitops for __wait_on_bit_lock
Message-Id: <20071024181428.1d25299a.akpm@linux-foundation.org>
In-Reply-To: <20071024081405.094887000@nick.local0.net>
References: <20071024081305.906617000@nick.local0.net>
	<20071024081405.094887000@nick.local0.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 18:13:06 +1000 npiggin@nick.local0.net wrote:

> Signed-off-by: Nick Piggin <npiggin@suse.de>
> 
> ---
>  kernel/wait.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/wait.c
> ===================================================================
> --- linux-2.6.orig/kernel/wait.c
> +++ linux-2.6/kernel/wait.c
> @@ -195,7 +195,7 @@ __wait_on_bit_lock(wait_queue_head_t *wq
>  			if ((ret = (*action)(q->key.flags)))
>  				break;
>  		}
> -	} while (test_and_set_bit(q->key.bit_nr, q->key.flags));
> +	} while (test_and_set_bit_lock(q->key.bit_nr, q->key.flags));
>  	finish_wait(wq, &q->wait);
>  	return ret;
>  }
> 

Sorry, I'm just not going to apply a patch like that.

I mean, how the heck is anyone else supposed to understand what you're up
to?  There's a bit of documentation in Documentation/atomic_ops.txt
(probably enough, I guess) but it is totally unobvious to 98.3% of kernel
developers when they should use test_and_set_bit() versus
test_and_set_bit_lock() and it is far too much work to work out why it was
used in __wait_on_bit_lock(), whether it is correct, what advantages it
brings and whether and where others should emulate it.

So in my opinion this submission isn't of sufficient quality to be
included in Linux.

IOW: please write changelogs.  Preferably good ones.

