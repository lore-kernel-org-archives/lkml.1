Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbYELGeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbYELGeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 02:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYELGdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 02:33:54 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:8227 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbYELGdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 02:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nLh75fU6OYTsG8Ci4VVFDGeAV0cmlxwEqN57mX8Oe5ToYcGkaXYYdfnSYTA8Utkhxy2RTKSnpZxQ8VK18a0S1LNSLQ4MupeRz5kcscwy09rWL+r/BEqst9ON6mAJSe9Jldaz54x73xknnpnn5hXooZulUF+RA5WovCkksINocyw=
Message-ID: <386072610805112333w7bc935eo4ad0aae47b1c3975@mail.gmail.com>
Date: Mon, 12 May 2008 14:33:50 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH 1/1] Input/Touchscreen Driver: add support AD7877touchscreen driver
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Bryan Wu" <bryan.wu@analog.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <8A42379416420646B9BFAC9682273B6D56269C@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202980649-13309-1-git-send-email-bryan.wu@analog.com>
	 <20080407161007.ZZRA012@mailhub.coreip.homeip.net>
	 <8A42379416420646B9BFAC9682273B6D56269C@limkexm3.ad.analog.com>
X-Google-Sender-Auth: decf8a4380d9d2ec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2008 at 1:13 AM, Hennerich, Michael
<Michael.Hennerich@analog.com> wrote:
>
>
>>-----Original Message-----
>>From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
>>Sent: Montag, 7. April 2008 22:16
>>To: Bryan Wu
>>Cc: linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Michael
>>Hennerich
>>Subject: Re: [PATCH 1/1] Input/Touchscreen Driver: add support
>>AD7877touchscreen driver
>>
>>Hi Bryan, Michael,
>>
>>On Thu, Feb 14, 2008 at 05:17:28PM +0800, Bryan Wu wrote:
>>> From: Michael Hennerich <michael.hennerich@analog.com>
>>>
>>> [try #3] Changlog (Add feedback from Dmitry Torokhov):
>>>  - Change handling of spi_sync / spi_async return value handling
>>>  - Remove depreciated dev->power.power_state
>>>  - Fix error return path in ad7877_probe
>>>  - delete pending kernel timer
>>>  - Some minor cleanup (indention, use dev_err etc.)
>>
>>Sorry for the long silence... I have a couple of comments at the moment
>>but I am sure i will have more ;)
>>
>>> +
>>> +    status = spi_sync(spi, &req->msg);
>>> +
>>> +    if (status == 0)
>>> +            status = req->msg.status;
>>> +
>>> +    kfree(req);
>>> +    return status ? status : req->sample;
>>
>>Use after free here.
>
> Yeah this is definitely broken.
>
>>
>>> +
>>> +    ts->irq_disabled = 1;
>>> +    disable_irq(spi->irq);
>>
>>I am a bit uneasy here... do we need to wait for an async spi
> completion
>>here before proceeding? Overall I have some concerns about the
>>irq/spi/removal/sysfs iteractions, I will need some more time to look
>>through the driver.
>
>
> I think you are right - let me come up with a patch.
>
> Thanks and best regards,
> Michael
>
>>

Hi Dmitry,

Sorry for no updates, I forget to send out that patch, although
Michael fixed the driver as your review.

So need I send out one updated patch including Michael's fixing or
just send out his incremental patch？

Thanks
-Bryan
