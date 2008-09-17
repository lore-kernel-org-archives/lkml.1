Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbYIQTBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbYIQTBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYIQTBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:01:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbYIQTBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:01:35 -0400
Date: Wed, 17 Sep 2008 12:01:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zev Weiss <zevweiss@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [MTD] physmap.c: Add a dummy release function
Message-Id: <20080917120129.f6d3544b.akpm@linux-foundation.org>
In-Reply-To: <48CB5EA4.10907@gmail.com>
References: <48CB5EA4.10907@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH 3/3] [MTD] physmap.c: Add a dummy release function

Please avoid putting the "MTD" inside the [] characters.  Anything
which is inside [] is supposed to be discarded by the patch-receiving
party.  This is for things like [rfc], [patch 3/12], [2.6.27-rc5], etc.

But we do want the "mtd" text to go all the way through into the
mainline git metadata.

On Fri, 12 Sep 2008 23:33:08 -0700
Zev Weiss <zevweiss@gmail.com> wrote:

> 
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

Nope.  Please see Documentation/kobject.txt - search for the text
"mocked mercilessly".  
