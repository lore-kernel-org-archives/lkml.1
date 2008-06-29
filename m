Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbYF2Ue1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbYF2Ue1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYF2UeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 16:34:20 -0400
Received: from 203-96-159-182.paradise.net.nz ([203.96.159.182]:44730 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754705AbYF2UeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 16:34:19 -0400
Message-ID: <4867F1C6.2060201@bluewatersys.com>
Date: Mon, 30 Jun 2008 08:34:14 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: David Brownell <david-b@pacbell.net>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
References: <200806091541.43899.u.luckas@road.de>	<485031D5.3020606@bluewatersys.com>	<20080611141852.3ccd89ea@hyperion.delvare>	<200806111327.09298.david-b@pacbell.net>	<20080611225416.169574a0@hyperion.delvare>	<485042A6.3030705@bluewatersys.com>	<20080624183945.367c88cf@hyperion.delvare>	<48640656.9010802@bluewatersys.com> <20080627124143.23ac7b7b@hyperion.delvare>
In-Reply-To: <20080627124143.23ac7b7b@hyperion.delvare>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Ryan,
> 
> On Fri, 27 Jun 2008 09:12:54 +1200, Ryan Mallon wrote:
>> Jean Delvare wrote:
>>> I don't like option 2 at all. drivers/i2c/early could be, but not
>>> drivers/i2c-early.
>> I don't think its a good idea either. The point was that in order to
>> have two sets of i2c drivers with different link order (with regard to
>> the rest of the driver subsystems) you would need two top level
>> directories in drivers/.
> 
> I don't think so. Look at what the input subsystem does (from
> drivers/Makefile):
> 
> obj-$(CONFIG_SERIO)		+= input/serio/
> obj-$(CONFIG_GAMEPORT)		+= input/gameport/
> obj-$(CONFIG_INPUT)		+= input/
> 
> And there are similar examples with video (video/i810/ and
> video/intelfb/ are early in the list). 

Ah, didn't realise that.

>We could do the same with i2c:
> 
> obj-$(CONFIG_I2C)		+= i2c/early/
> 
> (... lots of things ...)
> 
> obj-$(CONFIG_I2C)		+= i2c/
> 
> Of course this implies minor edits to drivers/i2c/Makefile. I don't
> know if we want to do that, but from a technical point of view it seems
> doable.

That certainly is a better solution if it is needed.

> 
>> The other way of course, is to use one
>> directory, or subdirectories under drivers/i2c/ and use subsys_initcall.

Yeah, its probably the best solution for now. Doing the categorisation
of the busses will make it easy to split the directories/link order up
later if required.

>>> (...)
>>> If we are going to keep using subsys_initcall in bus drivers, then
>>> moving the bus drivers using it to a separate directory is not needed.
>>> Which doesn't mean we don't want to split the i2c bus drivers into
>>> subdirectories for other reasons, but I want to see this as a separate
>>> issue. BTW, I started categorizing the different types of i2c bus
>>> drivers:
>>> http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/i2c-group-bus-drivers.patch
>>> If you want to help with embedded stuff or SOC or whatever makes sense
>>> to group together, please do! For now, everything I am not familiar
>>> with is in group "Others".
>> I don't know all of the embedded systems, but at a glance the following
>> busses from your others section are used on embedded ARM processors:
>>
>> i2c-at91
>> i2c-davinci
>> i2c-ixp2000
>> i2c-omap
>> i2c-pxa
>> i2c-s3c2410
>> i2c-versatile
> 
> OK, I've moved these to a section titled "Embebbed system I2C host
> controller drivers", thanks.

Cool.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

       Ryan Mallon                              Unit 5, Amuri Park
       Phone: +64 3 3779127                     404 Barbadoes St
       Fax:   +64 3 3779135                     PO Box 13 889
       Email: ryan@bluewatersys.com             Christchurch, 8013
       Web:   http://www.bluewatersys.com       New Zealand
       Freecall Australia  1800 148 751         USA 1800 261 2934
