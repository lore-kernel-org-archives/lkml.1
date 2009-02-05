Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZBEWBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZBEWBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbZBEWBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:01:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbZBEWBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:01:35 -0500
Date: Thu, 5 Feb 2009 14:00:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, roel.kluin@gmail.com,
       michael.hennerich@analog.com, cooloney@kernel.org
Subject: Re: [PATCH] Input: bf54x-keys: ! has a higher priority than >
Message-Id: <20090205140045.ef9fd5e6.akpm@linux-foundation.org>
In-Reply-To: <1233818395-6461-1-git-send-email-cooloney@kernel.org>
References: <1233818395-6461-1-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Feb 2009 15:19:55 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Roel Kluin <roel.kluin@gmail.com>
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/input/keyboard/bf54x-keys.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
> index 1928401..ee855c5 100644
> --- a/drivers/input/keyboard/bf54x-keys.c
> +++ b/drivers/input/keyboard/bf54x-keys.c
> @@ -209,8 +209,8 @@ static int __devinit bfin_kpad_probe(struct platform_device *pdev)
>  		goto out;
>  	}
>  
> -	if (!pdata->debounce_time || !pdata->debounce_time > MAX_MULT ||
> -	    !pdata->coldrive_time || !pdata->coldrive_time > MAX_MULT) {
> +	if (!pdata->debounce_time || pdata->debounce_time > MAX_MULT ||
> +	    !pdata->coldrive_time || pdata->coldrive_time > MAX_MULT) {

What is this `pdata' thing from which the data comes?

It seems a bit rude to kill the driver when we've detected an error
which could easily be fixed up.

>  		printk(KERN_ERR DRV_NAME
>  			": Invalid Debounce/Columdrive Time from pdata\n");

nit: a colon does not terminate a sentence.

This comment misspells "column".
