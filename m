Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZIGOwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZIGOwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZIGOwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:52:36 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:40913 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZIGOwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:52:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=mcRJAjqr5c+cAOiPPG6Eb+1KuOubvgMT/VvOKU6iyn3gNljnAhFtlBHYnHbpRmoMyl
         q+9aTYdNQY7F64MjUz0NvL90fNHJV1+xm3VVYPuzHr++IGmr7+NDVmuKlJbNlzn9C4GI
         UNz0xzxqOCBrA0KQVUaLdhwEY18/GWdiz7UIM=
MIME-Version: 1.0
In-Reply-To: <1252332440.17852.58.camel@dax.rpnet.com>
References: <20090906052653.GB1324@ucw.cz> <1252276145.17852.15.camel@dax.rpnet.com> 
	<20090907113132.GM23450@elf.ucw.cz> <1252329025.1861.6.camel@hammer.suse.cz> 
	<1252332440.17852.58.camel@dax.rpnet.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 7 Sep 2009 22:52:18 +0800
Message-ID: <f17812d70909070752k5a90f5fcv5078ffe3a5ccba91@mail.gmail.com>
Subject: Re: Zaurus suspend saga
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Stanislav Brabec <utx@penguin.cz>, Pavel Machek <pavel@ucw.cz>,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 7, 2009 at 10:07 PM, Richard Purdie<rpurdie@rpsys.net> wrote:
> On Mon, 2009-09-07 at 15:10 +0200, Stanislav Brabec wrote:
>> Pavel Machek wrote:
>> >
>> > > Sadly lack of time means I've lost track of the Zaurus kernels but this
>> > > sounds like all accesses to the SSP buses now go through the SPI layer
>> > > and when it was converted nobody thought about the impact this would
>> > > have on the Zaurus charger code.
>> >
>> >Unfortunately... Do you have any idea when this conversion took place?
>>
>> In past, MAX1111 driver was embedded in the Zaurus specific code. Now
>> MAX1111 is a generic SPI driver and spitz_pm.c calls it.
>>
>> Maybe it will still work with CONFIG_CORGI_SSP_DEPRECATED.
>
> I was thinking about this. The SSP interface is ridiculously simple and
> it might be worth just adding some SSP access code into the Zaurus
> offline code so it can access the MAX1111 without the rest of the system
> running. That would solve a lot of the problems.
>

That simple SSP API made a lot of headaches as well. Now there are three
clearly separated individual drivers even on a single SPI bus controlling the
LCD, backlight and the MAX1111 sensor instead of all those dirty tricks
messing up. And it was really a painful memory to touch that part of the
code and get it cleaned up.
