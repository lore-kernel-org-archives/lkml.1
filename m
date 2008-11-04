Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYKDMci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYKDMci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 07:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYKDMbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 07:31:44 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:37468 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbYKDMbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 07:31:42 -0500
Message-ID: <491040AA.7010208@euromail.se>
Date: Tue, 04 Nov 2008 13:31:38 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] input: Map missing keys to appropriate functions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1KxL4O-00084p-3J.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KxL4O-00084p-3J 13167ac479c1987c28129c60fb896ab2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On macbooks there are specific keys for the user-space functions Expose
and Dashboard, which currently has no counterpart in input.h. This patch
adds KEY_SCALE and KEY_DASHBOARD, and maps the keyboard accordingly.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-apple.c |    5 +++--
 include/linux/input.h   |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index c6ab4ba..b25d90c 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -55,10 +55,11 @@ struct apple_key_translation {

 static struct apple_key_translation apple_fn_keys[] = {
 	{ KEY_BACKSPACE, KEY_DELETE },
+	{ KEY_ENTER,	KEY_INSERT },
 	{ KEY_F1,	KEY_BRIGHTNESSDOWN, APPLE_FLAG_FKEY },
 	{ KEY_F2,	KEY_BRIGHTNESSUP,   APPLE_FLAG_FKEY },
-	{ KEY_F3,	KEY_FN_F5,          APPLE_FLAG_FKEY }, /* Exposé */
-	{ KEY_F4,	KEY_FN_F4,          APPLE_FLAG_FKEY }, /* Dashboard */
+	{ KEY_F3,	KEY_SCALE,          APPLE_FLAG_FKEY },
+	{ KEY_F4,	KEY_DASHBOARD,      APPLE_FLAG_FKEY },
 	{ KEY_F5,	KEY_KBDILLUMDOWN,   APPLE_FLAG_FKEY },
 	{ KEY_F6,	KEY_KBDILLUMUP,     APPLE_FLAG_FKEY },
 	{ KEY_F7,	KEY_PREVIOUSSONG,   APPLE_FLAG_FKEY },
diff --git a/include/linux/input.h b/include/linux/input.h
index b86fb55..5341e82 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -238,6 +238,7 @@ struct input_absinfo {
 #define KEY_KPEQUAL		117
 #define KEY_KPPLUSMINUS		118
 #define KEY_PAUSE		119
+#define KEY_SCALE		120	/* AL Compiz Scale (Expose) */

 #define KEY_KPCOMMA		121
 #define KEY_HANGEUL		122
@@ -322,6 +323,7 @@ struct input_absinfo {
 #define KEY_PAUSECD		201
 #define KEY_PROG3		202
 #define KEY_PROG4		203
+#define KEY_DASHBOARD		204	/* AL Dashboard */
 #define KEY_SUSPEND		205
 #define KEY_CLOSE		206	/* AC Close */
 #define KEY_PLAY		207
-- 
1.5.6.3

