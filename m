Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZBVKf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZBVKf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 05:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbZBVKfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 05:35:48 -0500
Received: from mx0.towertech.it ([213.215.222.73]:59435 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753338AbZBVKfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 05:35:47 -0500
Date: Sun, 22 Feb 2009 11:35:44 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: PCF8583 not detected on RiscPC
Message-ID: <20090222113544.4501f06a@i1501.lan.towertech.it>
In-Reply-To: <20090222095150.GA28025@n2100.arm.linux.org.uk>
References: <20090221194814.GA24385@n2100.arm.linux.org.uk>
	<20090221204147.GA25408@n2100.arm.linux.org.uk>
	<20090222011936.35b21d6b@i1501.lan.towertech.it>
	<20090222082829.GG16596@n2100.arm.linux.org.uk>
	<20090222104205.4539d3ef@i1501.lan.towertech.it>
	<20090222095150.GA28025@n2100.arm.linux.org.uk>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009 09:51:50 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> >   That's very simple, even if acorn is a bit unstructured. You just
> >  need to choice a place under arch/arm that you like
> >  (arch/arm/plat-acorn/ ? ) and place a bit of code called
> >  by an appropriate initcall. 
> 
> Thanks.
> 
> If it is as simple as you are suggesting, why wasn't it done _before_
> breaking the RTC support?

 I guess because who did the modification didn't know
 it was used on acorn and nor did I.

 
> After all, you know damned well that PCF8583 is used on ARM and you
> know the config symbol for the platform, especially as you pointedly
> remove the dependencies on CONFIG_ARCH_RPC from the driver inspite of
 
 ????


> it being full of platform specifics (location of year byte in CMOS
> and the checksum algorithm and checksum location.)
> 
> The only reason I can think is pure and simple spite.

 what??? The driver has been introduced in 9c0c570576d02000063e28faadcce8c07396755d
 without any platform specific ifdef or depend in Kconfig and I never saw it before that
 commit. 

 If any change was ever proposed to make it platform specific (so that it would
 have worked only on a single platform) at any later time I'm pretty sure I
 wouldn't have acked it.

 It was described as:

 "A port of the driver for the pcf8583 i2c rtc controller to the generic RTC
 framework by Alessandro Zummo. Based on
 drivers/acorn/char/{pcf8583.[hc],i2c.c}. Hopefully, acorn can be converted
 too to use this driver in the future."

 and you were on the Cc list. I don't know who converted the acorn platform to
 use it and I can't care less. Who did should have checked the driver 
 for compatibility with his own platform before migrating from the driver under
 drivers/char/ .

 As far as I can see with git log, you applied changes to the driver
 multiple times, without having me in Cc nor G. Liakhovetski (who did the port).

 So, before accusing people, do you homework with a simple
 git log drivers/rtc/rtc-pcf8583.c 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

