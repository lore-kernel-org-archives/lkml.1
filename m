Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbZE0Umk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbZE0Umk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZE0Umc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:42:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:52138 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZE0Umb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:42:31 -0400
MIME-Version: 1.0
In-Reply-To: <20090527163223.GE1970@sirena.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> 
	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<20090527150527.GK6805@pengutronix.de> <20090527163223.GE1970@sirena.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 May 2009 14:42:13 -0600
Message-ID: <fa686aa40905271342v5bc51665tb9b5d92950a43b82@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Timur Tabi <timur@freescale.com>, Janboe Ye <yuan-bo.ye@motorola.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:32 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, May 27, 2009 at 05:05:27PM +0200, Robert Schwebel wrote:
>
>> I'm highly convinced that the existence of oftree-hell in ARM-land would
>> have been *the* key motivation for FSL to have worked on mainline
>> instead of inhouse-BSPs back in 2004 when we mainlined i.MX1 and in 2007
>> when we started the mainline work on MX27 and MX31.
>
> I remain to be convinced about that but anyway..
>
>> Seriously: oftree in general is a good idea. Just that it doesn't work
>> in practise. The concept has some serious flaws:
>
>> - Platform data makes it possible to store function pointers. There
>>   is no equivalent to this concept in oftree-land.
>
> The handling of platform data is my main concern as someone working
> primarily on platform independant drivers - function pointers are a
> particular problem but the possibility of having to write code to
> handle both OF and non-OF systems to cater for systems using both
> approaches is also a concern for me.

Having a hook function which generates a pdata structure from a device
node on a per driver basis is a common approach.  Essentially, the
hook becomes an addon to the driver which doesn't impact the driver as
a whole.  i2c and SPI device tend to take this approach.

The other common pattern, usually used on platform drivers, is to
factor out the common code and use 2 separate bus binding blocks; one
for platform and one for of_platform.  It has some (low) impact on
driver structure, but not everyone likes this approach.

>> oftree could be a great tool if these things would be resolved.
>> Currently they are not, and in result, ARM just works and is easy,
>> whereas on PowerPC systems people often spend more time working on
>> binding stuff than on the actual functionality.
>
> This worries me too, my experiences with OF device tree handling for
> ASoC have been pretty negative - but then audio is one of the worst
> cases for handling within the device tree.

First steps are hard.  I2C and SPI work had similar groans and pains,
and ASoC is considerably more complex.  In the end the stuff in
drivers/of/* was added to handle the creation of i2c, spi and phy
devices from data in the device tree.  It is a mechanism which seems
to be working well.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
