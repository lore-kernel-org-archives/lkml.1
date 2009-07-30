Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZG3L1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZG3L1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 07:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZG3L1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 07:27:43 -0400
Received: from www.tglx.de ([62.245.132.106]:58711 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbZG3L1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 07:27:43 -0400
Message-ID: <4A718390.4080103@linutronix.de>
Date: Thu, 30 Jul 2009 13:27:12 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Stoyan Gaydarov <sgayda2@uiuc.edu>
CC: linux-kernel@vger.kernel.org, David.Woodhouse@intel.com, sr@denx.de,
       kay.sievers@vrfy.org, gregkh@suse.de, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2/4] [mtd] fixed faulty check
References: <1248949506-20827-1-git-send-email-sgayda2@uiuc.edu>
In-Reply-To: <1248949506-20827-1-git-send-email-sgayda2@uiuc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stoyan Gaydarov wrote:
> This patche fixes a spelling error that has resulted from copy and pasting. The location of the error was found using a semantic patch but the semantic patch was not trying to find these errors. After looking things over it seemed logical that this change was needed. Please review it and then include the patch if it is in fact the correct change.
> 
> Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
> ---
>  drivers/mtd/maps/physmap_of.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
> index 39d357b..2cc0b0d 100644
> --- a/drivers/mtd/maps/physmap_of.c
> +++ b/drivers/mtd/maps/physmap_of.c
> @@ -215,7 +215,7 @@ static int __devinit of_flash_probe(struct of_device *dev,
>  		goto err_out;
>  
>  	mtd_list = kzalloc(sizeof(struct mtd_info) * count, GFP_KERNEL);
> -	if (!info)
> +	if (!mtd_list)
>  		goto err_out;
>  
>  	dev_set_drvdata(&dev->dev, info);
Yes, !mtd_list should be checked instead of !info. This is correct. 
However in error case you have to free info as well.
Can please make another patch?

Sebastian
