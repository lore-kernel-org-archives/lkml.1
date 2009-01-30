Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZA3JxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZA3JxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZA3Jwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:52:55 -0500
Received: from relay.atmel.no ([80.232.32.139]:56512 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbZA3Jwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:52:54 -0500
X-Greylist: delayed 1536 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Jan 2009 04:52:54 EST
Date: Fri, 30 Jan 2009 10:26:54 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dbrownell@users.sourceforge.net, kay.sievers@vrfy.org,
       weiyi.huang@gmail.com, Andrew Victor <avictor.za@gmail.com>
Subject: Re: [PATCH 1/1] atmel-ssc: fix misuse of dev_dbg when requested ssc
 instance is not found
Message-ID: <20090130102654.10e4aafc@hskinnemoen-d830>
In-Reply-To: <1232369876-19428-1-git-send-email-hans-christian.egtvedt@atmel.com>
References: <1232369876-19428-1-git-send-email-hans-christian.egtvedt@atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCs added]

Hans-Christian Egtvedt wrote:
> This patch replaces the dev_dbg(...) with a pr_err since the ssc pointer
> is not valid when the id is not found in the list.
> 
> Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

...or should I just apply it to the avr32 tree?

Haavard

> ---
>  drivers/misc/atmel-ssc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
> index 6b35874..6cff1bb 100644
> --- a/drivers/misc/atmel-ssc.c
> +++ b/drivers/misc/atmel-ssc.c
> @@ -35,7 +35,7 @@ struct ssc_device *ssc_request(unsigned int ssc_num)
>  
>  	if (!ssc_valid) {
>  		spin_unlock(&user_lock);
> -		dev_dbg(&ssc->pdev->dev, "could not find requested device\n");
> +		pr_err("ssc: ssc%d platform device is missing\n", ssc_num);
>  		return ERR_PTR(-ENODEV);
>  	}
>  
