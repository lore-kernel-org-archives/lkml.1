Return-Path: <linux-kernel-owner+w=401wt.eu-S1751832AbZIGUgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbZIGUgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 16:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZIGUgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 16:36:19 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:59494 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZIGUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 16:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eZuNpilfwbLRJu48jSyteRGGa92xWSOJHcvq7PaDkedVkGqWCbT//weqzmngzX6GP+
         /akLGKNr0bE/zQFROaeX8mN0qf/Nsd8+mEXDRZzrQYo1sTTLEbODh/3f0G88wXxR1ANg
         QBRhVqg6jy3Iq/CK6PA3kLrZrWHz7mhddw/HY=
MIME-Version: 1.0
In-Reply-To: <1252332440.17852.58.camel@dax.rpnet.com>
References: <20090906052653.GB1324@ucw.cz>
	 <1252276145.17852.15.camel@dax.rpnet.com>
	 <20090907113132.GM23450@elf.ucw.cz>
	 <1252329025.1861.6.camel@hammer.suse.cz>
	 <1252332440.17852.58.camel@dax.rpnet.com>
Date: Tue, 8 Sep 2009 00:36:21 +0400
Message-ID: <bc64b4640909071336t3500a9fcq4226efacc4808c65@mail.gmail.com>
Subject: Re: Zaurus suspend saga
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Stanislav Brabec <utx@penguin.cz>, Pavel Machek <pavel@ucw.cz>,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 7, 2009 at 6:07 PM, Richard Purdie<rpurdie@rpsys.net> wrote:
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
> Its not as if any other hardware is going to come along and reuse this
> as the Zaurus hardware line is dead.

The major source of problems w/ tosa suspend/resume (hangs, instant
resume, etc.)
was connected to the second driver for ac97 bus beings present just for "touch
ADC when all other parts are asleep". It was really PITA to even try
to debug that.

The "simple SSP" driver "just for being suspended" would be a
nightmare also (IMO).

-- 
With best wishes
Dmitry
