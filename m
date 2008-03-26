Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbYCZLC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbYCZLC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756336AbYCZLCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:02:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:56036 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbYCZLCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:02:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mwArKX60um8ah/EsagG1egOdbqQ7EmFH1l5gAzIjFd5e5fe5ak6Y1P7vlRN6whibLsaEScINmxTZB8BkhCoZZeusCuYTdThFvK4v6g55OuOhAXUD2nVBhGbxmhVFWBSqohtpRoU4CC57tovbNCEndrggb9PtMua6c3R2W8re6Pk=
Message-ID: <47EA2D32.1020109@gmail.com>
Date: Wed, 26 Mar 2008 12:02:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: wim@iguana.be, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] Blackfin Watchdog Driver: split platform device/driver
 registering from actual watchdog device/driver registering so we can cleanly
 load/unload
References: <> <1206581401-26046-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1206581401-26046-1-git-send-email-cooloney@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2008 02:30 AM, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/watchdog/bfin_wdt.c |  109 +++++++++++++++++++++++++++---------------
>  1 files changed, 70 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
> index 1237113..c9944ba 100644
> --- a/drivers/watchdog/bfin_wdt.c
> +++ b/drivers/watchdog/bfin_wdt.c
> @@ -29,6 +29,7 @@
>  
>  #define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
>  #define stampit() stamp("here i am")
> +#define pr_devinit(fmt, args...) ({ static const __devinitdata char __fmt[] = fmt; printk(__fmt, ## args); })

Ah and here. __devinitconst
