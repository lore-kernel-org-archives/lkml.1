Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZBVI3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZBVI3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 03:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZBVI3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 03:29:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56161 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZBVI3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 03:29:13 -0500
Date: Sun, 22 Feb 2009 08:28:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: PCF8583 not detected on RiscPC
Message-ID: <20090222082829.GG16596@n2100.arm.linux.org.uk>
References: <20090221194814.GA24385@n2100.arm.linux.org.uk> <20090221204147.GA25408@n2100.arm.linux.org.uk> <20090222011936.35b21d6b@i1501.lan.towertech.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222011936.35b21d6b@i1501.lan.towertech.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 01:19:36AM +0100, Alessandro Zummo wrote:
> On Sat, 21 Feb 2009 20:41:47 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > Confirmation: reverting 02bb584f3b1cfc8188522a4d2c8881b65073a4f1 and
> > removing the reference to I2C_DRIVERID_PCF8583 results in the regression
> > being fixed and normal behaviour being restored.
> > 
> > Patch below.
> 
>  this is a nack on my side. the whole i2c has been converted to the
>  new style model. everyone is following and this is
>  the wrong way to fix the issue.

While you may not desire the patch, the fact of the matter is that the
conversion caused a regression.  Regressions trump forward progress and
fixing stuff to work on new platforms.

So, really, I'm not listening to NACKs from anyone for this.  The only
thing I'll listen to is something _constructive_ to make it work again.
I'm sure Andrew Morton will back me up on this.

>  the device must be instantiated in the appropriate
>  platform code. 
> 
>  for an example of what needs to be done, you can grep for
>  i2c_board_info in arch/arm .
> 
>  if you need help, just tell me where's the acorn related
>  platform setup code and I'll have a look.

drivers/i2c/busses/i2c-acorn.c

That's where the problem is - it's totally unclear how to convert
this to the board_info method, because it doesn't live in the kernel
as a platform thing.  Putting the board_info stuff into i2c-acorn
just seems completely wrong.

Now, we can either totally reorganize i2c-acorn, but that won't be
acceptable for 2.6.29-rc.

The problem is that this *is* a regression, and therefore must be fixed
in 2.6.29-rc.  As I see it, the only sane way to do that is to revert
the conversion until a proper fix can be done.

So, please provide constructive suggestions on how to add boardinfo to
this in a sane way, or we revert PCF8583 back to something which works.
