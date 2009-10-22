Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbZJVURX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbZJVURX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 16:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZJVURW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 16:17:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59593 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbZJVURV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 16:17:21 -0400
Date: Thu, 22 Oct 2009 22:17:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
Subject: Re: zaurus: cleanup sharpsl_pm.c (fwd)
Message-ID: <20091022201718.GF6611@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I sent this to Eric, here it is for public record, too.)

Hi!


> >> > Well, I'd say that the sharing leads to some very ugly code. ... so
> >> > I'd preer it unshared.
> >> >
> >>
> >> I suggest to re-name it to "sharpsl_" something instead of "spitz_",
> >> to be less confusing at this moment.
> >
> > Yep, but lets do that as next patch, ok?

---

Battery power levels are shared between spitz and corgi, rename
variable to reflect it.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-pxa/corgi_pm.c b/arch/arm/mach-pxa/corgi_pm.c
index a093282..d4a0733 100644
--- a/arch/arm/mach-pxa/corgi_pm.c
+++ b/arch/arm/mach-pxa/corgi_pm.c
@@ -214,8 +214,8 @@ static struct sharpsl_charger_machinfo corgi_pm_machinfo = {
 	.fatal_acin_volt  = SHARPSL_FATAL_ACIN_VOLT,
 	.fatal_noacin_volt= SHARPSL_FATAL_NOACIN_VOLT,
 	.bat_levels       = 40,
-	.bat_levels_noac  = spitz_battery_levels_noac,
-	.bat_levels_acin  = spitz_battery_levels_acin,
+	.bat_levels_noac  = sharpsl_battery_levels_noac,
+	.bat_levels_acin  = sharpsl_battery_levels_acin,
 	.status_high_acin = 188,
 	.status_low_acin  = 178,
 	.status_high_noac = 185,
diff --git a/arch/arm/mach-pxa/sharpsl.h b/arch/arm/mach-pxa/sharpsl.h
index 55259f4..1439785 100644
--- a/arch/arm/mach-pxa/sharpsl.h
+++ b/arch/arm/mach-pxa/sharpsl.h
@@ -42,8 +42,8 @@ void corgi_lcdtg_hw_init(int mode);
 #define MAX1111_BATT_TEMP   2u
 #define MAX1111_ACIN_VOLT   6u
 
-extern struct battery_thresh spitz_battery_levels_acin[];
-extern struct battery_thresh spitz_battery_levels_noac[];
+extern struct battery_thresh sharpsl_battery_levels_acin[];
+extern struct battery_thresh sharpsl_battery_levels_noac[];
 int sharpsl_pm_pxa_read_max1111(int channel);
 
 
diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index dc3907f..67229a1 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -78,7 +78,7 @@ DEFINE_LED_TRIGGER(sharpsl_charge_led_trigger);
 
 
 
-struct battery_thresh spitz_battery_levels_acin[] = {
+struct battery_thresh sharpsl_battery_levels_acin[] = {
 	{ 213, 100},
 	{ 212,  98},
 	{ 211,  95},
@@ -121,7 +121,7 @@ struct battery_thresh spitz_battery_levels_acin[] = {
 	{   0,   0},
 };
 
-struct battery_thresh  spitz_battery_levels_noac[] = {
+struct battery_thresh sharpsl_battery_levels_noac[] = {
 	{ 213, 100},
 	{ 212,  98},
 	{ 211,  95},
diff --git a/arch/arm/mach-pxa/spitz_pm.c b/arch/arm/mach-pxa/spitz_pm.c
index 60bfaff..fc5a70c 100644
--- a/arch/arm/mach-pxa/spitz_pm.c
+++ b/arch/arm/mach-pxa/spitz_pm.c
@@ -208,8 +208,8 @@ struct sharpsl_charger_machinfo spitz_pm_machinfo = {
 	.fatal_acin_volt  = SHARPSL_FATAL_ACIN_VOLT,
 	.fatal_noacin_volt= SHARPSL_FATAL_NOACIN_VOLT,
 	.bat_levels       = 40,
-	.bat_levels_noac  = spitz_battery_levels_noac,
-	.bat_levels_acin  = spitz_battery_levels_acin,
+	.bat_levels_noac  = sharpsl_battery_levels_noac,
+	.bat_levels_acin  = sharpsl_battery_levels_acin,
 	.status_high_acin = 188,
 	.status_low_acin  = 178,
 	.status_high_noac = 185,


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

----- End forwarded message -----

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
