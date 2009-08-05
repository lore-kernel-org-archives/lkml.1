Return-Path: <linux-kernel-owner+w=401wt.eu-S933835AbZHEIZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835AbZHEIZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933730AbZHEIZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:25:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:61571 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933647AbZHEIZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:25:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QIXGxNptn8enOg+Z/g+e3lnjW9kG24T/eG+l+cvNvTMaUIMVi2FOj86I/oGhyUoiw1
         MCwUr2AgFHgOI0JmSPcZZNRCrrCI9NjkWxFKIhqCq79q41dueBd9+mmBnap7FSoJJRc4
         6yYULUwCsMW5H+RDcdAgLphCiXF0ljtQoarCQ=
MIME-Version: 1.0
In-Reply-To: <20090804204053.GA29518@sirena.org.uk>
References: <quadros.roger@gmail.com>
	 <1249408730-15430-1-git-send-email-quadros.roger@gmail.com>
	 <20090804204053.GA29518@sirena.org.uk>
Date: Wed, 5 Aug 2009 11:25:18 +0300
Message-ID: <b90c0690908050125u372ea4b8t8058235c32ad72a@mail.gmail.com>
Subject: Re: [PATCH v5] regulator: Add GPIO enable control to fixed voltage 
	regulator driver
From: Roger Quadros <quadros.roger@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: lrg@slimlogic.co.uk, philipp.zabel@gmail.com, linux-kernel@vger.kernel.org,
       felipe.balbi@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 4, 2009 at 11:40 PM, Mark
Brown<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Aug 04, 2009 at 08:58:50PM +0300, Roger Quadros wrote:
>> From: Roger Quadros <ext-roger.quadros@nokia.com>
>
>> Now fixed regulators that have their enable pin connected to a GPIO line
>> can use the fixed regulator driver for regulator enable/disable control.
>> The GPIO number and polarity information is passed through platform data.
>> GPIO enable control is achieved using gpiolib.
>
>> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
>
> Looks good, thanks for taking the time to do this and fixing up the
> review comments.
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> A couple of small notes that I don't see as blocking merge:
>
>> +
>> +             /* FIXME: Remove below print warning
>> +              *
>> +              * config->gpio must be set to -EINVAL by platform code if
>> +              * GPIO control is not required. However, early adopters
>> +              * not requiring GPIO control may forget to initialize
>> +              * config->gpio to -EINVAL. This will cause GPIO 0 to be used
>> +              * for GPIO control.
>> +              *
>> +              * This warning will be removed once there are a couple of users
>> +              * for this driver.
>
> Probably just for 2.6.33 or something; the point here is that this is an
> incompatible change in the platform data which we can get away with here
> due to the fact that there aren't any current users.
>
>> +             drvdata->is_enabled = config->enabled_at_boot;
>> +             ret = drvdata->is_enabled ?
>> +                             config->enable_high : !config->enable_high;
>
> Might be more legible without the ternery operator but no point spinning
> the patch for that.
>

Thank you all for review.

As reported by Liam, the patch does not apply on latest
git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git#for-next
Seems it moved on in the last 2 days when from which I based my patch on.

I will regenerate the patch against latest HEAD and resend.

cheers,
-roger
