Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbZJ1WG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbZJ1WG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZJ1WG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:06:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46248 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZJ1WG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:06:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] PM / Hibernate: swap, use KERN_CONT
Date: Wed, 28 Oct 2009 23:08:52 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1255176024-12420-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1255176024-12420-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200910282308.52955.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 October 2009, Jiri Slaby wrote:
> Use KERN_CONT in save_image for printks. So that anybody won't
> try to add a loglevel.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Applied to suspend-2.6/linux-next.

Thanks,
Rafael


> ---
>  kernel/power/swap.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 47586d9..4c0f80b 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -437,7 +437,7 @@ static int save_image(struct swap_map_handle *handle,
>  		if (ret)
>  			break;
>  		if (!(nr_pages % m))
> -			printk("\b\b\b\b%3d%%", nr_pages / m);
> +			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
>  		nr_pages++;
>  	}
>  	err2 = wait_on_bio_chain(&bio);
> @@ -445,9 +445,9 @@ static int save_image(struct swap_map_handle *handle,
>  	if (!ret)
>  		ret = err2;
>  	if (!ret)
> -		printk("\b\b\b\bdone\n");
> +		printk(KERN_CONT "\b\b\b\bdone\n");
>  	else
> -		printk("\n");
> +		printk(KERN_CONT "\n");
>  	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
>  	return ret;
>  }
> 

