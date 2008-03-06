Return-Path: <linux-kernel-owner+w=401wt.eu-S935440AbYCFSIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935440AbYCFSIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935343AbYCFSIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:08:09 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:45994 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935339AbYCFSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:08:07 -0500
Date: Thu, 6 Mar 2008 19:08:04 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Julia Lawall <julia@diku.dk>
Cc: mikael.starvik@axis.com, dev-etrax@axis.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/cris: Use mutex_unlock rather than spin_unlock
Message-ID: <20080306180804.GJ27716@axis.com>
References: <Pine.LNX.4.58.0803061823370.1669@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0803061823370.1669@pc-041.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 06:24:05PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> It looks at least odd to apply spin_unlock to a mutex.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @def@
> declarer DEFINE_MUTEX;
> identifier m;
> @@
> 
> DEFINE_MUTEX(m);
> 
> @@
> identifier def.m;
> @@
> 
> (
> - spin_lock(&m)
> + mutex_lock(&m)
> |
> - spin_unlock(&m)
> + mutex_unlock(&m)
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  arch/cris/arch-v10/drivers/pcf8563.c |    2 +-
>  arch/cris/arch-v32/drivers/pcf8563.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff -u -p a/arch/cris/arch-v10/drivers/pcf8563.c b/arch/cris/arch-v10/drivers/pcf8563.c
> --- a/arch/cris/arch-v10/drivers/pcf8563.c 2008-02-10 22:34:04.000000000 +0100
> +++ b/arch/cris/arch-v10/drivers/pcf8563.c 2008-03-05 22:06:18.000000000 +0100
> @@ -233,7 +233,7 @@ int pcf8563_ioctl(struct inode *inode, s
> 
>  		if (copy_to_user((struct rtc_time *) arg, &tm,
>  				 sizeof tm)) {
> -			spin_unlock(&rtc_lock);
> +			mutex_unlock(&rtc_lock);
>  			return -EFAULT;
>  		}
> 
> diff -u -p a/arch/cris/arch-v32/drivers/pcf8563.c b/arch/cris/arch-v32/drivers/pcf8563.c
> --- a/arch/cris/arch-v32/drivers/pcf8563.c 2008-02-10 22:34:04.000000000 +0100
> +++ b/arch/cris/arch-v32/drivers/pcf8563.c 2008-03-05 22:06:18.000000000 +0100
> @@ -229,7 +229,7 @@ int pcf8563_ioctl(struct inode *inode, s
> 
>  		if (copy_to_user((struct rtc_time *) arg, &tm,
>  				 sizeof tm)) {
> -			spin_unlock(&rtc_lock);
> +			mutex_unlock(&rtc_lock);
>  			return -EFAULT;
>  		}
> 

Quite correct, I'll add it to my queue.

Thanks,

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
