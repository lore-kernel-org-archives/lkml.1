Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbZIWVTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbZIWVTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZIWVTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:19:32 -0400
Received: from bamako.nerim.net ([62.4.17.28]:52224 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbZIWVTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:19:32 -0400
Date: Wed, 23 Sep 2009 23:19:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] coretemp: add support for Core i5 CPU
Message-ID: <20090923231934.00616168@hyperion.delvare>
In-Reply-To: <4AB6724A.1060702@gmail.com>
References: <4AB5DE1F.1020004@gmail.com>
	<4AB6724A.1060702@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009 12:19:54 -0600, Robert Hancock wrote:
> Add coretemp support for Core i5 (Lynnfield) CPUs with model 0x1E.
> 
> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
> 
> ---
> 
> This minimal patch works to add support for these CPUs, though we should likely
> still look into using the CPUID flags instead of the model check.
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 93c1722..a9a21dc 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -413,11 +413,11 @@ static int __init coretemp_init(void)
>  	for_each_online_cpu(i) {
>  		struct cpuinfo_x86 *c = &cpu_data(i);
>  
> -		/* check if family 6, models 0xe, 0xf, 0x16, 0x17, 0x1A */
> +		/* check if family 6, models 0xe, 0xf, 0x16, 0x17, 0x1A, 0x1E */
>  		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
>  		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
>  			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
> -			(c->x86_model == 0x1A))) {
> +			(c->x86_model == 0x1A) || (c->x86_model == 0x1E))) {
>  
>  			/* supported CPU not found, but report the unknown
>  			   family 6 CPU */

We've received a similar patch from Intel themselves a few days ago,
and I've just pushed it upstream.

-- 
Jean Delvare
