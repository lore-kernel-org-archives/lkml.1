Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZBGAG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZBGAG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZBGAGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:06:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbZBGAGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:06:17 -0500
Date: Fri, 6 Feb 2009 16:05:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sonic.zhang@analog.com, cooloney@kernel.org
Subject: Re: [PATCH] tty: fix bug - kernel can't be pinged through when
 bootargs console=null
Message-Id: <20090206160555.b95e02bc.akpm@linux-foundation.org>
In-Reply-To: <1233908877-7729-1-git-send-email-cooloney@kernel.org>
References: <1233908877-7729-1-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Feb 2009 16:27:57 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> when pass bootargs console=null into kernel from u-boot, the booted up
> kernel can't be pinged through. This happens after the kernel is upgraded
> to 2.6.28.
> 
> Should check if tty_driver is NULL before call kref_get() in tty_driver_kref_get().
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  include/linux/tty_driver.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
> index 08e0883..2a602a8 100644
> --- a/include/linux/tty_driver.h
> +++ b/include/linux/tty_driver.h
> @@ -312,7 +312,8 @@ extern struct tty_driver *tty_find_polling_driver(char *name, int *line);
>  extern void tty_driver_kref_put(struct tty_driver *driver);
>  extern inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
>  {
> -	kref_get(&d->kref);
> +	if (d)
> +		kref_get(&d->kref);
>  	return d;
>  }
>  

Did any earlier kernel versions handle this situation OK?

If so, we might need to be back-compatible with buggy userspace :(
