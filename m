Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZCGEIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZCGEIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 23:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZCGEIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 23:08:17 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:44051 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbZCGEIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 23:08:15 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hid/apple: constify arrays of struct apple_key_translation and adjust users
Date: Sat,  7 Mar 2009 17:07:15 +1300
Message-Id: <1236398835-8211-2-git-send-email-paul@burly.ondioline.org>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1236398835-8211-1-git-send-email-paul@burly.ondioline.org>
References: <49B19FF3.2000605@gmail.com>
 <1236398835-8211-1-git-send-email-paul@burly.ondioline.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark arrays of struct apple_key_translation const so that they may be placed in
.rodata, and adjust users to suit.

Signed-off-by: Paul Collins <paul@ondioline.org>
---
 drivers/hid/hid-apple.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 74429cc..04604df 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -58,7 +58,7 @@ struct apple_key_translation {
 	u8 flags;
 };
 
-static struct apple_key_translation apple_fn_keys[] = {
+static const struct apple_key_translation apple_fn_keys[] = {
 	{ KEY_BACKSPACE, KEY_DELETE },
 	{ KEY_ENTER,	KEY_INSERT },
 	{ KEY_F1,	KEY_BRIGHTNESSDOWN, APPLE_FLAG_FKEY },
@@ -80,7 +80,7 @@ static struct apple_key_translation apple_fn_keys[] = {
 	{ }
 };
 
-static struct apple_key_translation powerbook_fn_keys[] = {
+static const struct apple_key_translation powerbook_fn_keys[] = {
 	{ KEY_BACKSPACE, KEY_DELETE },
 	{ KEY_F1,	KEY_BRIGHTNESSDOWN,     APPLE_FLAG_FKEY },
 	{ KEY_F2,	KEY_BRIGHTNESSUP,       APPLE_FLAG_FKEY },
@@ -99,7 +99,7 @@ static struct apple_key_translation powerbook_fn_keys[] = {
 	{ }
 };
 
-static struct apple_key_translation powerbook_numlock_keys[] = {
+static const struct apple_key_translation powerbook_numlock_keys[] = {
 	{ KEY_J,	KEY_KP1 },
 	{ KEY_K,	KEY_KP2 },
 	{ KEY_L,	KEY_KP3 },
@@ -122,13 +122,13 @@ static struct apple_key_translation powerbook_numlock_keys[] = {
 	{ }
 };
 
-static struct apple_key_translation apple_iso_keyboard[] = {
+static const struct apple_key_translation apple_iso_keyboard[] = {
 	{ KEY_GRAVE,	KEY_102ND },
 	{ KEY_102ND,	KEY_GRAVE },
 	{ }
 };
 
-static struct apple_key_translation apple_swap_modifiers[] = {
+static const struct apple_key_translation apple_swap_modifiers[] = {
 	{ KEY_LEFTALT,	KEY_LEFTMETA },
 	{ KEY_RIGHTALT,	KEY_RIGHTMETA },
 	{ KEY_LEFTMETA,	KEY_LEFTALT },
@@ -136,10 +136,10 @@ static struct apple_key_translation apple_swap_modifiers[] = {
 	{ }
 };
 
-static struct apple_key_translation *apple_find_translation(
-		struct apple_key_translation *table, u16 from)
+static const struct apple_key_translation *apple_find_translation(
+		const struct apple_key_translation *table, u16 from)
 {
-	struct apple_key_translation *trans;
+	const struct apple_key_translation *trans;
 
 	/* Look for the translation */
 	for (trans = table; trans->from; trans++)
@@ -153,7 +153,7 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 		struct hid_usage *usage, __s32 value)
 {
 	struct apple_sc *asc = hid_get_drvdata(hid);
-	struct apple_key_translation *trans;
+	const struct apple_key_translation *trans;
 
 	if (usage->code == KEY_FN) {
 		asc->fn_on = !!value;
@@ -274,7 +274,7 @@ static void apple_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 
 static void apple_setup_input(struct input_dev *input)
 {
-	struct apple_key_translation *trans;
+	const struct apple_key_translation *trans;
 
 	set_bit(KEY_NUMLOCK, input->keybit);
 
-- 
1.6.2

