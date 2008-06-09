Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbYFIWJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbYFIWJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbYFIWJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:09:05 -0400
Received: from mail.bugwerft.de ([212.112.241.193]:39073 "EHLO
	mail.bugwerft.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbYFIWJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:09:04 -0400
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 18:09:03 EDT
From: Uli Luckas <u.luckas@road.de>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: Frame buffers and early i2c
Date: Mon, 9 Jun 2008 23:59:35 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, adaplas@gmail.com,
       Linux I2C <i2c@lm-sensors.org>
References: <200806091647.42757.u.luckas@road.de> <20080609205212.4b0f1ba6@hyperion.delvare>
In-Reply-To: <20080609205212.4b0f1ba6@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806092359.36080.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2008, Jean Delvare wrote:
> On Mon, 9 Jun 2008 16:47:42 +0200, Uli Luckas wrote:
> > I am in the process of trying out a display connected to a colibri
> > board's pxa frame buffer device. The display's power supply is switch
> > through i2c.
> >
> > In order to use the frame buffer console I have i2c and pxafb compiled
> > in.
> >
> > By default, the pxafb driver get's initialized before the i2c bus causing
> > the display power up to fail.
> >
> > What do i2c people think about changing the link order here?
>
> Why don't you ask on the i2c mailing list? Cc added.
>
I wanted to get i2c developers plus frame buffer and other i2c client 
developers involved. Crossposting to more then 2 lists seemed wrong.

> Personally I have no objection, but dependencies can be tricky so
> you'll have to be careful. video is early in the link order at the
> moment.
>
Yep. I might come back for help on that later.

> > What do other frame buffer drivers handle the absence of i2c during early
> > boot?
>
> Interestingly enough, they appear to do fine, despite the linking
> order. Maybe because i2c_init is a subsys_initcall() while framebuffer
> drivers are initialized with module_init()? Then I'm not sure why your
> own driver has a problem there.
>
Well, this is only very partially true. Try:
rgrep -l subsys_initcall drivers/i2c/
rgrep -l module_init drivers/i2c/

The last of which gives drivers/i2c/busses/i2c-pxa.c for example.

I'll change the pxa i2c driver to subsys_initcall and try if that works when I 
get back to my desk tomorrow.

regards,
Uli
