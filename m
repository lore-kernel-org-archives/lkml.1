Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbYH1Fzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbYH1Fzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 01:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYH1Fzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 01:55:35 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:17092 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYH1Fze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 01:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=I7RFjaw3ynkYjEiNED70C3Tu0OhoUopOXs+06I4brIHHeZfqtE2kYjTqPLXop4cGJT
         z3lX311iiAX+4Fj93OJIIRC9ksYQVZTUDnwOo9qsn3cVw6eX7w/7P/97HozU8RPS1uPt
         DUUHpNMqxyZLVaZD9DJtM6wBzFSUPBPi1Tjys=
Message-ID: <386072610808272255o7ef18860u29e10727e6e11a11@mail.gmail.com>
Date: Thu, 28 Aug 2008 13:55:33 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Bryan Wu" <cooloney@kernel.org>, perex@perex.cz, lrg@kernel.org,
       "Cliff Cai" <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2/4] ASOC codec: add support for SSM2602 audio codec in ALSA SoC framework
In-Reply-To: <20080827105456.GA10834@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org>
	 <1219829968-6431-3-git-send-email-cooloney@kernel.org>
	 <20080827105456.GA10834@sirena.org.uk>
X-Google-Sender-Auth: bb39aadf5f7aa869
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 6:54 PM, Mark Brown <broonie@sirena.org.uk> wrote:
> On Wed, Aug 27, 2008 at 05:39:26PM +0800, Bryan Wu wrote:
>
> This looks basically good, thanks - I've picked up a few things below
> but they are mostly either minor or reflect the fact that the patch
> looks like it's been developed against current release kernels but
> there's been some churn recently in the ASoC APIs which need updates.
>
>>  #define I2C_DRIVERID_CS5345  96      /* cs5345 audio processor       */
>> +#define I2C_DRIVERID_SSM2602 97      /* BF52xC built in audio codec */
>
> It should be possible to just remove this - it shouldn't be needed.
>

OK, I'll take care of this i2c stuff here.

>> --- a/sound/soc/codecs/Kconfig
>> +++ b/sound/soc/codecs/Kconfig
>
> Current kernels have a Kconfig option SND_SOC_ALL_CODECS which should
> have your codec added - this allows codec drivers to be built without
> boards for test purposes.
>
Is this option in alsa git tree or in the mainline? I fail to find it
in upstream mainline.
And do you mean I don't need to add SND_SOC_SSM2602 at all?

>> +#define SSM2602_DEBUG 0
>> +
>> +#ifdef SSM2602_DEBUG
>> +#define dbg(format, arg...) \
>> +     printk(KERN_DEBUG AUDIO_NAME ": " format "\n" , ## arg)
>> +#else
>> +#define dbg(format, arg...) do {} while (0)
>> +#endif
>> +#define err(format, arg...) \
>> +     printk(KERN_ERR AUDIO_NAME ": " format "\n" , ## arg)
>> +#define info(format, arg...) \
>> +     printk(KERN_INFO AUDIO_NAME ": " format "\n" , ## arg)
>> +#define warn(format, arg...) \
>> +     printk(KERN_WARNING AUDIO_NAME ": " format "\n" , ## arg)
>
> Please convert these to use the standard pr_ macros (or ideally the dev_
> ones where possible) for debug prints.
>

Right, I killed this local definition and replaced them to pr_xxxx.

>> +
>> +#define ssm2602_reset(c)     ssm2602_write(c, SSM2602_RESET, 0)
>> +/*Appending several "None"s just for OSS mixer use*/
>> +static const char *ssm2602_input_select[] = {"Line", "Mic", "None", "None", "None",
>> +             "None", "None", "None"};
>> +static const char *ssm2602_deemph[] = {"None", "32Khz", "44.1Khz", "48Khz"};
>
> Please keep the lines under 80 characters where reasonable.  A little
> more while space (blank lines and at the start and end of comments)
> would be nice too.
>

Yes, I will fix this issue by running checkpatch.pl. And for other API
conflicts and I2C interface upgrading stuffs,
I will leave them to Cliff.

Thanks
-Bryan
