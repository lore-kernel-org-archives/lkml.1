Return-Path: <linux-kernel-owner+w=401wt.eu-S1760372AbXK1KYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372AbXK1KYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757073AbXK1KYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:24:03 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:2041 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757071AbXK1KYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:24:01 -0500
Date: Wed, 28 Nov 2007 11:23:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Adrian Bunk <bunk@kernel.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [2.6 patch] some overdue I2C driver removal
Message-ID: <20071128112357.3828d469@hyperion.delvare>
In-Reply-To: <20071024164347.GN4003@csclub.uwaterloo.ca>
References: <20071024162528.GX30533@stusta.de>
	<20071024164347.GN4003@csclub.uwaterloo.ca>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 12:43:47 -0400, Lennart Sorensen wrote:
> On Wed, Oct 24, 2007 at 06:25:28PM +0200, Adrian Bunk wrote:
> > This patch contains the overdue removal of three I2C drivers.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > ---
> > 
> >  Documentation/feature-removal-schedule.txt |    8 
> >  drivers/i2c/busses/Kconfig                 |   59 ------
> >  drivers/i2c/busses/Makefile                |    3 
> >  drivers/i2c/busses/i2c-ixp2000.c           |  167 -------------------
> >  drivers/i2c/busses/i2c-ixp4xx.c            |  178 ---------------------
> >  drivers/i2c/busses/scx200_i2c.c            |  131 ---------------
> >  6 files changed, 546 deletions(-)
> > 
> > 6a8e0e37019c0ffeb0071fae30210baf2c3bdd75 
> > diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> > index 2af3835..9114379 100644
> > --- a/Documentation/feature-removal-schedule.txt
> > +++ b/Documentation/feature-removal-schedule.txt
> > @@ -218,14 +218,6 @@ Who:	Len Brown <len.brown@intel.com>
> >  
> >  ---------------------------
> >  
> > -What:	i2c-ixp2000, i2c-ixp4xx and scx200_i2c drivers
> > -When:	September 2007
> > -Why:	Obsolete. The new i2c-gpio driver replaces all hardware-specific
> > -	I2C-over-GPIO drivers.
> > -Who:	Jean Delvare <khali@linux-fr.org>
> > -
> > ----------------------------
> 
> Did anyone ever write a driver that does i2c on the scx200 using the new
> i2c-gpio method?  I sure haven't seen it, although I am still running
> 2.6.18 (since that is what debian stable uses) on my scx200 systems.  I
> certainly haven't found any useful instructions on how to use the new
> i2c-gpio driver on an scx200.

There's no driver to write (i2c-gpio is the driver). Instead, the
scx200 platform needs to implement the standard GPIO API. I don't think
that it has happened yet, and last time this was discussed, someone
(can't remember who, sorry), complained that the GPIO API "sucked" and
that the scx200 platform would not be updated to use it. I didn't buy
the claim due to a lack of argumentation and the fact that the GPIO
infrastructure seems to work well enough for many other platforms.

As far as I can see, the ixp2000 platform also doesn't implement the
standard GPIO API yet, so of the 3 drivers that are about to be
removed, only i2c-ixp4xx can be removed without functionality loss at
the moment. Lennert, Russell, are there any plans to convert the
ixp2000 platform to use the generic GPIO layer?

Maybe I shouldn't have added this entry in feature-removal-schedule.txt
in the first place: these drivers should ideally be dropped in favor of
i2c-gpio, but it can only happen for platforms that implement the
standard GPIO API. As I am not the one who will convert these
platforms, and some of them might as well never be converted (I don't
know how active they are nowadays), there's not much I can do.

Thanks,
-- 
Jean Delvare
