Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923Ab0ADDco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0ADDco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586Ab0ADDcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:32:43 -0500
Received: from [121.136.51.252] ([121.136.51.252]:56927 "EHLO ben-laptop"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752505Ab0ADDcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:32:42 -0500
X-Greylist: delayed 2813 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jan 2010 22:32:42 EST
Message-ID: <4B41564C.6080802@simtec.co.uk>
Date: Mon, 04 Jan 2010 11:45:32 +0900
From: Ben Dooks <ben@simtec.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Ben Dooks <ben-linux@fluff.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mach-osiris-dvs.c: Convert boolean bit tests to logical
 tests
References: <1262539781.1932.128.camel@Joe-Laptop.home>
In-Reply-To: <1262539781.1932.128.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Bit tests on booleans seem odd, logical tests more appropriate

I think this is ok, don't currently have any hardware on hand to
test it.

> Signed-off-by: Joe Perches <joe@perches.com>

Ackced-by: Ben Dooks <ben-linux@fluff.org>

> diff --git a/arch/arm/mach-s3c2440/mach-osiris-dvs.c b/arch/arm/mach-s3c2440/mach-osiris-dvs.c
> index ad2792d..2367606 100644
> --- a/arch/arm/mach-s3c2440/mach-osiris-dvs.c
> +++ b/arch/arm/mach-s3c2440/mach-osiris-dvs.c
> @@ -69,16 +69,14 @@ static int osiris_dvs_notify(struct notifier_block *nb,
>  
>  	switch (val) {
>  	case CPUFREQ_PRECHANGE:
> -		if (old_dvs & !new_dvs ||
> -		    cur_dvs & !new_dvs) {
> +		if ((old_dvs && !new_dvs) || (cur_dvs && !new_dvs)) {
>  			pr_debug("%s: exiting dvs\n", __func__);
>  			cur_dvs = false;
>  			gpio_set_value(OSIRIS_GPIO_DVS, 1);
>  		}
>  		break;
>  	case CPUFREQ_POSTCHANGE:
> -		if (!old_dvs & new_dvs ||
> -		    !cur_dvs & new_dvs) {
> +		if ((!old_dvs && new_dvs) || (!cur_dvs && new_dvs)) {
>  			pr_debug("entering dvs\n");
>  			cur_dvs = true;
>  			gpio_set_value(OSIRIS_GPIO_DVS, 0);
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

