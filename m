Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbYIMKp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbYIMKp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 06:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYIMKpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 06:45:47 -0400
Received: from xi.wantstofly.org ([83.160.184.112]:54772 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbYIMKpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 06:45:46 -0400
Date: Sat, 13 Sep 2008 12:45:42 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Zev Weiss <zevweiss@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [MTD] physmap.c: Check return of platform_device_register()
Message-ID: <20080913104542.GD21603@xi.wantstofly.org>
References: <48CB5E9A.4010000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CB5E9A.4010000@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 11:32:58PM -0700, Zev Weiss wrote:

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

I don't think you want the registration of the physmap driver to fail
if the compat platform device fails to register.

One reason that the compat platform device can fail to register can be
that there is already a non-compat platform device for the compat flash
chip, and in that case I don't think you want to fail the driver init
(while leaving the physmap_flash_driver registered, too!).
