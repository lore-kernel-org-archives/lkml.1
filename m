Return-Path: <linux-kernel-owner+w=401wt.eu-S1422675AbXEDGST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422675AbXEDGST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 02:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbXEDGST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 02:18:19 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbXEDGSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 02:18:18 -0400
Date: Thu, 3 May 2007 23:18:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Rewrite the MAJOR() macro as a call to imajor().
Message-Id: <20070503231814.e12ad2d7.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704280621350.516@localhost.localdomain>
References: <Pine.LNX.4.64.0704280621350.516@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 06:23:54 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:

> Replace the MAJOR() macro invocation with a call to the inline
> imajor() routine.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 6b5b642..08da15b 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -710,7 +710,7 @@ static inline int is_loop_device(struct file *file)
>  {
>  	struct inode *i = file->f_mapping->host;
> 
> -	return i && S_ISBLK(i->i_mode) && MAJOR(i->i_rdev) == LOOP_MAJOR;
> +	return i && S_ISBLK(i->i_mode) && imajor(i) == LOOP_MAJOR;
>  }

there's no runtime change, and I count a couple hundred MAJORs in the tree.

I don't want to receive 200 one-line patches please.  If you're going to
do this then please do decent-sized per-subsystem patches and see if you can
persuade the subsystem maintainers to take them directly.
