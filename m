Return-Path: <linux-kernel-owner+w=401wt.eu-S932510AbZGRKkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbZGRKkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 06:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbZGRKkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 06:40:04 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:18495 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062AbZGRKkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 06:40:02 -0400
Date: Sat, 18 Jul 2009 12:39:51 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: Add WM835x PMIC hardware  monitoring driver
Message-ID: <20090718123951.34c776ca@hyperion.delvare>
In-Reply-To: <20090718095917.GA10160@opensource.wolfsonmicro.com>
References: <1247862795-22547-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20090718111712.78771b36@hyperion.delvare>
	<20090718095917.GA10160@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jul 2009 10:59:17 +0100, Mark Brown wrote:
> On Sat, Jul 18, 2009 at 11:17:12AM +0200, Jean Delvare wrote:
> 
> > > +WM8350_NAMED_VOLTAGE(0, USB);
> > > +WM8350_NAMED_VOLTAGE(1, BATT);
> > > +WM8350_NAMED_VOLTAGE(2, LINE);
> 
> > I would suggest passing the whole WM8350_AUXADC_USB, etc. string as the
> > 2nd parameter. This makes grepping the source code for users (as LXR
> > does for example) possible.
> 
> The reason it's formatted like that is that the AUXADC input names match
> the names of the supplies that are being monitored so the second parameter
> is also used to provide a label to userspace.

This isn't how I read the code. I see a look-up table for labels, so the
macro implementation is just a detail which shouldn't matter.

> > > +static struct platform_driver wm8350_hwmon_driver = {
> > > +	.probe = wm8350_hwmon_probe,
> > > +	.remove = __devexit_p(wm8350_hwmon_remove),
> > > +	.driver = {
> > > +		.name = "wm8350-hwmon",
> 
> > I think you are supposed to set .owner to THIS_MODULE?
> 
> Hrm, yeah.  I need to figure out where I cut'n'pasted this from since I
> suspect the error came along with that.

Maybe from an i2c driver, where the owner is set at run-time. Back when
this was implemented, I did object that it would cause confusion
because it would make different subsystems have different
requirements... Looks like I was right.

> > When you are done, what is your merge plan? I would be happy to take
> > the patch in my unofficial hwmon tree and push it in 2.6.32, but due to
> > wm8350-core dependencies, you may prefer it to be merged differently?
> 
> I'm happy to go with whatever is easiest for the people actually doing
> the merging.  wm8350 is fairly static at the minute - it's much more
> likely that there would be merge issues from the build infrastructure.
> It might be a little easier to merge via mfd.

Fine with me.

> I'll fix the rest of your comments, thanks.

OK.

-- 
Jean Delvare
