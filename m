Return-Path: <linux-kernel-owner+w=401wt.eu-S1030196AbXCVHtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196AbXCVHtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbXCVHtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:49:31 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:4225 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753150AbXCVHtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:49:31 -0400
Date: Thu, 22 Mar 2007 08:48:06 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Bryan Wu" <bryan.wu@analog.com>, "David Brownell" <david-b@pacbell.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 4/4] Blackfin: on-chip Two Wire Interface I2C driver
Message-Id: <20070322084806.8bf0f231.khali@linux-fr.org>
In-Reply-To: <8bd0f97a0703212239n3edb9a44waa0994e3cffe48d8@mail.gmail.com>
References: <1174471688.5648.56.camel@roc-desktop>
	<20070321202231.2eac1cf9.khali@linux-fr.org>
	<8bd0f97a0703212239n3edb9a44waa0994e3cffe48d8@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, 22 Mar 2007 01:39:28 -0400, Mike Frysinger wrote:
> On 3/21/07, Jean Delvare <khali@linux-fr.org> wrote:
> > > +     p_adap->class = I2C_CLASS_ALL;
> >
> > This pretty much voids the point of these probing classes. You should
> > only select the classes matching devices which may actually be probed
> > for on this bus. If different boards have different needs, get the
> > right classes from the platform data.
> 
> i asked about the class issue previously specifically for this bus
> driver and was told that they werent really fully defined ... the
> on-chip I2C interface on the Blackfin chip can handle any I2C device
> which is why i added this line

Grep for I2C_CLASS_ and you'll see that the classes are defined and
used consistently in the kernel tree. Maybe just not by the embedded
folks.

Also note that what matters is not the type of devices that can be
connected on the bus, but the type of devices that can be probed for.
This was essentially the same so far (general probing was the only way
to instantiate an i2c device), but the new i2c-core code that will go
into 2.6.22 will make it different. These classes will probably be less
used in the future.

> any examples of how to go about doing it via boards ?  i dont see any
> other I2C bus driver doing it that way ...

I don't think many drivers from the embedded world do it properly. But
they don't appear to define any class at all, which means that in
practice they keep most regular i2c drivers out of their bus. Pretty
much the contrary of what you're doing with I2C_CLASS_ALL.

It's really up to you, but if you set the class to I2C_CLASS_ALL, don't
later come and complain that other drivers keep probing your I2C bus
and possibly attach to your I2C devices. You asked for it.

-- 
Jean Delvare
