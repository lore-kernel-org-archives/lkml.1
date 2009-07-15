Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZGOCpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZGOCpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 22:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZGOCpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 22:45:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46584 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZGOCpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 22:45:42 -0400
Message-ID: <4A5D426E.90308@pobox.com>
Date: Tue, 14 Jul 2009 22:43:58 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers/ata: Move a dereference below a NULL test
References: <Pine.LNX.4.64.0907110949280.29592@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0907110949280.29592@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> If the NULL test is necessary, then the dereference should be moved below
> the NULL test.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> type T;
> expression E;
> identifier i,fld;
> statement S;
> @@
> 
> - T i = E->fld;
> + T i;
>   ... when != E
>       when != i
>   if (E == NULL) S
> + i = E->fld;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/ata/pata_at91.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -u -p a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
> --- a/drivers/ata/pata_at91.c
> +++ b/drivers/ata/pata_at91.c
> @@ -312,11 +312,12 @@ err_ide_ioremap:
>  static int __devexit pata_at91_remove(struct platform_device *pdev)
>  {
>  	struct ata_host *host = dev_get_drvdata(&pdev->dev);
> -	struct at91_ide_info *info = host->private_data;
> +	struct at91_ide_info *info;
>  	struct device *dev = &pdev->dev;
>  
>  	if (!host)
>  		return 0;
> +	info = host->private_data;
>  

applied


