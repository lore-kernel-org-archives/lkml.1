Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329Ab0ALAWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0ALAWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313Ab0ALAWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:22:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:44802 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752893Ab0ALAWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:22:09 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18JyqcI5SoJmtm1KZauQvuWJ+g+DbUEF4k8cV8id0
	SXqsEEm9aBsjmW
Message-ID: <4B4BC0AA.5080209@gmx.de>
Date: Tue, 12 Jan 2010 01:22:02 +0100
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Erik-Jan Post <ej.lfs@xs4all.nl>
Subject: Re: [PATCH 3/4] viafb: do modesetting after updating variables
References: <1262732399-3416-1-git-send-email-FlorianSchandinat@gmx.de>	<1262732399-3416-2-git-send-email-FlorianSchandinat@gmx.de>	<1262732399-3416-3-git-send-email-FlorianSchandinat@gmx.de> <20100111134644.bf26dd07.akpm@linux-foundation.org>
In-Reply-To: <20100111134644.bf26dd07.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton schrieb:
> On Tue,  5 Jan 2010 22:59:58 +0000
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
>> viafb: do modesetting after updating variables
>>
>> Reorder viafb_set_par to allow using the updated variables in
>> viafb_setmode. This fixes a regression that prevented proper
>> runtime mode changes.
>>
>> Signed-off-by: Erik-Jan Post <ej.lfs@xs4all.nl>
>> Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
>> ---
>>  drivers/video/via/viafbdev.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
>> index e16df84..f7ff4ea 100644
>> --- a/drivers/video/via/viafbdev.c
>> +++ b/drivers/video/via/viafbdev.c
>> @@ -174,15 +174,15 @@ static int viafb_set_par(struct fb_info *info)
>>  	}
>>  
>>  	if (vmode_entry) {
>> -		viafb_setmode(vmode_entry, info->var.bits_per_pixel,
>> -			vmode_entry1, viafb_bpp1);
>> -
>>  		viafb_update_fix(info);
>>  		viafb_bpp = info->var.bits_per_pixel;
>>  		if (info->var.accel_flags & FB_ACCELF_TEXT)
>>  			info->flags &= ~FBINFO_HWACCEL_DISABLED;
>>  		else
>>  			info->flags |= FBINFO_HWACCEL_DISABLED;
>> +
>> +		viafb_setmode(vmode_entry, info->var.bits_per_pixel,
>> +			vmode_entry1, viafb_bpp1);
>>  	}
>>  
>>  	return 0;
> 
> Problem.
> 
> Patches 2, 3 and 4 are appropriate to 2.6.33 - they fix regressions. 
> But all four patches are dependent upon patches which we already have
> queued for 2.6.34!

That are good news.

> I redid patches 2, 3 and 4 so they apply to current mainline.  This
> particular patch (3/4) needed fixing - please check the result.  
> 
> --- a/drivers/video/via/viafbdev.c~viafb-do-modesetting-after-updating-variables
> +++ a/drivers/video/via/viafbdev.c
> @@ -177,16 +177,15 @@ static int viafb_set_par(struct fb_info 
>  	}
>  
>  	if (vmode_index != VIA_RES_INVALID) {
> -		viafb_setmode(vmode_index, info->var.xres, info->var.yres,
> -			info->var.bits_per_pixel, vmode_index1,
> -			viafb_second_xres, viafb_second_yres, viafb_bpp1);
> -
>  		viafb_update_fix(info);
>  		viafb_bpp = info->var.bits_per_pixel;
>  		if (info->var.accel_flags & FB_ACCELF_TEXT)
>  			info->flags &= ~FBINFO_HWACCEL_DISABLED;
>  		else
>  			info->flags |= FBINFO_HWACCEL_DISABLED;
> +		viafb_setmode(vmode_index, info->var.xres, info->var.yres,
> +			info->var.bits_per_pixel, vmode_index1,
> +			viafb_second_xres, viafb_second_yres, viafb_bpp1);
>  	}
>  
>  	return 0;
> _

This is correct.

> This reordering broke viafb-split-global-index-up.patch, which I fixed up.

Thanks,


Florian Tobias Schandinat
