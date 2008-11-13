Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbYKMI1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbYKMI1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYKMI0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:26:54 -0500
Received: from mail.atmel.fr ([81.80.104.162]:43190 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYKMI0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:26:53 -0500
Message-ID: <491BE4C6.2040109@atmel.com>
Date: Thu, 13 Nov 2008 09:26:46 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Julien Brunel <brunel@diku.dk>, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] drivers/video: Bad error test	before
 a dereference
References: <200809261553.45301.brunel@diku.dk> <49130E50.8090009@atmel.com>
In-Reply-To: <49130E50.8090009@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Nicolas Ferre :
> Julien Brunel :
>> The error test that follows the call to backlight_device_register
>> semms not to concern the right variable.
>>
>> A simplified version of the semantic match that finds this problem is
>> as follows: 
>> (http://www.emn.fr/x-info/coccinelle/)
>> // <smpl>
>> @def0@
>> expression x;
>> position p0;
>> @@
>> x@p0 = backlight_device_register(...)
>>
>> @protected@
>> expression def0.x,E;
>> position def0.p0;
>> position p;
>> statement S;
>> @@
>> x@p0
>> ... when != x = E
>> if (!IS_ERR(x) && ...) {<... x@p ...>} else S
>>
>> @unprotected@
>> expression def0.x;
>> identifier fld;
>> position def0.p0;
>> position p != protected.p;
>> @@
>> x@p0
>> ... when != x = E
>> * x@p->fld
>> // </smpl>
>>
>> Signed-off-by: Julien Brunel <brunel@diku.dk>
>> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

I do not know if you noticed this little patch but
I think it will be good if we can queue it for -final.

Do you want me to reformulate the submission or the
original email ok for you ?

>> ---
>>  drivers/video/atmel_lcdfb.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff -u -p a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
>> --- a/drivers/video/atmel_lcdfb.c
>> +++ b/drivers/video/atmel_lcdfb.c
>> @@ -132,7 +132,7 @@ static void init_backlight(struct atmel_
>>  
>>  	bl = backlight_device_register("backlight", &sinfo->pdev->dev,
>>  			sinfo, &atmel_lcdc_bl_ops);
>> -	if (IS_ERR(sinfo->backlight)) {
>> +	if (IS_ERR(bl)) {
>>  		dev_err(&sinfo->pdev->dev, "error %ld on backlight register\n",
>>  				PTR_ERR(bl));
>>  		return;

Thanks, regards,
-- 
Nicolas Ferre

