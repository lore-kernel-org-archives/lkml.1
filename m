Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZG2PdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZG2PdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZG2PdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:33:10 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55421 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZG2PdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:33:09 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2009 11:33:08 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dC2Lkd1qs86Is40hLHLVQTwu8sl6TsKE/o4djT+3eRWnnqdMdwJr8vHG2rlUD1BHLN
         fcdxvJ8eGLnHmPCVzMrW/E6gkLLaJP/Yb15B86INezOL8rFdpR3CQ8NNJp19rgzvrmD0
         HTkTJLLqynMX7IR7Asgn7YoTMZVHEhw+POhyg=
MIME-Version: 1.0
In-Reply-To: <aec7e5c30907290824p5e20fb14g3d14aece2d3e33c6@mail.gmail.com>
References: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
	 <74d0deb30907290820x13214f68u82dea4ad229ebdac@mail.gmail.com>
	 <aec7e5c30907290824p5e20fb14g3d14aece2d3e33c6@mail.gmail.com>
Date: Wed, 29 Jul 2009 17:33:08 +0200
Message-ID: <74d0deb30907290833m3d1ff596s180759fb961a8a8d@mail.gmail.com>
Subject: Re: [PATCH] tmio_mmc: Optionally support using platform clock
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Ian Molton <ian@mnementh.co.uk>, linux-kernel@vger.kernel.org,
       Magnus Damm <damm@opensource.se>, akpm@linux-foundation.org,
       Matt Fleming <matt@console-pimps.org>,
       Philip Langdale <philipl@overt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 5:24 PM, Magnus Damm<magnus.damm@gmail.com> wrote:
> On Thu, Jul 30, 2009 at 12:20 AM, pHilipp Zabel<philipp.zabel@gmail.com> wrote:
>> On Tue, Jul 28, 2009 at 9:51 AM, Guennadi
>> Liakhovetski<g.liakhovetski@gmx.de> wrote:
>>> If the platform device has a clock associated with the tmio-mmc device,
>>> use it.
>>>
>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>> Cc: Magnus Damm <damm@opensource.se>
>>> ---
>>>
>>> Depends (at least logically) on
>>> http://marc.info/?l=linux-kernel&m=124782904228865&w=2
>>>
>>> Sorry if I forgot anyone who volunteered to help out with MMC patches.
>>>
>>>  drivers/mmc/host/tmio_mmc.c |   21 +++++++++++++++++++++
>>>  drivers/mmc/host/tmio_mmc.h |    3 +++
>>>  include/linux/mfd/tmio.h    |    1 +
>>>  3 files changed, 25 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
>>> index c246191..2a01572 100644
>>> --- a/drivers/mmc/host/tmio_mmc.c
>>> +++ b/drivers/mmc/host/tmio_mmc.c
>>> @@ -567,6 +576,11 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
>>>                        goto unmap_cnf;
>>>        }
>>>
>>> +       host->clk = clk_get(&dev->dev, pdata->clk_name);
>>
>> Instead of pdata->clk_name, this should be either NULL or better
>> "HCLK" (to differentiate from CLK32, not sure if we want to be able to
>> toggle that, too, in the future).
>> Passing the clock consumer ID via pdata is just wrong and shouldn't be
>> needed with clkdev.
>
> Really? I think that depends on the clock framework implementation.
> Remember that this needs to work on other architectures than just ARM.

Oh, clkdev is an ARM only thing. Maybe it would be worthwile to make
this even more generic instead?

regards
Philipp
