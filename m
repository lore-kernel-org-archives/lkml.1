Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbZJGVSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbZJGVSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZJGVSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:18:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34991 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbZJGVSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:18:00 -0400
Date: Tue, 6 Oct 2009 22:03:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: zaurus: cleanup sharpsl_pm.c
Message-ID: <20091006200339.GA1538@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes checkpatch/style problems in sharpsl_pm.c, allowing me to
submit real fixes next. Move spitz-specific voltage table to
spitz-specific file.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- linux-rc/arch/arm.ofic/mach-pxa/sharpsl.h	2009-09-10 00:13:59.000000000 +0200
+++ linux-rc/arch/arm/mach-pxa/sharpsl.h	2009-10-06 21:15:40.000000000 +0200
@@ -42,8 +42,6 @@
 #define MAX1111_BATT_TEMP   2u
 #define MAX1111_ACIN_VOLT   6u
 
-extern struct battery_thresh spitz_battery_levels_acin[];
-extern struct battery_thresh spitz_battery_levels_noac[];
 int sharpsl_pm_pxa_read_max1111(int channel);
 
 
diff -ur linux-rc/arch/arm.ofic/mach-pxa/sharpsl_pm.c linux-rc/arch/arm/mach-pxa/sharpsl_pm.c
--- linux-rc/arch/arm.ofic/mach-pxa/sharpsl_pm.c	2009-10-06 13:48:07.000000000 +0200
+++ linux-rc/arch/arm/mach-pxa/sharpsl_pm.c	2009-10-06 21:15:40.000000000 +0200
@@ -78,106 +78,21 @@
 
 
 
-struct battery_thresh spitz_battery_levels_acin[] = {
-	{ 213, 100},
-	{ 212,  98},
-	{ 211,  95},
-	{ 210,  93},
-	{ 209,  90},
-	{ 208,  88},
-	{ 207,  85},
-	{ 206,  83},
-	{ 205,  80},
-	{ 204,  78},
-	{ 203,  75},
-	{ 202,  73},
-	{ 201,  70},
-	{ 200,  68},
-	{ 199,  65},
-	{ 198,  63},
-	{ 197,  60},
-	{ 196,  58},
-	{ 195,  55},
-	{ 194,  53},
-	{ 193,  50},
-	{ 192,  48},
-	{ 192,  45},
-	{ 191,  43},
-	{ 191,  40},
-	{ 190,  38},
-	{ 190,  35},
-	{ 189,  33},
-	{ 188,  30},
-	{ 187,  28},
-	{ 186,  25},
-	{ 185,  23},
-	{ 184,  20},
-	{ 183,  18},
-	{ 182,  15},
-	{ 181,  13},
-	{ 180,  10},
-	{ 179,   8},
-	{ 178,   5},
-	{   0,   0},
-};
-
-struct battery_thresh  spitz_battery_levels_noac[] = {
-	{ 213, 100},
-	{ 212,  98},
-	{ 211,  95},
-	{ 210,  93},
-	{ 209,  90},
-	{ 208,  88},
-	{ 207,  85},
-	{ 206,  83},
-	{ 205,  80},
-	{ 204,  78},
-	{ 203,  75},
-	{ 202,  73},
-	{ 201,  70},
-	{ 200,  68},
-	{ 199,  65},
-	{ 198,  63},
-	{ 197,  60},
-	{ 196,  58},
-	{ 195,  55},
-	{ 194,  53},
-	{ 193,  50},
-	{ 192,  48},
-	{ 191,  45},
-	{ 190,  43},
-	{ 189,  40},
-	{ 188,  38},
-	{ 187,  35},
-	{ 186,  33},
-	{ 185,  30},
-	{ 184,  28},
-	{ 183,  25},
-	{ 182,  23},
-	{ 181,  20},
-	{ 180,  18},
-	{ 179,  15},
-	{ 178,  13},
-	{ 177,  10},
-	{ 176,   8},
-	{ 175,   5},
-	{   0,   0},
-};
-
 /* MAX1111 Commands */
-#define MAXCTRL_PD0      1u << 0
-#define MAXCTRL_PD1      1u << 1
-#define MAXCTRL_SGL      1u << 2
-#define MAXCTRL_UNI      1u << 3
+#define MAXCTRL_PD0      (1u << 0)
+#define MAXCTRL_PD1      (1u << 1)
+#define MAXCTRL_SGL      (1u << 2)
+#define MAXCTRL_UNI      (1u << 3)
 #define MAXCTRL_SEL_SH   4
