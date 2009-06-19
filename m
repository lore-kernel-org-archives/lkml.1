Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbZFSLWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbZFSLWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 07:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZFSLWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 07:22:03 -0400
Received: from mail-yx0-f177.google.com ([209.85.210.177]:35295 "EHLO
	mail-yx0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbZFSLWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 07:22:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xOEom01Oh9DFTDZAr3UKsm1JSiYYfKVZ1Lv0PDWZEu3GxCBbWEqCu0YmbgKzuf4hxg
         IjkWJa0RA+m4u+RWtZ1qFUPF5zBE6562tqqxCMnKrvVK6PUbEhouoV54fI96ufvpcgI+
         uiIcD1HioV3va+BHwspPAtv9tAmug1kAH+9dI=
MIME-Version: 1.0
In-Reply-To: <A40FAF28-889C-4322-A114-098EEA56FCE6@opensource.wolfsonmicro.com>
References: <1245403695-20537-1-git-send-email-21cnbao@gmail.com> 
	<20090619104738.GF5270@sirena.org.uk> <8bd0f97a0906190405k33503d8ekd74ec9ddbb2fde12@mail.gmail.com> 
	<A40FAF28-889C-4322-A114-098EEA56FCE6@opensource.wolfsonmicro.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 19 Jun 2009 07:21:44 -0400
Message-ID: <8bd0f97a0906190421q332f337cr1799c6b65bd06f0e@mail.gmail.com>
Subject: Re: [PATCH] New ASoC Drivers for ADI AD1938 codec
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Barry Song <21cnbao@gmail.com>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 07:13, Mark Brown wrote:
> On 19 Jun 2009, at 12:05, Mike Frysinger wrote:
>> On Fri, Jun 19, 2009 at 06:47, Mark Brown wrote:
>>> On Fri, Jun 19, 2009 at 05:28:15PM +0800, Barry Song wrote:
>>>> 1. add AD1938 codec driver                   (codec)
>>>> 2. add blackfin SPORT-TDM DAI and PCM driver (platform)
>>>> 3. add bf5xx board with AD1938 driver        (machine)
>>>
>>> As Liam said you really need to submit this as a patch series rather
>>> than as a single big patch - as your commit log here indicates you've
>>> got several different things going on here.
>>
>> blah, i had this queued locally with a "todo:split".  wanted to wait
>> for Barry to finish developing the driver first though.
>>
>> at any rate, i hate to sound like a broken record wrt my alsa
>> ignorance, but i'm thinking the logical split would be like Barry
>> numbered it -- one patch for sound/codec/, one patch for the TDM
>> transport, and one patch for hooking up the AD1938 to TDM.
>
> Yes, though if the new DAI format had been required it would be worth
> considering a separate patch for it.

OK, Barry can handle this, otherwise i'll split it up in my git and
send him the repo info

>>>> +static int __devinit ad1938_spi_probe(struct spi_device *spi)
>>>> +{
>>>> +     spi->dev.power.power_state = PMSG_ON;
>>>> +     ad1938_socdev->card->codec->control_data = spi;
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +static int __devexit ad1938_spi_remove(struct spi_device *spi)
>>>> +{
>>>> +     return 0;
>>>> +}
>>>
>>> Your device probing should all be restructured so that the SPI device
>>> for the CODEC is registered as any other SPI device rather than being
>>> set up as part of probing the ASoC device.  See the wm8731 driver for
>>> an example of doing this for a SPI device.
>>>
>>> This will require that the arch code for any systems with the ad1938
>>> do the setup of the device.
>>
>> so should sound/soc/blackfin/bf5xx-ad1938.c even exist in the first place
>> ?
>
> Yes. It is needed in order to specify how things are hooked up on a given
> board.

to look at the wm8731 then, these are good examples of how it's done ?
sound/soc/atmel/sam9g20_wm8731.c
sound/soc/pxa/corgi.c
-mike
