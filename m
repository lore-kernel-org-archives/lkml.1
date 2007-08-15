Return-Path: <linux-kernel-owner+w=401wt.eu-S1760826AbXHONj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbXHONj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbXHONjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:39:18 -0400
Received: from roc.holo.8d.com ([64.254.227.115]:38106 "EHLO roc.holo.8d.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484AbXHONjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:39:17 -0400
X-Greylist: delayed 2343 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 09:39:17 EDT
Message-ID: <46C2F8C9.6020806@8d.com>
Date: Wed, 15 Aug 2007 08:59:53 -0400
From: =?ISO-8859-1?Q?Rapha=EBl_Ass=E9nat?= <raph@8d.com>
User-Agent: Mozilla Thunderbird 1.0 (X11/20050118)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Mike Rapoport <mike@compulab.co.il>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RTC v3020 fixes
References: <46C292F2.1050401@compulab.co.il>
In-Reply-To: <46C292F2.1050401@compulab.co.il>
X-Enigmail-Version: 0.89.5.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.2
X-Spam-Report: -2.2 points, 5.0 required autolearn=ham
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.4 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Rapoport wrote:
> Fix off-by-one in month calculations
> Add delay for bus accesses to satisfy Tw > 500ns
> 
*snip*
> @@ -135,7 +140,7 @@ static int v3020_set_time(struct device *dev, struct 
> rtc_time *dt)
>      v3020_set_reg(chip, V3020_MINUTES,     BIN2BCD(dt->tm_min));
>      v3020_set_reg(chip, V3020_HOURS,     BIN2BCD(dt->tm_hour));
>      v3020_set_reg(chip, V3020_MONTH_DAY,    BIN2BCD(dt->tm_mday));
> -    v3020_set_reg(chip, V3020_MONTH,     BIN2BCD(dt->tm_mon));
> +    v3020_set_reg(chip, V3020_MONTH,     BIN2BCD(dt->tm_mon) + 1);

This should be BIN2BCD(dt->tm_mon + 1)) instead. Otherwise, in october (month 
9), the final value will be 0xa instead of 0x10.

Other than that, the patch looks fine to me. You can add
Acked-by: Raphael Assenat <raph@8d.com> to the updated patch.

Please add Alessandro Zummo <a.zummo@towertech.it> in the CC list to make sure 
he sees it.

Best regards,
Raphaël Assénat
