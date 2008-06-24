Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYFXCLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYFXCLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYFXCLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:11:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040AbYFXCLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:11:43 -0400
Date: Mon, 23 Jun 2008 19:11:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, harvey.harrison@gmail.com
Subject: Re: [RESEND][PATCH -mm 2/2] vfs: add cond_resched_lock while
 scanning dentry LRU lists
Message-Id: <20080623191140.c0f15ee9.akpm@linux-foundation.org>
In-Reply-To: <486051B3.4070903@np.css.fujitsu.com>
References: <486051B3.4070903@np.css.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 10:45:23 +0900 Kentaro Makita <k-makita@np.css.fujitsu.com> wrote:

> o add cond_resched_lock(&dcache_lock) while scanning LRU lists on superblocks
>   in __shrink_dcache_sb()
> 
> Signed-off-by: Kentaro Makita <k-makita@np.css.fujitsu.com>
> ---
>  fs/dcache.c |    1 +
>  1 files changed, 1 insertion(+)
> 
> Index: b/fs/dcache.c
> ===================================================================
> --- a/fs/dcache.c	2008-06-05 11:48:57.000000000 +0900
> +++ b/fs/dcache.c	2008-06-05 11:49:19.000000000 +0900
> @@ -484,6 +484,7 @@ restart:
>  				if (--cnt == 0)
>  					break;
>  			}
> +			cond_resched_lock(&dcache_lock);
>  		}
>  	}
>  	while (!list_empty(&tmp)) {

The changelog is insufficient.  It tells us what the patch did (which
was completely obvious anyway) but it fails to tell us _why_ the patch
did it.

That is is easily guessable but a good changelog would have described
the problem which you observed and would have described how the the
patch changed the runtime behaviour.

And this is not a trivial formality either.  Because if, for example,
the problem whcih you are fixing here is "machine goes comatose for ten
minutes" then we'll need algorithmic changes and not a bandaid of this
nature.

