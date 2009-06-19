Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbZFSLGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbZFSLGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 07:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbZFSLGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 07:06:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:56868 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbZFSLGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 07:06:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZaZtbE7pVTMWEvqmQcCANEm/3gTzUwCyGodYYHJ/frrSdXJmP5HpJxZMKeSH83TBuB
         ABIRONHur/7OrqKuRTKLH6vuoVuUFRTBHny47PvUtkwBHdfBqWOufh4+fGw8OCXCMkw3
         vf6IQ9YlXIkGxmpAoa6wRVV5rT1+2J57cbyVw=
MIME-Version: 1.0
In-Reply-To: <20090619104738.GF5270@sirena.org.uk>
References: <1245403695-20537-1-git-send-email-21cnbao@gmail.com> 
	<20090619104738.GF5270@sirena.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 19 Jun 2009 07:05:48 -0400
Message-ID: <8bd0f97a0906190405k33503d8ekd74ec9ddbb2fde12@mail.gmail.com>
Subject: Re: [PATCH] New ASoC Drivers for ADI AD1938 codec
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Barry Song <21cnbao@gmail.com>, lrg@slimlogic.co.uk,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 06:47, Mark Brown wrote:
> On Fri, Jun 19, 2009 at 05:28:15PM +0800, Barry Song wrote:
>> 1. add AD1938 codec driver                   (codec)
>> 2. add blackfin SPORT-TDM DAI and PCM driver (platform)
>> 3. add bf5xx board with AD1938 driver        (machine)
>
> As Liam said you really need to submit this as a patch series rather
> than as a single big patch - as your commit log here indicates you've
> got several different things going on here.

blah, i had this queued locally with a "todo:split".  wanted to wait
for Barry to finish developing the driver first though.

at any rate, i hate to sound like a broken record wrt my alsa
ignorance, but i'm thinking the logical split would be like Barry
numbered it -- one patch for sound/codec/, one patch for the TDM
transport, and one patch for hooking up the AD1938 to TDM.

>> +static int __devinit ad1938_spi_probe(struct spi_device *spi)
>> +{
>> +     spi->dev.power.power_state = PMSG_ON;
>> +     ad1938_socdev->card->codec->control_data = spi;
>> +
>> +     return 0;
>> +}
>> +
>> +static int __devexit ad1938_spi_remove(struct spi_device *spi)
>> +{
>> +     return 0;
>> +}
>
> Your device probing should all be restructured so that the SPI device
> for the CODEC is registered as any other SPI device rather than being
> set up as part of probing the ASoC device.  See the wm8731 driver for
> an example of doing this for a SPI device.
>
> This will require that the arch code for any systems with the ad1938
> do the setup of the device.

so should sound/soc/blackfin/bf5xx-ad1938.c even exist in the first place ?
-mike
