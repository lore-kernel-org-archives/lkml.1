Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZBVKXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZBVKXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 05:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZBVKXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 05:23:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52934 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZBVKXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 05:23:23 -0500
Date: Sun, 22 Feb 2009 10:22:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: PCF8583 not detected on RiscPC
Message-ID: <20090222102217.GB28025@n2100.arm.linux.org.uk>
References: <20090221194814.GA24385@n2100.arm.linux.org.uk> <20090221204147.GA25408@n2100.arm.linux.org.uk> <20090222011936.35b21d6b@i1501.lan.towertech.it> <20090222082829.GG16596@n2100.arm.linux.org.uk> <20090222105205.4e8165da@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222105205.4e8165da@hyperion.delvare>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 10:52:05AM +0100, Jean Delvare wrote:
> Russell,
> 
> On Sun, 22 Feb 2009 08:28:29 +0000, Russell King - ARM Linux wrote:
> > So, really, I'm not listening to NACKs from anyone for this.  The only
> > thing I'll listen to is something _constructive_ to make it work again.
> > I'm sure Andrew Morton will back me up on this.
> 
> ... and now you say we should fix it in the day and then threaten us?
> Come on.

I'm serious.  It's a regression, it needs fixing.

> > The problem is that this *is* a regression, and therefore must be fixed
> > in 2.6.29-rc.  As I see it, the only sane way to do that is to revert
> > the conversion until a proper fix can be done.
> 
> You can't claim it is a regression that must be fixed in 2.6.29,
> because it is already broken in 2.6.28, and even 2.6.27, and nobody
> complained.

Sorry, our definitions of what's a regression are different, and you are
wrong.  As I've already said to you, it worked in 2.6.25-rc and it worked
last time I tested which was a 2.6.27-rc kernel.

If every single kernel has to be tested on every single machine to find
"regressions" in your terminology, that's all I'd be doing.  Get real.
It's not practical to do that.

So, yes, I'm going to continue claiming that this is a regression and
needs to be fixed.

> > So, please provide constructive suggestions on how to add boardinfo to
> > this in a sane way, or we revert PCF8583 back to something which works.
> 
> Alessandro nicely proposed to solve your problem the right way if you
> provided the required technical information, which, as far as I can
> see, you didn't. I asked for hardware details and you didn't provide
> them either.

I'm sorry, what hardware details are you wanting that I didn't give.
I've said it's the PCF8583 driver.  I've said that the bus driver is
i2c-acorn.c, even giving its location in the kernel tree.

It's a bit banged I2C bus.  It's on the main board.  It's connected to
expansion cards.  It uses 5V signalling with pull up resistors.

I don't think I've missed anything out.

> So let me ask more precise questions, and hopefully we will get
> somewhere.
> 
> 1* How many different system types is i2c-acorn used on?

It used to be used on four, two of which have been long since removed,
and one was removed in the last merge window.  So it's now only used on
one platform.

> 2* Do all these systems have a PCF8583 RTC chip?

Yes.

> 3* At which address does the PCF8583 chip live on these systems? I
>    guess 0x50.

Looking back in the history of the driver, yes, it's 0x50.

> 4* Is there any acorn-specific piece of code which is run when the
>    Linux kernel boots?

For the riscpc, arch/arm/mach-rpc

> Depending on the answer to these questions, I can think of 3 different
> nice ways to fix the regression. Reverting
> 02bb584f3b1cfc8188522a4d2c8881b65073a4f1 is not one of them,

Well, I've tried it, and unfortunately it doesn't work.  The result is
that with the board_info in place, the i2c-acorn bus seems to no longer
be registered as bus 0, but becomes bus 1.

> because 1*
> it would potentially cause regressions on other systems and 2* it would
> make the rtc-pcf8583 driver use an API which is marked as deprecated.

That's bullshit in light of the fact that this used to work, but then
a patch was merged which stopped it working.  That's a regression on
the main platform which PCF8583 was written for.  Plain and simple.
