Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbZE1Orj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbZE1Orj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZE1Orc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:47:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:21288 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZE1Orb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:47:31 -0400
MIME-Version: 1.0
In-Reply-To: <20090528141743.GA16199@trinity.fluff.org>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> 
	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> 
	<4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> 
	<4A1D8FBA.6040802@freescale.com> <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> 
	<20090528141743.GA16199@trinity.fluff.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 28 May 2009 08:47:13 -0600
Message-ID: <fa686aa40905280747l2b1c36b9q2d99d145d05dba@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Ben Dooks <ben-linux@fluff.org>
Cc: Jon Smirl <jonsmirl@gmail.com>, Scott Wood <scottwood@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 8:17 AM, Ben Dooks <ben-linux@fluff.org> wrote:
> On Wed, May 27, 2009 at 03:13:55PM -0400, Jon Smirl wrote:
>> On Wed, May 27, 2009 at 3:08 PM, Scott Wood <scottwood@freescale.com> wrote:
>> > I'm not talking about platform specific code, I'm talking about code to
>> > retrieve information about a device from the device tree.  There would not
>> > be separate instances of this for "platforms X, Y and Z", just one
>> > of_platform binding in each driver.  It's no different than having a
>> > platform bus binding, except in the data structures used.
>> >
>> > But to restate, having external glue to create platform devices from the
>> > device tree is fine if that's what you want to do.  We used to do that, but
>> > it was a pain compared to keeping everything in one place.  Your experience
>> > may differ.
>>
>> Could 'struct platform_device' and 'struct of_platform_device" be
>> unified into a single structure? It's personal preference whether the
>> internal representation of the hardware is done via a device tree or
>> snippets of platform code, but do we need to have to different device
>> types?
>
> I was wondering what the pros/cons of having a system that takes a
> device tree and manufactures platform devices / etc from it? I think
> one of the cons is that if you change the platform device data, then
> you have not only the board definitions to change, but the of->platform
> code to modify as well...

Yes, this is the long term goal.  And not just platform devices
either, i2c, spi, mdio, etc.  The current problem is that there still
needs to be a per-driver mechanism to translate device tree data into
the correct pdata structure.  That code is not hard, but it is
undetermined what is best for where that code should live and how it
should be triggered.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
