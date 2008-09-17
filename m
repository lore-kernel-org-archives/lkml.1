Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbYIQS6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbYIQS6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYIQS5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:57:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752266AbYIQS5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:57:54 -0400
Date: Wed, 17 Sep 2008 11:57:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zev Weiss <zevweiss@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [MTD] physmap.c: Check return of
 platform_device_register()
Message-Id: <20080917115746.e36cacc6.akpm@linux-foundation.org>
In-Reply-To: <48CB5E9A.4010000@gmail.com>
References: <48CB5E9A.4010000@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 23:32:58 -0700
Zev Weiss <zevweiss@gmail.com> wrote:

> The PHYSMAP_COMPAT code had been ignoring the return value of
> platform_device_register() in the physmap_init() function.
> 
> Signed-off-by: Zev Weiss <zevweiss@gmail.com>
> ---
>   drivers/mtd/maps/physmap.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
> index 42d844f..6fba0d4 100644
> --- a/drivers/mtd/maps/physmap.c
> +++ b/drivers/mtd/maps/physmap.c
> @@ -312,7 +312,7 @@ static int __init physmap_init(void)
>   	err = platform_driver_register(&physmap_flash_driver);
>   #ifdef PHYSMAP_COMPAT
>   	if (err == 0)
> -		platform_device_register(&physmap_flash);
> +		err = platform_device_register(&physmap_flash);
>   #endif
> 
>   	return err;

Your email client is performing space-stuffing, thus making the patches
unapplyable.

Presumably we should run platform_driver_unregister() if the
platform_device_register() failed.

