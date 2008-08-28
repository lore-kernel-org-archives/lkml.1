Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYH1Dqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYH1Dqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 23:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYH1Dq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 23:46:26 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:32288 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYH1DqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 23:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=pSX4eYOpH32Lb9mLdX67+IK3n7LKUDhUAWvXE1l43OojTl0nZhjYtlzPe3y2Omjs8A
         mWNUsCC+uShUbr9a6xwLUPI+mAfkS8heuzQ+scV1PAioxqkemkngIP7h6S+vPAvcCqgM
         OUjOCXu0d63AfMkCvk90R9DSOSJrwl6lHc6Io=
Message-ID: <386072610808272046u270c1302g1102bf1f0bd9b6ee@mail.gmail.com>
Date: Thu, 28 Aug 2008 11:46:24 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Bryan Wu" <cooloney@kernel.org>, perex@perex.cz, lrg@kernel.org,
       "Cliff Cai" <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 3/4] ASOC: WM8731 codec: add SPI support as well as I2C
In-Reply-To: <20080827110143.GB10834@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org>
	 <1219829968-6431-4-git-send-email-cooloney@kernel.org>
	 <20080827110143.GB10834@sirena.org.uk>
X-Google-Sender-Auth: 79ce67851236e052
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 7:01 PM, Mark Brown <broonie@sirena.org.uk> wrote:
> On Wed, Aug 27, 2008 at 05:39:27PM +0800, Bryan Wu wrote:
>
> This looks good, thanks but...
>
>> -#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
>> +#if defined (CONFIG_I2C) || defined (CONFIG_I2C_MODULE) && !defined (CONFIG_SND_SOC_WM8731_SPI)
>>       if (setup->i2c_address) {
>>               normal_i2c[0] = setup->i2c_address;
>>               codec->hw_write = (hw_write_t)i2c_master_send;
>> @@ -688,8 +745,14 @@ static int wm8731_probe(struct platform_device *pdev)
>>               if (ret != 0)
>>                       printk(KERN_ERR "can't add i2c driver");
>>       }
>> +#elif defined (CONFIG_SPI_MASTER) && defined (CONFIG_SND_SOC_WM8731_SPI)
>> +     codec->hw_write = (hw_write_t)wm8731_spi_write;
>> +     ret = spi_register_driver(&wm8731_spi_driver);
>> +     if (ret != 0)
>> +             printk(KERN_ERR "can't add spi driver");
>
> ...as for the SSM2602 it'd be good if it were possible to build a kernel
> which supports both I2C and SPI.  If you like I could do this for you -
> there's likely to be merge issues due to the update to the new I2C API
> anyway?
>

Oh, do you mean SSM2602 or WM8731? I also noticed the i2c API updates
patch from Jean and I'd like to use the new one

Thanks
-Bryan
