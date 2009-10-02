Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZJBHHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZJBHHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbZJBHHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:07:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37863 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971AbZJBHHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:07:30 -0400
Date: Fri, 2 Oct 2009 06:10:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       omegamoon@gmail.com, eric.y.miao@gmail.com, utx@penguin.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.32-rc1: spitz boots but suspend/resume is broken
Message-ID: <20091002041015.GB1409@ucw.cz>
References: <20090930120655.GG1412@ucw.cz> <bc64b4640909300509p6c682fa8rb5ce43c77c79f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640909300509p6c682fa8rb5ce43c77c79f5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-30 16:09:25, Dmitry Eremin-Solenikov wrote:
> On Wed, Sep 30, 2009 at 4:06 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > matrix keyboard driver needs to be enabled, otherwise it seems ok.
> >
> > Unfortunately, it does not respond to power button in any visible way
> > :-(. Any ideas what might be wrong/how to debug it?
> 
> Enable gpio-keyboard driver, verify (or port power button to it :))
> and check that
> enable_wakeup is enabled.

It seems neccessary tables for gpio-keyboard just are not there :-(.

In the meantime, this allows easy switch to known-good driver. (Can we
get it upstream until problem is fixed properly?)

Unfortunately, that still does not fix suspend/resume. (Does it work
for you?)

> BTW: on tosa initially i had a problem w/ wakeup. The power button wasn't
> able to wake the device up. However there was another gpio that was OR of
>  power button and AC-in gpios that had to be used for wakeup. Please check
> if the same design applies to your device.

Well, it all worked in 2.6.31. How do I check it?

								Pavel
---

Switch back to known-good keyboard driver. The new one does not
support power key, making suspend unusable.

This actually fixes regression from 2.6.31 (power key now works) but
not suspend/resume regression (will have to hunt more).

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff -ur linux-rc/arch/arm.ofic/mach-pxa/spitz.c linux-rc/arch/arm/mach-pxa/spitz.c
--- linux-rc/arch/arm.ofic/mach-pxa/spitz.c	2009-09-28 12:09:26.000000000 +0200
+++ linux-rc/arch/arm/mach-pxa/spitz.c	2009-09-30 22:27:43.000000000 +0200
@@ -367,7 +367,8 @@
 };
 
 static struct platform_device spitzkbd_device = {
-	.name		= "matrix-keypad",
+  //	.name		= "matrix-keypad",
+	.name		= "spitz-keyboard",
 	.id		= -1,
 	.dev		= {
 		.platform_data = &spitzkbd_pdata,


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
