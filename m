Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZGWI3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZGWI3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZGWI3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:29:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:52927 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZGWI3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b9C9mvwtXvdSph1cB2D9gcGmBCswG1tJO8zTGucvi4L1RoX1sA9HSjo40f/AD4Bx7E
         8jhuzhqtvwnZqnqufIGP4ILwO9HO8Ex5I3Nr89B7KyR+6Ul9BpPFhJ8ly3K9l46UpXA/
         lvhMRM2HUwFpTPS8HMdI3UThn1NTyqzjfFp1Y=
Date: Thu, 23 Jul 2009 01:29:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@googlemail.com>, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
Message-ID: <20090723082904.GE3997@dtor-d630.eng.vmware.com>
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com> <cone.1247683003.40459.21332.1000@deskpiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1247683003.40459.21332.1000@deskpiie>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 08:36:43PM +0200, Peter Feuerer wrote:
> Works fine here, thanks!
>
> Acked-by: Peter Feuerer <peter@piie.net>

Umm, did you test suspend-to-disk? As far as I understand the new
suspend() and resume() methods are onluy used for S2R and for S2D you need
to use freeze() and thaw().

>
> Borislav Petkov writes:
>
>> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
>> ---
>>  drivers/platform/x86/acerhdf.c |   14 +++++++++-----
>>  1 files changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
>> index aa298d6..561b471 100644
>> --- a/drivers/platform/x86/acerhdf.c
>> +++ b/drivers/platform/x86/acerhdf.c
>> @@ -435,7 +435,7 @@ struct thermal_cooling_device_ops acerhdf_cooling_ops = {
>>  };
>>   /* suspend / resume functionality */
>> -static int acerhdf_suspend(struct platform_device *dev, pm_message_t state)
>> +static int acerhdf_suspend(struct device *dev)
>>  {
>>  	if (kernelmode)
>>  		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
>> @@ -446,7 +446,7 @@ static int acerhdf_suspend(struct platform_device *dev, pm_message_t state)
>>  	return 0;
>>  }
>>  -static int acerhdf_resume(struct platform_device *device)
>> +static int acerhdf_resume(struct device *dev)
>>  {
>>  	if (verbose)
>>  		pr_notice("resuming\n");
>> @@ -464,15 +464,19 @@ static int acerhdf_remove(struct platform_device *device)
>>  	return 0;
>>  }
>>  +static struct dev_pm_ops acerhdf_pm_ops = {
>> +	.suspend = acerhdf_suspend,
>> +	.resume	 = acerhdf_resume,
>> +};
>> +
>>  static struct platform_driver acerhdf_driver = {
>>  	.driver = {
>> -		.name = "acerhdf",
>> +		.name  = "acerhdf",
>>  		.owner = THIS_MODULE,
>> +		.pm    = &acerhdf_pm_ops,
>>  	},
>>  	.probe = acerhdf_probe,
>>  	.remove = acerhdf_remove,
>> -	.suspend = acerhdf_suspend,
>> -	.resume = acerhdf_resume,
>>  };
>>   

-- 
Dmitry
