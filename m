Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbXIZBpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbXIZBpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 21:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbXIZBpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 21:45:35 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2645 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbXIZBpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 21:45:34 -0400
Subject: [PATCH] - drivers/hid/hid-debug.c  - trivial - add KERN_DEBUG
	prefix, fix typo, constify
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 25 Sep 2007 18:44:58 -0700
Message-Id: <1190771098.17052.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Added KERN_DEBUG to output lines
Fixed preffered -> preferred typo
Added const to char *'s

Also, exported symbol hid_resolv_event is unused by the current
kernel tree and perhaps should be removed.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index a13757b..7754530 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -34,7 +34,7 @@
 struct hid_usage_entry {
 	unsigned  page;
 	unsigned  usage;
-	char     *description;
+	const char     *description;
 };
 
 static const struct hid_usage_entry hid_usage_table[] = {
@@ -365,8 +365,8 @@ void hid_resolv_usage(unsigned usage) {
 }
 EXPORT_SYMBOL_GPL(hid_resolv_usage);
 
-__inline__ static void tab(int n) {
-	while (n--) printk(" ");
+static void tab(int n) {
+	printk(KERN_DEBUG "%*s", n, "");
 }
 
 void hid_dump_field(struct hid_field *field, int n) {
@@ -401,8 +401,8 @@ void hid_dump_field(struct hid_field *field, int n) {
 		tab(n); printk("Unit Exponent(%d)\n", field->unit_exponent);
 	}
 	if (field->unit) {
-		char *systems[5] = { "None", "SI Linear", "SI Rotation", "English Linear", "English Rotation" };
-		char *units[5][8] = {
+		static const char *systems[5] = { "None", "SI Linear", "SI Rotation", "English Linear", "English Rotation" };
+		static const char *units[5][8] = {
 			{ "None", "None", "None", "None", "None", "None", "None", "None" },
 			{ "None", "Centimeter", "Gram", "Seconds", "Kelvin",     "Ampere", "Candela", "None" },
 			{ "None", "Radians",    "Gram", "Seconds", "Kelvin",     "Ampere", "Candela", "None" },
@@ -457,7 +457,7 @@ void hid_dump_field(struct hid_field *field, int n) {
 	printk("%s", HID_MAIN_ITEM_RELATIVE & j ? "Relative " : "Absolute ");
 	printk("%s", HID_MAIN_ITEM_WRAP & j ? "Wrap " : "");
 	printk("%s", HID_MAIN_ITEM_NONLINEAR & j ? "NonLinear " : "");
-	printk("%s", HID_MAIN_ITEM_NO_PREFERRED & j ? "NoPrefferedState " : "");
+	printk("%s", HID_MAIN_ITEM_NO_PREFERRED & j ? "NoPreferredState " : "");
 	printk("%s", HID_MAIN_ITEM_NULL_STATE & j ? "NullState " : "");
 	printk("%s", HID_MAIN_ITEM_VOLATILE & j ? "Volatile " : "");
 	printk("%s", HID_MAIN_ITEM_BUFFERED_BYTE & j ? "BufferedByte " : "");
@@ -470,7 +470,7 @@ void hid_dump_device(struct hid_device *device) {
 	struct hid_report *report;
 	struct list_head *list;
 	unsigned i,k;
-	static char *table[] = {"INPUT", "OUTPUT", "FEATURE"};
+	static const char *table[] = {"INPUT", "OUTPUT", "FEATURE"};
 
 	if (!hid_debug)
 		return;
@@ -501,13 +501,13 @@ void hid_dump_input(struct hid_usage *usage, __s32 value) {
 	if (!hid_debug)
 		return;
 
-	printk("hid-debug: input ");
+	printk(KERN_DEBUG "hid-debug: input ");
 	hid_resolv_usage(usage->hid);
 	printk(" = %d\n", value);
 }
 EXPORT_SYMBOL_GPL(hid_dump_input);
 
-static char *events[EV_MAX + 1] = {
+static const char *events[EV_MAX + 1] = {
 	[EV_SYN] = "Sync",			[EV_KEY] = "Key",
 	[EV_REL] = "Relative",			[EV_ABS] = "Absolute",
 	[EV_MSC] = "Misc",			[EV_LED] = "LED",
@@ -516,10 +516,10 @@ static char *events[EV_MAX + 1] = {
 	[EV_FF_STATUS] = "ForceFeedbackStatus",
 };
 
-static char *syncs[2] = {
+static const char *syncs[2] = {
 	[SYN_REPORT] = "Report",		[SYN_CONFIG] = "Config",
 };
-static char *keys[KEY_MAX + 1] = {
+static const char *keys[KEY_MAX + 1] = {
 	[KEY_RESERVED] = "Reserved",		[KEY_ESC] = "Esc",
 	[KEY_1] = "1",				[KEY_2] = "2",
 	[KEY_3] = "3",				[KEY_4] = "4",
@@ -715,7 +715,7 @@ static char *keys[KEY_MAX + 1] = {
 	[KEY_SWITCHVIDEOMODE] = "SwitchVideoMode",
 };
 
-static char *relatives[REL_MAX + 1] = {
+static const char *relatives[REL_MAX + 1] = {
 	[REL_X] = "X",			[REL_Y] = "Y",
 	[REL_Z] = "Z",			[REL_RX] = "Rx",
 	[REL_RY] = "Ry",		[REL_RZ] = "Rz",
@@ -723,7 +723,7 @@ static char *relatives[REL_MAX + 1] = {
 	[REL_WHEEL] = "Wheel",		[REL_MISC] = "Misc",
 };
 
-static char *absolutes[ABS_MAX + 1] = {
+static const char *absolutes[ABS_MAX + 1] = {
 	[ABS_X] = "X",			[ABS_Y] = "Y",
 	[ABS_Z] = "Z",			[ABS_RX] = "Rx",
 	[ABS_RY] = "Ry",		[ABS_RZ] = "Rz",
@@ -739,12 +739,12 @@ static char *absolutes[ABS_MAX + 1] = {
 	[ABS_VOLUME] = "Volume",	[ABS_MISC] = "Misc",
 };
 
-static char *misc[MSC_MAX + 1] = {
+static const char *misc[MSC_MAX + 1] = {
 	[MSC_SERIAL] = "Serial",	[MSC_PULSELED] = "Pulseled",
 	[MSC_GESTURE] = "Gesture",	[MSC_RAW] = "RawData"
 };
 
-static char *leds[LED_MAX + 1] = {
+static const char *leds[LED_MAX + 1] = {
 	[LED_NUML] = "NumLock",		[LED_CAPSL] = "CapsLock",
 	[LED_SCROLLL] = "ScrollLock",	[LED_COMPOSE] = "Compose",
 	[LED_KANA] = "Kana",		[LED_SLEEP] = "Sleep",
@@ -752,16 +752,16 @@ static char *leds[LED_MAX + 1] = {
 	[LED_MISC] = "Misc",
 };
 
-static char *repeats[REP_MAX + 1] = {
+static const char *repeats[REP_MAX + 1] = {
 	[REP_DELAY] = "Delay",		[REP_PERIOD] = "Period"
 };
 
-static char *sounds[SND_MAX + 1] = {
+static const char *sounds[SND_MAX + 1] = {
 	[SND_CLICK] = "Click",		[SND_BELL] = "Bell",
 	[SND_TONE] = "Tone"
 };
 
-static char **names[EV_MAX + 1] = {
+static const char **names[EV_MAX + 1] = {
 	[EV_SYN] = syncs,			[EV_KEY] = keys,
 	[EV_REL] = relatives,			[EV_ABS] = absolutes,
 	[EV_MSC] = misc,			[EV_LED] = leds,
@@ -777,4 +777,3 @@ void hid_resolv_event(__u8 type, __u16 code) {
 		names[type] ? (names[type][code] ? names[type][code] : "?") : "?");
 }
 EXPORT_SYMBOL_GPL(hid_resolv_event);
-


