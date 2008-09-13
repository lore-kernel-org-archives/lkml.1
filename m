Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbYIMKrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbYIMKrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 06:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbYIMKrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 06:47:04 -0400
Received: from xi.wantstofly.org ([83.160.184.112]:54809 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490AbYIMKrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 06:47:02 -0400
Date: Sat, 13 Sep 2008 12:47:01 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Zev Weiss <zevweiss@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [MTD] physmap.c: Add a dummy release function
Message-ID: <20080913104701.GF21603@xi.wantstofly.org>
References: <48CB5EA4.10907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CB5EA4.10907@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 11:33:08PM -0700, Zev Weiss wrote:

> Adding a dummy release function to the physmap device so as to silence a log
> warning on initialization.
> 
> Signed-off-by: Zev Weiss <zevweiss@gmail.com>
> ---
>   drivers/mtd/maps/physmap.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
> index 49e2039..73a8d3c 100644
> --- a/drivers/mtd/maps/physmap.c
> +++ b/drivers/mtd/maps/physmap.c
> @@ -277,11 +277,16 @@ static struct resource physmap_flash_resource = {
>   	.flags		= IORESOURCE_MEM,
>   };
> 
> +static void physmap_dummy_release(struct device *dev)
> +{
> +}
> +
>   static struct platform_device physmap_flash = {
>   	.name		= "physmap-flash",
>   	.id		= 0,
>   	.dev		= {
>   		.platform_data	= &physmap_flash_data,
> +		.release	= &physmap_dummy_release,
>   	},
>   	.num_resources	= 1,
>   	.resource	= &physmap_flash_resource,

Isn't that just papering over the issue?
