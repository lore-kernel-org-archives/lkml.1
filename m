Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZJVRsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZJVRsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 13:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZJVRsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 13:48:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35758 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbZJVRsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 13:48:20 -0400
Date: Thu, 22 Oct 2009 19:48:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
Subject: Re: zaurus: cleanup sharpsl_pm.c
Message-ID: <20091022174816.GC5325@elf.ucw.cz>
References: <20091006200339.GA1538@ucw.cz>
 <20091017163627.GB1423@ucw.cz>
 <f17812d70910200859v6d18e81bs2760d8af1d8da5bf@mail.gmail.com>
 <f17812d70910220705o9f4a0ddwa22157b59a519350@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70910220705o9f4a0ddwa22157b59a519350@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> This fixes checkpatch/style problems in sharpsl_pm.c, allowing me to
> >>> submit real fixes next. Move spitz-specific voltage table to
> >>> spitz-specific file.
> >>>
> >>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >>
> >> Eric, any news on this one? I have real development going on top of
> >> this one, so it is quite important for me...
> >
> > Sorry late on this. Applied.
> 
> Pavel,
> 
> Here's the problem, please help look into this:
> 
>   CC      arch/arm/mach-pxa/corgi_pm.o
> In file included from
> /home/ycmiao/kernel/linux-2.6/arch/arm/mach-pxa/corgi_pm.c:28:
> /home/ycmiao/kernel/linux-2.6/arch/arm/mach-pxa/include/mach/pxa2xx-gpio.h:4:2:
> warning: #warning Please use mfp-pxa2[57]x.h instead of pxa2xx-gpio.h
> /home/ycmiao/kernel/linux-2.6/arch/arm/mach-pxa/corgi_pm.c:217: error:
> 'spitz_battery_levels_noac' undeclared here (not in a function)
> /home/ycmiao/kernel/linux-2.6/arch/arm/mach-pxa/corgi_pm.c:218: error:
> 'spitz_battery_levels_acin' undeclared here (not in a function)
> make[2]: *** [arch/arm/mach-pxa/corgi_pm.o] Error 1
> make[1]: *** [arch/arm/mach-pxa] Error 2
> make[1]: *** Waiting for unfinished jobs....

Sorry about that.

---

Introduce separate set of battery limits for corgi. This fixes
compilation, and the values probably should be subtly different, too.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff -ur linux-rc/arch/arm.ofic/mach-pxa/corgi_pm.c linux-rc/arch/arm/mach-pxa/corgi_pm.c
--- linux-rc/arch/arm.ofic/mach-pxa/corgi_pm.c	2009-09-10 00:13:59.000000000 +0200
+++ linux-rc/arch/arm/mach-pxa/corgi_pm.c	2009-10-22 19:19:02.000000000 +0200
@@ -35,6 +35,92 @@
 #define SHARPSL_FATAL_ACIN_VOLT        182   /* 3.45V */
 #define SHARPSL_FATAL_NOACIN_VOLT      170   /* 3.40V */
 
+static const struct battery_thresh corgi_battery_levels_acin[] = {
+	{ 213, 100},
+	{ 212,  98},
+	{ 211,  95},
+	{ 210,  93},
+	{ 209,  90},
+	{ 208,  88},
+	{ 207,  85},
+	{ 206,  83},
+	{ 205,  80},
+	{ 204,  78},
+	{ 203,  75},
+	{ 202,  73},
+	{ 201,  70},
+	{ 200,  68},
+	{ 199,  65},
+	{ 198,  63},
+	{ 197,  60},
+	{ 196,  58},
+	{ 195,  55},
+	{ 194,  53},
+	{ 193,  50},
+	{ 192,  48},
+	{ 192,  45},
+	{ 191,  43},
+	{ 191,  40},
+	{ 190,  38},
+	{ 190,  35},
+	{ 189,  33},
+	{ 188,  30},
+	{ 187,  28},
+	{ 186,  25},
+	{ 185,  23},
+	{ 184,  20},
+	{ 183,  18},
+	{ 182,  15},
+	{ 181,  13},
+	{ 180,  10},
+	{ 179,   8},
+	{ 178,   5},
+	{   0,   0},
+};
+
+static const struct battery_thresh  corgi_battery_levels_noac[] = {
+	{ 213, 100},
+	{ 212,  98},
+	{ 211,  95},
+	{ 210,  93},
+	{ 209,  90},
+	{ 208,  88},
+	{ 207,  85},
+	{ 206,  83},
+	{ 205,  80},
+	{ 204,  78},
+	{ 203,  75},
+	{ 202,  73},
+	{ 201,  70},
+	{ 200,  68},
+	{ 199,  65},
+	{ 198,  63},
+	{ 197,  60},
+	{ 196,  58},
+	{ 195,  55},
+	{ 194,  53},
+	{ 193,  50},
+	{ 192,  48},
+	{ 191,  45},
+	{ 190,  43},
+	{ 189,  40},
+	{ 188,  38},
+	{ 187,  35},
+	{ 186,  33},
+	{ 185,  30},
+	{ 184,  28},
+	{ 183,  25},
+	{ 182,  23},
+	{ 181,  20},
+	{ 180,  18},
+	{ 179,  15},
+	{ 178,  13},
+	{ 177,  10},
+	{ 176,   8},
+	{ 175,   5},
+	{   0,   0},
+};
+
 static void corgi_charger_init(void)
 {
 	pxa_gpio_mode(CORGI_GPIO_ADC_TEMP_ON | GPIO_OUT);
@@ -214,8 +300,8 @@
 	.fatal_acin_volt  = SHARPSL_FATAL_ACIN_VOLT,
 	.fatal_noacin_volt= SHARPSL_FATAL_NOACIN_VOLT,
 	.bat_levels       = 40,
-	.bat_levels_noac  = spitz_battery_levels_noac,
-	.bat_levels_acin  = spitz_battery_levels_acin,
+	.bat_levels_noac  = corgi_battery_levels_noac,
+	.bat_levels_acin  = corgi_battery_levels_acin,
 	.status_high_acin = 188,
 	.status_low_acin  = 178,
 	.status_high_noac = 185,


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
