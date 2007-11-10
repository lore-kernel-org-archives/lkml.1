Return-Path: <linux-kernel-owner+w=401wt.eu-S1762936AbXKJBEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762936AbXKJBEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 20:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761766AbXKJBDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 20:03:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43640 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761718AbXKJBDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 20:03:54 -0500
Date: Fri, 9 Nov 2007 17:02:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "eric miao" <eric.y.miao@gmail.com>
Cc: linux-kernel@vger.kernel.org, szabolcs.gyurko@tlt.hu,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] make ds1wm driver to check ds1wm_platform_data pointer
 against NULL
Message-Id: <20071109170238.628fdf0d.akpm@linux-foundation.org>
In-Reply-To: <f17812d70711082207p455c5bc9v25fea9a0585ba152@mail.gmail.com>
References: <f17812d70711082207p455c5bc9v25fea9a0585ba152@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007 14:07:31 +0800
"eric miao" <eric.y.miao@gmail.com> wrote:

> Do a sanity check for the "struct ds1wm_platform_data" pointer passed in
> by the platform_device, and so to enforce each platform to provide a
> valid structure.
> 
> Signed-off-by: eric miao <eric.miao@marvell.com>
> ---
>  drivers/w1/masters/ds1wm.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
> index 5747997..11ce9ec 100644
> --- a/drivers/w1/masters/ds1wm.c
> +++ b/drivers/w1/masters/ds1wm.c
> @@ -351,6 +351,10 @@ static int ds1wm_probe(struct platform_device *pdev)
>  		goto err0;
>  	}
>  	plat = pdev->dev.platform_data;
> +	if (!plat) {
> +		ret = -ENXIO;
> +		goto err0;
> +	}
>  	ds1wm_data->bus_shift = plat->bus_shift;
>  	ds1wm_data->pdev = pdev;
>  	ds1wm_data->pdata = plat;

I don't understand this change.  Could you please provide some more details
regarding what problem it is solving?  How can pdev->dev.platform_data==NULL
come about?

Thanks.