-#define MAXCTRL_STR      1u << 7
+#define MAXCTRL_STR      (1u << 7)
 
 /*
  * Read MAX1111 ADC
  */
 int sharpsl_pm_pxa_read_max1111(int channel)
 {
-	if (machine_is_tosa()) // Ugly, better move this function into another module
+	/* Ugly, better move this function into another module */
+	if (machine_is_tosa())
 	    return 0;
 
 #ifdef CONFIG_CORGI_SSP_DEPRECATED
@@ -238,7 +153,7 @@
 
 static void sharpsl_battery_thread(struct work_struct *private_)
 {
-	int voltage, percent, apm_status, i = 0;
+	int voltage, percent, apm_status, i;
 
 	if (!sharpsl_pm.machinfo)
 		return;
@@ -250,15 +165,14 @@
 			&& time_after(jiffies, sharpsl_pm.charge_start_time +  SHARPSL_CHARGE_ON_TIME_INTERVAL))
 		schedule_delayed_work(&toggle_charger, 0);
 
-	while(1) {
+	for (i = 0; i < 5; i++) {
 		voltage = sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT);
-
-		if (voltage > 0) break;
-		if (i++ > 5) {
-			voltage = sharpsl_pm.machinfo->bat_levels_noac[0].voltage;
-			dev_warn(sharpsl_pm.dev, "Warning: Cannot read main battery!\n");
+		if (voltage > 0)
 			break;
-		}
+	}
+	if (voltage <= 0) {
+		voltage = sharpsl_pm.machinfo->bat_levels_noac[0].voltage;
+		dev_warn(sharpsl_pm.dev, "Warning: Cannot read main battery!\n");
 	}
 
 	voltage = sharpsl_average_value(voltage);
@@ -266,8 +180,10 @@
 	percent = get_percentage(voltage);
 
 	/* At low battery voltages, the voltage has a tendency to start
-           creeping back up so we try to avoid this here */
-	if ((sharpsl_pm.battstat.ac_status == APM_AC_ONLINE) || (apm_status == APM_BATTERY_STATUS_HIGH) ||  percent <= sharpsl_pm.battstat.mainbat_percent) {
+	   creeping back up so we try to avoid this here */
+	if ((sharpsl_pm.battstat.ac_status == APM_AC_ONLINE)
+	    || (apm_status == APM_BATTERY_STATUS_HIGH)
+	    || percent <= sharpsl_pm.battstat.mainbat_percent) {
 		sharpsl_pm.battstat.mainbat_voltage = voltage;
 		sharpsl_pm.battstat.mainbat_status = apm_status;
 		sharpsl_pm.battstat.mainbat_percent = percent;
@@ -279,8 +195,8 @@
 #ifdef CONFIG_BACKLIGHT_CORGI
 	/* If battery is low. limit backlight intensity to save power. */
 	if ((sharpsl_pm.battstat.ac_status != APM_AC_ONLINE)
-			&& ((sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_LOW) ||
-			(sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_CRITICAL))) {
+	    && ((sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_LOW)
+	    || (sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_CRITICAL))) {
 		if (!(sharpsl_pm.flags & SHARPSL_BL_LIMIT)) {
 			sharpsl_pm.machinfo->backlight_limit(1);
 			sharpsl_pm.flags |= SHARPSL_BL_LIMIT;
@@ -293,8 +209,8 @@
 
 	/* Suspend if critical battery level */
 	if ((sharpsl_pm.battstat.ac_status != APM_AC_ONLINE)
-			&& (sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_CRITICAL)
-			&& !(sharpsl_pm.flags & SHARPSL_APM_QUEUED)) {
+	     && (sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_CRITICAL)
+	     && !(sharpsl_pm.flags & SHARPSL_APM_QUEUED)) {
 		sharpsl_pm.flags |= SHARPSL_APM_QUEUED;
 		dev_err(sharpsl_pm.dev, "Fatal Off\n");
 		apm_queue_event(APM_CRITICAL_SUSPEND);
@@ -346,7 +264,7 @@
 
 static void sharpsl_charge_toggle(struct work_struct *private_)
 {
-	dev_dbg(sharpsl_pm.dev, "Toogling Charger at time: %lx\n", jiffies);
+	dev_dbg(sharpsl_pm.dev, "Toggling Charger at time: %lx\n", jiffies);
 
 	if (!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN)) {
 		sharpsl_charge_off();
@@ -368,7 +286,7 @@
 {
 	int acin = sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN);
 
-	dev_dbg(sharpsl_pm.dev, "AC Status: %d\n",acin);
+	dev_dbg(sharpsl_pm.dev, "AC Status: %d\n", acin);
 
 	sharpsl_average_clear();
 	if (acin && (sharpsl_pm.charge_mode != CHRG_ON))
@@ -472,14 +390,14 @@
 	sharpsl_ad[sharpsl_ad_index] = ad;
 	sharpsl_ad_index++;
 	if (sharpsl_ad_index >= SHARPSL_CNV_VALUE_NUM) {
-		for (i=0; i < (SHARPSL_CNV_VALUE_NUM-1); i++)
+		for (i = 0; i < (SHARPSL_CNV_VALUE_NUM-1); i++)
 			sharpsl_ad[i] = sharpsl_ad[i+1];
 		sharpsl_ad_index = SHARPSL_CNV_VALUE_NUM - 1;
 	}
-	for (i=0; i < sharpsl_ad_index; i++)
+	for (i = 0; i < sharpsl_ad_index; i++)
 		ad_val += sharpsl_ad[i];
 
-	return (ad_val / sharpsl_ad_index);
+	return ad_val / sharpsl_ad_index;
 }
 
 /*
@@ -492,8 +410,8 @@
 
 	/* Find MAX val */
 	temp = val[0];
-	j=0;
-	for (i=1; i<5; i++) {
+	j = 0;
+	for (i = 1; i < 5; i++) {
 		if (temp < val[i]) {
 			temp = val[i];
 			j = i;
@@ -502,21 +420,21 @@
 
 	/* Find MIN val */
 	temp = val[4];
-	k=4;
-	for (i=3; i>=0; i--) {
+	k = 4;
+	for (i = 3; i >= 0; i--) {
 		if (temp > val[i]) {
 			temp = val[i];
 			k = i;
 		}
 	}
 
-	for (i=0; i<5; i++)
-		if (i != j && i != k )
+	for (i = 0; i < 5; i++)
+		if (i != j && i != k)
 			sum += val[i];
 
 	dev_dbg(sharpsl_pm.dev, "Average: %d from values: %d, %d, %d, %d, %d\n", sum/3, val[0], val[1], val[2], val[3], val[4]);
 
-	return (sum/3);
+	return sum/3;
 }
 
 static int sharpsl_check_battery_temp(void)
@@ -524,7 +442,7 @@
 	int val, i, buff[5];
 
 	/* Check battery temperature */
-	for (i=0; i<5; i++) {
+	for (i = 0; i < 5; i++) {
 		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP);
 		sharpsl_pm.machinfo->measure_temp(1);
 		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP);
@@ -557,7 +477,7 @@
 		sharpsl_pm.machinfo->discharge1(1);
 
 	/* Check battery voltage */
-	for (i=0; i<5; i++) {
+	for (i = 0; i < 5; i++) {
 		buff[i] = sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT);
 		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_VOLT);
 	}
@@ -581,16 +501,16 @@
 {
 	int temp, i, buff[5];
 
-	for (i=0; i<5; i++) {
+	for (i = 0; i < 5; i++) {
 		buff[i] = sharpsl_pm.machinfo->read_devdata(SHARPSL_ACIN_VOLT);
 		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_ACIN);
 	}
 
 	temp = get_select_val(buff);
-	dev_dbg(sharpsl_pm.dev, "AC Voltage: %d\n",temp);
+	dev_dbg(sharpsl_pm.dev, "AC Voltage: %d\n", temp);
 
 	if ((temp > sharpsl_pm.machinfo->charge_acin_high) || (temp < sharpsl_pm.machinfo->charge_acin_low)) {
-		dev_err(sharpsl_pm.dev, "Error: AC check failed.\n");
+		dev_err(sharpsl_pm.dev, "Error: AC check failed: voltage %d.\n", temp);
 		return -1;
 	}
 
@@ -624,9 +544,9 @@
 
 static void corgi_goto_sleep(unsigned long alarm_time, unsigned int alarm_enable, suspend_state_t state)
 {
-	dev_dbg(sharpsl_pm.dev, "Time is: %08x\n",RCNR);
+	dev_dbg(sharpsl_pm.dev, "Time is: %08x\n", RCNR);
 
-	dev_dbg(sharpsl_pm.dev, "Offline Charge Activate = %d\n",sharpsl_pm.flags & SHARPSL_DO_OFFLINE_CHRG);
+	dev_dbg(sharpsl_pm.dev, "Offline Charge Activate = %d\n", sharpsl_pm.flags & SHARPSL_DO_OFFLINE_CHRG);
 	/* not charging and AC-IN! */
 
 	if ((sharpsl_pm.flags & SHARPSL_DO_OFFLINE_CHRG) && (sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN))) {
@@ -644,12 +564,12 @@
 	if ((sharpsl_pm.charge_mode == CHRG_ON) && ((alarm_enable && ((alarm_time - RCNR) > (SHARPSL_BATCHK_TIME_SUSPEND + 30))) || !alarm_enable)) {
 		RTSR &= RTSR_ALE;
 		RTAR = RCNR + SHARPSL_BATCHK_TIME_SUSPEND;
-		dev_dbg(sharpsl_pm.dev, "Charging alarm at: %08x\n",RTAR);
+		dev_dbg(sharpsl_pm.dev, "Charging alarm at: %08x\n", RTAR);
 		sharpsl_pm.flags |= SHARPSL_ALARM_ACTIVE;
 	} else if (alarm_enable) {
 		RTSR &= RTSR_ALE;
 		RTAR = alarm_time;
-		dev_dbg(sharpsl_pm.dev, "User alarm at: %08x\n",RTAR);
+		dev_dbg(sharpsl_pm.dev, "User alarm at: %08x\n", RTAR);
 	} else {
 		dev_dbg(sharpsl_pm.dev, "No alarms set.\n");
 	}
@@ -658,19 +578,18 @@
 
 	sharpsl_pm.machinfo->postsuspend();
 
-	dev_dbg(sharpsl_pm.dev, "Corgi woken up from suspend: %08x\n",PEDR);
+	dev_dbg(sharpsl_pm.dev, "Corgi woken up from suspend: %08x\n", PEDR);
 }
 
 static int corgi_enter_suspend(unsigned long alarm_time, unsigned int alarm_enable, suspend_state_t state)
 {
-	if (!sharpsl_pm.machinfo->should_wakeup(!(sharpsl_pm.flags & SHARPSL_ALARM_ACTIVE) && alarm_enable) )
-	{
+	if (!sharpsl_pm.machinfo->should_wakeup(!(sharpsl_pm.flags & SHARPSL_ALARM_ACTIVE) && alarm_enable)) {
 		if (!(sharpsl_pm.flags & SHARPSL_ALARM_ACTIVE)) {
 			dev_dbg(sharpsl_pm.dev, "No user triggered wakeup events and not charging. Strange. Suspend.\n");
 			corgi_goto_sleep(alarm_time, alarm_enable, state);
 			return 1;
 		}
-		if(sharpsl_off_charge_battery()) {
+		if (sharpsl_off_charge_battery()) {
 			dev_dbg(sharpsl_pm.dev, "Charging. Suspend...\n");
 			corgi_goto_sleep(alarm_time, alarm_enable, state);
 			return 1;
@@ -697,7 +616,7 @@
 
 	corgi_goto_sleep(alarm_time, alarm_status, state);
 
-	while (corgi_enter_suspend(alarm_time,alarm_status,state))
+	while (corgi_enter_suspend(alarm_time, alarm_status, state))
 		{}
 
 	if (sharpsl_pm.machinfo->earlyresume)
@@ -732,7 +651,7 @@
 		sharpsl_pm.machinfo->discharge1(1);
 
 	/* Check battery : check inserting battery ? */
-	for (i=0; i<5; i++) {
+	for (i = 0; i < 5; i++) {
 		buff[i] = sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT);
 		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_VOLT);
 	}
@@ -812,7 +731,7 @@
 		mdelay(SHARPSL_CHARGE_CO_CHECK_TIME);
 
 		time = RCNR;
-		while(1) {
+		while (1) {
 			/* Check if any wakeup event had occurred */
 			if (sharpsl_pm.machinfo->charger_wakeup() != 0)
 				return 0;
@@ -835,9 +754,9 @@
 	mdelay(SHARPSL_CHARGE_CO_CHECK_TIME);
 
 	time = RCNR;
-	while(1) {
+	while (1) {
 		/* Check if any wakeup event had occurred */
-		if (sharpsl_pm.machinfo->charger_wakeup() != 0)
+		if (sharpsl_pm.machinfo->charger_wakeup())
 			return 0;
 		/* Check for timeout */
 		if ((RCNR-time) > SHARPSL_WAIT_CO_TIME) {
@@ -864,12 +783,12 @@
 
 static ssize_t battery_percentage_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n",sharpsl_pm.battstat.mainbat_percent);
+	return sprintf(buf, "%d\n", sharpsl_pm.battstat.mainbat_percent);
 }
 
 static ssize_t battery_voltage_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n",sharpsl_pm.battstat.mainbat_voltage);
+	return sprintf(buf, "%d\n", sharpsl_pm.battstat.mainbat_voltage);
 }
 
 static DEVICE_ATTR(battery_percentage, 0444, battery_percentage_show, NULL);
@@ -943,8 +862,7 @@
 		}
 	}
 
-	if (sharpsl_pm.machinfo->batfull_irq)
-	{
+	if (sharpsl_pm.machinfo->batfull_irq) {
 		/* Register interrupt handler. */
 		if (request_irq(IRQ_GPIO(sharpsl_pm.machinfo->gpio_batfull), sharpsl_chrg_full_isr, IRQF_DISABLED | IRQF_TRIGGER_RISING, "CO", sharpsl_chrg_full_isr)) {
 			dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", IRQ_GPIO(sharpsl_pm.machinfo->gpio_batfull));
--- linux-rc/arch/arm.ofic/mach-pxa/spitz_pm.c	2009-09-10 00:13:59.000000000 +0200
+++ linux-rc/arch/arm/mach-pxa/spitz_pm.c	2009-10-06 21:15:40.000000000 +0200
@@ -37,6 +37,93 @@
 
 static int spitz_last_ac_status;
 
+static const struct battery_thresh spitz_battery_levels_acin[] = {
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
+static const struct battery_thresh  spitz_battery_levels_noac[] = {
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
+
 static void spitz_charger_init(void)
 {
 	pxa_gpio_mode(SPITZ_GPIO_KEY_INT | GPIO_IN);
@@ -103,7 +190,7 @@
 	PFER = GPIO_bit(SPITZ_GPIO_KEY_INT) | GPIO_bit(SPITZ_GPIO_RESET);
 	PWER = GPIO_bit(SPITZ_GPIO_KEY_INT) | GPIO_bit(SPITZ_GPIO_RESET) | PWER_RTC;
 	PKWR = GPIO_bit(SPITZ_GPIO_SYNC) | GPIO_bit(SPITZ_GPIO_KEY_INT) | GPIO_bit(SPITZ_GPIO_RESET);
-	PKSR = 0xffffffff; // clear
+	PKSR = 0xffffffff; /* clear */
 
 	/* nRESET_OUT Disable */
 	PSLR |= PSLR_SL_ROD;
@@ -149,7 +236,7 @@
 	if (resume_on_alarm && (PEDR & PWER_RTC))
 		is_resume |= PWER_RTC;
 
-	dev_dbg(sharpsl_pm.dev, "is_resume: %x\n",is_resume);
+	dev_dbg(sharpsl_pm.dev, "is_resume: %x\n", is_resume);
 	return is_resume;
 }
 
@@ -160,7 +247,7 @@
 
 unsigned long spitzpm_read_devdata(int type)
 {
-	switch(type) {
+	switch (type) {
 	case SHARPSL_STATUS_ACIN:
 		return (((~GPLR(SPITZ_GPIO_AC_IN)) & GPIO_bit(SPITZ_GPIO_AC_IN)) != 0);
 	case SHARPSL_STATUS_LOCK:
@@ -199,7 +286,7 @@
 #if defined(CONFIG_LCD_CORGI)
 	.backlight_limit = corgi_lcd_limit_intensity,
 #elif defined(CONFIG_BACKLIGHT_CORGI)
-        .backlight_limit  = corgibl_limit_intensity,
+	.backlight_limit  = corgibl_limit_intensity,
 #endif
 	.charge_on_volt	  = SHARPSL_CHARGE_ON_VOLT,
 	.charge_on_temp	  = SHARPSL_CHARGE_ON_TEMP,
@@ -241,7 +328,7 @@
 
 static void spitzpm_exit(void)
 {
- 	platform_device_unregister(spitzpm_device);
+	platform_device_unregister(spitzpm_device);
 }
 
 module_init(spitzpm_init);


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
