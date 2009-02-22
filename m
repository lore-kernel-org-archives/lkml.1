Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZBVL1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZBVL1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 06:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbZBVL1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 06:27:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45552 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbZBVL1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 06:27:43 -0500
Date: Sun, 22 Feb 2009 11:26:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: PCF8583 not detected on RiscPC
Message-ID: <20090222112654.GC28025@n2100.arm.linux.org.uk>
References: <20090221194814.GA24385@n2100.arm.linux.org.uk> <20090221204147.GA25408@n2100.arm.linux.org.uk> <20090222011936.35b21d6b@i1501.lan.towertech.it> <20090222082829.GG16596@n2100.arm.linux.org.uk> <20090222104205.4539d3ef@i1501.lan.towertech.it> <20090222095150.GA28025@n2100.arm.linux.org.uk> <20090222113544.4501f06a@i1501.lan.towertech.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222113544.4501f06a@i1501.lan.towertech.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 11:35:44AM +0100, Alessandro Zummo wrote:
> On Sun, 22 Feb 2009 09:51:50 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > >   That's very simple, even if acorn is a bit unstructured. You just
> > >  need to choice a place under arch/arm that you like
> > >  (arch/arm/plat-acorn/ ? ) and place a bit of code called
> > >  by an appropriate initcall. 
> > 
> > Thanks.
> > 
> > If it is as simple as you are suggesting, why wasn't it done _before_
> > breaking the RTC support?
> 
>  I guess because who did the modification didn't know
>  it was used on acorn and nor did I.
> 
>  
> > After all, you know damned well that PCF8583 is used on ARM and you
> > know the config symbol for the platform, especially as you pointedly
> > remove the dependencies on CONFIG_ARCH_RPC from the driver inspite of
>  
>  ????

I refer you to bb71f99f8daefb4a2c2441298bc127aaff9af947 and the
discussion resulting from that commit, and changed in your commit
09a21e56dc3767ce444e21c1383d587b261af13c.

>  I don't know who converted the acorn platform to
>  use it and I can't care less. Who did should have checked the driver 
>  for compatibility with his own platform before migrating from the driver under
>  drivers/char/ .

Which bit of "it used to work" did you miss?  At the time of converesion,
it was checked and after some initial trivial bug fixing and it was
working, and continued to work up until this recent breakage.

>  As far as I can see with git log, you applied changes to the driver
>  multiple times, without having me in Cc nor G. Liakhovetski (who did
>  the port).

I don't add CC entries to commits, so you can't make that assumption.
However, I did talk to Guennadi around the time of those changes about
some of the issues therein, in particular adding back the I2C address of
the PCF8583.

Most of those other changes were trivial bug fixes, and I do apologise
for not copying you with those.
