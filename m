Return-Path: <linux-kernel-owner+w=401wt.eu-S1030263AbXCVIMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030263AbXCVIMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030266AbXCVIMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:12:40 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:4348 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030263AbXCVIMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DtxvZUm9Of4epxyme+WH8BkEEziSG8pxbfWIt/4QmdKxD87Y6W8Lro1qvhTTUkyQB0WcUHB4kZ2rXbhwFBK6ZzZhFO42bSE+sEX5saA7VNKcMvn70VOrpwe4d+j+Vf2QW+JnJXVg6yMOdmKMEb99YSVBP/PqZTe2IGkgu+xbnF8=
Message-ID: <8bd0f97a0703220112y7d6cef2ax612ea5ece3df9740@mail.gmail.com>
Date: Thu, 22 Mar 2007 04:12:37 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH -mm 4/4] Blackfin: on-chip Two Wire Interface I2C driver
Cc: "Bryan Wu" <bryan.wu@analog.com>, "David Brownell" <david-b@pacbell.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070322084806.8bf0f231.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174471688.5648.56.camel@roc-desktop>
	 <20070321202231.2eac1cf9.khali@linux-fr.org>
	 <8bd0f97a0703212239n3edb9a44waa0994e3cffe48d8@mail.gmail.com>
	 <20070322084806.8bf0f231.khali@linux-fr.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/07, Jean Delvare <khali@linux-fr.org> wrote:
> On Thu, 22 Mar 2007 01:39:28 -0400, Mike Frysinger wrote:
> > On 3/21/07, Jean Delvare <khali@linux-fr.org> wrote:
> > > > +     p_adap->class = I2C_CLASS_ALL;
> > >
> > > This pretty much voids the point of these probing classes. You should
> > > only select the classes matching devices which may actually be probed
> > > for on this bus. If different boards have different needs, get the
> > > right classes from the platform data.
> >
> > i asked about the class issue previously specifically for this bus
> > driver and was told that they werent really fully defined ... the
> > on-chip I2C interface on the Blackfin chip can handle any I2C device
> > which is why i added this line
>
> Grep for I2C_CLASS_ and you'll see that the classes are defined and
> used consistently in the kernel tree. Maybe just not by the embedded
> folks.
>
> Also note that what matters is not the type of devices that can be
> connected on the bus, but the type of devices that can be probed for.
> This was essentially the same so far (general probing was the only way
> to instantiate an i2c device), but the new i2c-core code that will go
> into 2.6.22 will make it different. These classes will probably be less
> used in the future.

was referring to this:
http://lists.lm-sensors.org/pipermail/i2c/2007-February/000770.html

> > any examples of how to go about doing it via boards ?  i dont see any
> > other I2C bus driver doing it that way ...
>
> I don't think many drivers from the embedded world do it properly.

which is why i asked if you had any hints ... if no one else is doing
it, it means no standard exists, which means there's nothing for me to
copy :)

it isnt obvious to me how to leverage the normal platform_device and
resource structures to achieve moving the class out of the driver and
into a boards file ... i'm perfectly happy doing this knowing what the
correct direction to take things ... but i guess this gets us back to
if no one is doing this yet and no one has any proposals, it's on our
shoulders to get it resolved satisfactorily

i might also argue (for fun) that some of the bus drivers arent doing
it correctly ... they should implement support for the specific I2C
implementation and then a different file for the specific
[mother]board would contain the specific details

> But
> they don't appear to define any class at all, which means that in
> practice they keep most regular i2c drivers out of their bus. Pretty
> much the contrary of what you're doing with I2C_CLASS_ALL.

this is certainly true, but i'd rather have the default behavior be
"allow any I2C device on the bus" than "only allow I2C devices that
dont check the bus type" ...

> It's really up to you, but if you set the class to I2C_CLASS_ALL, don't
> later come and complain that other drivers keep probing your I2C bus
> and possibly attach to your I2C devices. You asked for it.

i dont see why we would complain when it's obviously our fault ;)

it also wouldnt be a real issue as it's an embedded board, so it'd
only have the drivers enabled for devices that are actually hooked up
...
-mike
