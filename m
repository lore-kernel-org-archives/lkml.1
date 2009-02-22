Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZBVJwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZBVJwl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 04:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZBVJwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 04:52:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54497 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZBVJwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 04:52:31 -0500
Date: Sun, 22 Feb 2009 09:51:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: PCF8583 not detected on RiscPC
Message-ID: <20090222095150.GA28025@n2100.arm.linux.org.uk>
References: <20090221194814.GA24385@n2100.arm.linux.org.uk> <20090221204147.GA25408@n2100.arm.linux.org.uk> <20090222011936.35b21d6b@i1501.lan.towertech.it> <20090222082829.GG16596@n2100.arm.linux.org.uk> <20090222104205.4539d3ef@i1501.lan.towertech.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222104205.4539d3ef@i1501.lan.towertech.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 10:42:05AM +0100, Alessandro Zummo wrote:
> On Sun, 22 Feb 2009 08:28:29 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
>  
> > So, really, I'm not listening to NACKs from anyone for this.  The only
> > thing I'll listen to is something _constructive_ to make it work again.
> > I'm sure Andrew Morton will back me up on this.
> 
>  You never listened to anyone, as far as I can remember. The constructive
>  part was where I said I'd be happy to give help.

Ditto your listening ability over the fact that the PCF8583 driver is
platform specific.

> > Now, we can either totally reorganize i2c-acorn, but that won't be
> > acceptable for 2.6.29-rc.
> 
>   i2c-acorn is just fine as is, while you might want to change
>  it to a platform driver at a later time.
> 
> 
> > The problem is that this *is* a regression, and therefore must be fixed
> > in 2.6.29-rc.  As I see it, the only sane way to do that is to revert
> > the conversion until a proper fix can be done.
> > 
> > So, please provide constructive suggestions on how to add boardinfo to
> > this in a sane way, or we revert PCF8583 back to something which works.
> 
>   That's very simple, even if acorn is a bit unstructured. You just
>  need to choice a place under arch/arm that you like
>  (arch/arm/plat-acorn/ ? ) and place a bit of code called
>  by an appropriate initcall. 

Thanks.

If it is as simple as you are suggesting, why wasn't it done _before_
breaking the RTC support?

After all, you know damned well that PCF8583 is used on ARM and you
know the config symbol for the platform, especially as you pointedly
remove the dependencies on CONFIG_ARCH_RPC from the driver inspite of
it being full of platform specifics (location of year byte in CMOS
and the checksum algorithm and checksum location.)

The only reason I can think is pure and simple spite.
