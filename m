Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbZBVJw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbZBVJw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 04:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZBVJwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 04:52:37 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:37461 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbZBVJwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 04:52:35 -0500
Date: Sun, 22 Feb 2009 10:52:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: PCF8583 not detected on RiscPC
Message-ID: <20090222105205.4e8165da@hyperion.delvare>
In-Reply-To: <20090222082829.GG16596@n2100.arm.linux.org.uk>
References: <20090221194814.GA24385@n2100.arm.linux.org.uk>
	<20090221204147.GA25408@n2100.arm.linux.org.uk>
	<20090222011936.35b21d6b@i1501.lan.towertech.it>
	<20090222082829.GG16596@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Sun, 22 Feb 2009 08:28:29 +0000, Russell King - ARM Linux wrote:
> On Sun, Feb 22, 2009 at 01:19:36AM +0100, Alessandro Zummo wrote:
> > On Sat, 21 Feb 2009 20:41:47 +0000
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > 
> > > Confirmation: reverting 02bb584f3b1cfc8188522a4d2c8881b65073a4f1 and
> > > removing the reference to I2C_DRIVERID_PCF8583 results in the regression
> > > being fixed and normal behaviour being restored.
> > > 
> > > Patch below.
> > 
> >  this is a nack on my side. the whole i2c has been converted to the
> >  new style model. everyone is following and this is
> >  the wrong way to fix the issue.

+1

> While you may not desire the patch, the fact of the matter is that the
> conversion caused a regression.  Regressions trump forward progress and
> fixing stuff to work on new platforms.

I am sorry that we caused a regression. OTOH this change has been
publicly advertised several times, and the patch in question was
applied over 6 months ago...

> So, really, I'm not listening to NACKs from anyone for this.  The only
> thing I'll listen to is something _constructive_ to make it work again.
> I'm sure Andrew Morton will back me up on this.

... and now you say we should fix it in the day and then threaten us?
Come on.

> >  the device must be instantiated in the appropriate
> >  platform code. 
> > 
> >  for an example of what needs to be done, you can grep for
> >  i2c_board_info in arch/arm .
> > 
> >  if you need help, just tell me where's the acorn related
> >  platform setup code and I'll have a look.
> 
> drivers/i2c/busses/i2c-acorn.c
> 
> That's where the problem is - it's totally unclear how to convert
> this to the board_info method, because it doesn't live in the kernel
> as a platform thing.  Putting the board_info stuff into i2c-acorn
> just seems completely wrong.
>
> Now, we can either totally reorganize i2c-acorn, but that won't be
> acceptable for 2.6.29-rc.

It doesn't matter at all that i2c-acorn isn't a platform driver.
There's no need to reorganize anything. No need to sound so dramatic.

> The problem is that this *is* a regression, and therefore must be fixed
> in 2.6.29-rc.  As I see it, the only sane way to do that is to revert
> the conversion until a proper fix can be done.

You can't claim it is a regression that must be fixed in 2.6.29,
because it is already broken in 2.6.28, and even 2.6.27, and nobody
complained.

> So, please provide constructive suggestions on how to add boardinfo to
> this in a sane way, or we revert PCF8583 back to something which works.

Alessandro nicely proposed to solve your problem the right way if you
provided the required technical information, which, as far as I can
see, you didn't. I asked for hardware details and you didn't provide
them either.

So let me ask more precise questions, and hopefully we will get
somewhere.

1* How many different system types is i2c-acorn used on?

2* Do all these systems have a PCF8583 RTC chip?

3* At which address does the PCF8583 chip live on these systems? I
   guess 0x50.

4* Is there any acorn-specific piece of code which is run when the
   Linux kernel boots?

Depending on the answer to these questions, I can think of 3 different
nice ways to fix the regression. Reverting
02bb584f3b1cfc8188522a4d2c8881b65073a4f1 is not one of them, because 1*
it would potentially cause regressions on other systems and 2* it would
make the rtc-pcf8583 driver use an API which is marked as deprecated.

-- 
Jean Delvare
