Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbXHSMEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbXHSMEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 08:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbXHSMEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 08:04:01 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:57508 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbXHSMEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 08:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k4Csmq+uqbchxeyeT5nytDya+asIseRwnbprvyBWMZeNAYuyOg2jkm7qviJ9trFkLLQl6ygj6YDKp6apo+uK7h9fy8bCHA9ZQD+A1cOZ2YZZbkbi781ZUJbif3B5znyqaGB2C2q4jmT4cKypulbQ0RlS1w8Rt4jPBXckR3mc4j4=
Subject: Re: [PATCH] pxa2xx PCMCIA timing issue on iPAQ H5550
From: Milan Plzik <milan.plzik@gmail.com>
To: Steven Newbury <s_j_newbury@yahoo.co.uk>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <167613.90719.qm@web25003.mail.ukl.yahoo.com>
References: <167613.90719.qm@web25003.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=utf-8
Date: Sun, 19 Aug 2007 14:03:46 +0200
Message-Id: <1187525026.25210.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Pi, 2007-08-17 at 00:48 +0100, Steven Newbury wrote:
> --- Milan Plzik <milan.plzik@gmail.com> wrote:
> 
> > On Å t, 2007-08-09 at 16:06 +0100, Steven Newbury wrote:
> > > --- Milan Plzik <milan.plzik@gmail.com> wrote:
> > > 
> > > >   Good day,
> > > > 
> > > >   recently I've been trying to get working PCMCIA interface on H5000
> > > > ipaq series, using dual PCMCIA sleeve. So far things work correctly, but
> > > > I had to do one modification to drivers/pcmcia/pxa2xx_base.c to get the
> > > > interface working with orinoco gold PCMCIA card (wired pcnet_cs ethernet
> > > > card worked even without this modification). Patch attached.
> > > > 
> > > >   The issue has something to do with assert time on PCMCIA bus, but I'm
> > > > not really sure what -- I found the working value just by trial&error
> > > > approach. I'm not sure how is the assert value in pxa2xx_mcxx_asst
> > > > calculated (I know, simple formula, but the reason why is it calculated
> > > > that way is not obvious for me), neither that my modification is
> > > > correct. It just works with iPAQ. 
> > > > 
> > > I posted a patch to linux-arm-kernel which reworked the timing code.  The
> > > existing is/was IMHO wrong and this showed up for me with frequency scaling
> > > where the code would not keep the PCMCIA timings constant with changes to
> > the
> > > core frequency.  Here it is:
> > > http://marc.info/?l=linux-arm-kernel&m=116861295404294&w=2
> > 
> >   I found out that drivers/pcmcia/pxa2xx_base.c from handhelds.org tree
> > was a bit modified. I tried both vanilla kernel tree and vanilla+this
> > patch -- both worked with pcnet_cs, and neither one with orinoco card.
> > As far as I understand, handhelds.org modification makes use of memory
> > clock instead of cpu clock for calculations. But even when using old
> > handhelds.org driver with modified formulas, orinoco card won't
> > initialize.
> > 
> What actually happens?  I'm using a spectrum24 and it works fine on my Zaurus
> SL-C3100.  Is it trying to load the firmware?  I'm still using 2.6.20, so if
> something has broken since I don't know about it.

  The orinoco_cs driver fails to initialize the card, it doesn't read
proper value from SWSUPPORT0 register (or something like that, I don't
remember exactly). Driver sets some magic value there and expects to
read it back correctly, but that doesn't happen.

> 
> >   I'm not really sure how things should be calculated, I'll try ask
> > folks who modified the hh.org driverto see what could cause the
> > problems.
> > 
> It is all detailed in the PXA2xx manuals.  I did try to enough details in my
> comments to make sense of the calculation.  As was commented on when I posted
> it, it isn't ideal since it uses divides which are relatively slow on ARMs.

  Err, I did not mean your code, but handhelds.org one:). I need to ask
why it has been changed to the actual state -- precisely why it doesn't
use pxa core frequency, but memclk.

> 
> 
> Steve
> 
> 

	Milan

>       ___________________________________________________________ 
> Want ideas for reducing your carbon footprint? Visit Yahoo! For Good  http://uk.promotions.yahoo.com/forgood/environment.html

