Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbXF0FCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbXF0FCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 01:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbXF0FCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 01:02:34 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:21752 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbXF0FCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 01:02:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B/gZuR3/ijldWGeNp6qQ3YBm8c8BibKlUQH+2qRxbodjtUEil0IJaKjCXGf5ZG8Oatpc26eBLfKhj9efHBe2+GIx1pzw6paLtGor6seT+viOaI5AlsHAt8L4n/59OqzktbN23zJS1k7LZvTzDQ/uH49p4SByj1zvfBnegCsCPtQ=
Message-ID: <a8e1da0706262202i3af320a7gaec8a5f0680beb13@mail.gmail.com>
Date: Wed, 27 Jun 2007 05:02:31 +0000
From: "dave young" <hidave.darkstar@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [PATCH] atkbd: cleanup only once
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200706270059.33550.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070627105907.GA1802@darkstar.te-china.tietoenator.com>
	 <200706270034.09802.dtor@insightbb.com>
	 <20070627042820.GC13513@suse.de>
	 <200706270059.33550.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/27, Dmitry Torokhov <dtor@insightbb.com>:
> On Wednesday 27 June 2007 00:28, Greg KH wrote:
> > On Wed, Jun 27, 2007 at 12:34:09AM -0400, Dmitry Torokhov wrote:
> > > Hi Dave,
> > >
> > > On Wednesday 27 June 2007 06:59, Dave Young wrote:
> > > > Hi,
> > > >
> > > > If you press ctrl+alt+del several times as kernel booting (before user level bootin), the kernel will oops. I found the ps2_command is called more than once, then the ps2dev->serio maybe NULL pointer.
> > > >
> > > > 2.6.22-rc5 and 2.6.22-rc6 have same result.
> > > >
> > > > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > > > ---
> > > > diff -upr linux/drivers/input/keyboard/atkbd.c linux.new/drivers/input/keyboard/atkbd.c
> > > > --- linux/drivers/input/keyboard/atkbd.c  2007-06-27 10:38:37.000000000 +0000
> > > > +++ linux.new/drivers/input/keyboard/atkbd.c      2007-06-27 10:37:39.000000000 +0000
> > > > @@ -795,6 +795,11 @@ static int atkbd_activate(struct atkbd *
> > > >
> > > >  static void atkbd_cleanup(struct serio *serio)
> > > >  {
> > > > + static int flag;
> > > > +
> > > > + if(flag)
> > > > +         return;
> > > > + flag = 1;
> > >
> > > Unfortunately this will prevent atkbd from resetting keyboard on 2nd
> > > suspend attempt. It will also not work if you have an active MUX and
> > > have a couple of keyboards connected.
> > >
> > > Greg, now that you removed rwsem from subsystem (and subsystem itself
> > > for that matter) there is nothing as far as I can see that stops
> > > several threads from running device_shutdown() simultaneously. I also
> > > do not see what would isolate device probing and shutting them down
> > > at the same time. Am I missing something?
> >
> > There was never anything stopping that from happening before.  No driver
> > core code was using that rwsem, so it wasn't protecting anything,
> > despite people trying to use it as if it was :)
> >
>
> It did protect device_shutdown() from itself, didn't it?
>
> --
> Dmitry
>
how about check ps2dev->serio in ps2_command before use it?
Regards
dave
