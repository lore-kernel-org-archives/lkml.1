Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZA2QxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZA2QxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbZA2Qwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:52:53 -0500
Received: from relay.atmel.no ([80.232.32.139]:54733 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbZA2Qww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:52:52 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2009 11:52:51 EST
Date: Thu, 29 Jan 2009 17:46:55 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] atmel-ssc: fix misuse of dev_dbg when requested ssc
 instance is not found
Message-ID: <20090129174655.1f440f3e@hcegtvedt>
In-Reply-To: <1232369876-19428-1-git-send-email-hans-christian.egtvedt@atmel.com>
References: <1232369876-19428-1-git-send-email-hans-christian.egtvedt@atmel.com>
Organization: Atmel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 13:57:56 +0100
Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:

Bump, or did I miss the merge window?

> This patch replaces the dev_dbg(...) with a pr_err since the ssc
> pointer is not valid when the id is not found in the list.
> 
> Signed-off-by: Hans-Christian Egtvedt
> <hans-christian.egtvedt@atmel.com> ---
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

-- 
Best regards,
Hans-Christian Egtvedt
