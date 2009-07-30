Return-Path: <linux-kernel-owner+w=401wt.eu-S1751471AbZG3NED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbZG3NED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbZG3NED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:04:03 -0400
Received: from www.tglx.de ([62.245.132.106]:48232 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbZG3NEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:04:02 -0400
Message-ID: <4A719A27.8050509@linutronix.de>
Date: Thu, 30 Jul 2009 15:03:35 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Stoyan Gaydarov <sgayda2@uiuc.edu>
CC: linux-kernel@vger.kernel.org, David.Woodhouse@intel.com, sr@denx.de,
       kay.sievers@vrfy.org, gregkh@suse.de, linux-mtd@lists.infradead.org
Subject: Re: [PATCH] [mtd] fixed faulty check
References: <1248958178-22599-1-git-send-email-sgayda2@uiuc.edu>
In-Reply-To: <1248958178-22599-1-git-send-email-sgayda2@uiuc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stoyan Gaydarov wrote:
> Resubmit of a patch with some additions, see http://lkml.org/lkml/2009/7/30/97
> 
Please add a description of the path here. That's the place where people
are looking for them. The link might be a an additional reference.

> Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
> ---
>  drivers/mtd/maps/physmap_of.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
> index 39d357b..e7ab5f0 100644
> --- a/drivers/mtd/maps/physmap_of.c
> +++ b/drivers/mtd/maps/physmap_of.c
> @@ -215,7 +215,8 @@ static int __devinit of_flash_probe(struct of_device *dev,
>  		goto err_out;
>  
>  	mtd_list = kzalloc(sizeof(struct mtd_info) * count, GFP_KERNEL);
> -	if (!info)
> +	if (!mtd_list)
> +		kfree(info);
>  		goto err_out;

This is not python, you have to be explicit about braces. Now your code
looks like this:

   	mtd_list = kzalloc(sizeof(struct mtd_info) * count, GFP_KERNEL);
	if (!mtd_list)
		kfree(info);
	goto err_out;
>  
>  	dev_set_drvdata(&dev->dev, info);


Sebastian
