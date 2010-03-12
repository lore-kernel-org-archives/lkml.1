Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465Ab0CLSfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 13:35:08 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:44738 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934085Ab0CLSfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 13:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uuZ3XIUn2LSfnk6VIyEYkzJnmfRfUApdB0GzQVD2QUSLn8kxOJ6hhwLH1stBL+3UYT
         sLzy5Q4x3UPbYuEkBhatpmcMAoFuqVfBVEg9oIRmaisBXkT/LoCuHe6WYnvG2f4AQj0r
         1zUM5ahj2pS3SXiMGbWxDV7ciwvCevDTuBoO4=
Date: Fri, 12 Mar 2010 10:34:51 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: kernel-janitors@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/mips/txx9/generic: init dynamic bin_attribute
 structures
Message-ID: <20100312183450.GC8736@core.coreip.homeip.net>
References: <1268377431-11671-1-git-send-email-w.sang@pengutronix.de>
 <1268377431-11671-2-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268377431-11671-2-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 08:03:49AM +0100, Wolfram Sang wrote:
> Commit 6992f5334995af474c2b58d010d08bc597f0f2fe introduced this requirement.
> Found with coccinelle, but fixed manually. Compile tested on X86 where
> possible.
> 

Regarding all 3 - it looks like these dynamically alocated attributes
could be converted to statically allocated ones. I'd recommend doing
that instead (in fact, I posted patch for the firmware_class couple days
ago).

> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  arch/mips/txx9/generic/setup.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
> index 7174d83..95184a0 100644
> --- a/arch/mips/txx9/generic/setup.c
> +++ b/arch/mips/txx9/generic/setup.c
> @@ -956,6 +956,7 @@ void __init txx9_sramc_init(struct resource *r)
>  	if (!dev->base)
>  		goto exit;
>  	dev->dev.cls = &txx9_sramc_sysdev_class;
> +	sysfs_bin_attr_init(&dev->bindata_attr);
>  	dev->bindata_attr.attr.name = "bindata";
>  	dev->bindata_attr.attr.mode = S_IRUSR | S_IWUSR;
>  	dev->bindata_attr.read = txx9_sram_read;

-- 
Dmitry
