Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZGRJ7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZGRJ7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbZGRJ7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:59:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36231 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751771AbZGRJ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:59:18 -0400
Date: Sat, 18 Jul 2009 10:59:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add WM835x PMIC hardware
	monitoring driver
Message-ID: <20090718095917.GA10160@opensource.wolfsonmicro.com>
References: <1247862795-22547-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20090718111712.78771b36@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090718111712.78771b36@hyperion.delvare>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 11:17:12AM +0200, Jean Delvare wrote:

> > +WM8350_NAMED_VOLTAGE(0, USB);
> > +WM8350_NAMED_VOLTAGE(1, BATT);
> > +WM8350_NAMED_VOLTAGE(2, LINE);

> I would suggest passing the whole WM8350_AUXADC_USB, etc. string as the
> 2nd parameter. This makes grepping the source code for users (as LXR
> does for example) possible.

The reason it's formatted like that is that the AUXADC input names match
the names of the supplies that are being monitored so the second parameter
is also used to provide a label to userspace.

> > +static struct platform_driver wm8350_hwmon_driver = {
> > +	.probe = wm8350_hwmon_probe,
> > +	.remove = __devexit_p(wm8350_hwmon_remove),
> > +	.driver = {
> > +		.name = "wm8350-hwmon",

> I think you are supposed to set .owner to THIS_MODULE?

Hrm, yeah.  I need to figure out where I cut'n'pasted this from since I
suspect the error came along with that.

> When you are done, what is your merge plan? I would be happy to take
> the patch in my unofficial hwmon tree and push it in 2.6.32, but due to
> wm8350-core dependencies, you may prefer it to be merged differently?

I'm happy to go with whatever is easiest for the people actually doing
the merging.  wm8350 is fairly static at the minute - it's much more
likely that there would be merge issues from the build infrastructure.
It might be a little easier to merge via mfd.

I'll fix the rest of your comments, thanks.
