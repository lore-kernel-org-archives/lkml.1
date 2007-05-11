Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbXEKDGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbXEKDGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 23:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXEKDFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 23:05:53 -0400
Received: from mail.sjtu.org ([202.120.5.34]:46399 "ehlo appsrv1.sjtu.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754017AbXEKDFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 23:05:53 -0400
Subject: [PATCH] v4l: saa7134: support ir-remote for 10moons TM300
From: Tony Wan <wankai@sjtu.org>
To: mchehab@infradead.org, michael@mihu.de
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 May 2007 11:02:36 +0800
Message-Id: <1178852562.7216.4.camel@wankai.sjtu.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the IR-remote of the 10moons TM300 card and add the key-codes for
it's remote. 

It has been tested using lirc. All the key codes are accepted.

Signed-off-by: Tony Wan <wankai@sjtu.org>
---
 drivers/media/common/ir-keymaps.c           |   69
+++++++++++++++++++++++++++
 drivers/media/video/saa7134/saa7134-cards.c |    1 +
 drivers/media/video/saa7134/saa7134-input.c |    6 ++
 include/media/ir-common.h                   |    1 +
 4 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/ir-keymaps.c
b/drivers/media/common/ir-keymaps.c
index cbd1184..5aa293e 100644
--- a/drivers/media/common/ir-keymaps.c
+++ b/drivers/media/common/ir-keymaps.c
@@ -1783,3 +1783,72 @@ IR_KEYTAB_TYPE ir_codes_tt_1500[IR_KEYTAB_SIZE] =
{
 };
 
 EXPORT_SYMBOL_GPL(ir_codes_tt_1500);
+
+/* 10MOONS TM300 */
+IR_KEYTAB_TYPE ir_codes_10moonstm3[IR_KEYTAB_SIZE] = {
+	[ 0x10 ] = KEY_POWER,           // Power
+	[ 0x0d ] = KEY_MUTE,            // Mute
+	[ 0x1e ] = KEY_TUNER,           // Cable
+	[ 0x00 ] = KEY_VIDEO,           // Composite / S-Video
+	[ 0x01 ] = KEY_RADIO,           // Music
+	[ 0x02 ] = KEY_TEXT,            // Photo
+
+	[ 0x1f ] = KEY_1,
+	[ 0x03 ] = KEY_2,
+	[ 0x04 ] = KEY_3,
+	[ 0x05 ] = KEY_4,
+	[ 0x1c ] = KEY_5,
+	[ 0x06 ] = KEY_6,
+	[ 0x07 ] = KEY_7,
+	[ 0x08 ] = KEY_8,
+	[ 0x1d ] = KEY_9,
+	[ 0x09 ] = KEY_SELECT,          // 2 digit select (-/--)
+	[ 0x0a ] = KEY_0,
+	[ 0x0b ] = KEY_AGAIN,           // Recall
+
+	[ 0x14 ] = KEY_F1,              // Begin
+	[ 0x15 ] = KEY_F2,              // End
+
+	[ 0x16 ] = KEY_CHANNELUP,       // CH+
+	[ 0x12 ] = KEY_CHANNELDOWN,     // CH-
+	[ 0x0c ] = KEY_VOLUMEUP,        // VOL+
+	[ 0x17 ] = KEY_VOLUMEDOWN,      // VOL-
+	[ 0x18 ] = KEY_OK,              // OK
+
+	[ 0x0e ] = KEY_EXIT,            // Exit
+	[ 0x13 ] = KEY_COMPUTER,        // Desktop
+	[ 0x11 ] = KEY_TAB,             // TAB
+	[ 0x19 ] = KEY_CYCLEWINDOWS,    // Switch task
+
+	[ 0x1a ] = KEY_MENU,            // Menu
+	[ 0x1b ] = KEY_ZOOM,            // Fullscreen
+	[ 0x24 ] = KEY_ARCHIVE,         // Time shifting
+	[ 0x20 ] = KEY_SWITCHVIDEOMODE, // Selcect source
+
+	[ 0x3a ] = KEY_RECORD,          // Record
+	[ 0x22 ] = KEY_PLAY,            // Play/Pause
+	[ 0x25 ] = KEY_STOP,            // Stop
+	[ 0x23 ] = KEY_CAMERA,          // Snapshot
+
+	[ 0x28 ] = KEY_BACK,            // Backward <<
+	[ 0x2a ] = KEY_FORWARD,         // Forward >>
+	[ 0x29 ] = KEY_PREVIOUS,        // Back |<<
+	[ 0x2b ] = KEY_NEXT,            // End >>|
+
+	[ 0x2c ] = KEY_PROGRAM,         // Multi-view
+	[ 0x2d ] = KEY_AUDIO,           // Audio Tracks
+	[ 0x2e ] = KEY_SOUND,           // Sound
+	[ 0x2f ] = KEY_SUBTITLE,        // Subtitles
+
+	[ 0x30 ] = KEY_TIME,            // Set timer
+	[ 0x31 ] = KEY_CHANNEL,         // Stereo
+	[ 0x32 ] = KEY_LANGUAGE,        // Language
+	[ 0x33 ] = KEY_TEXT,            // Text
+
+	[ 0x39 ] = KEY_RED,             // RED
+	[ 0x21 ] = KEY_GREEN,           // GREEN
+	[ 0x27 ] = KEY_YELLOW,          // YELLOW
+	[ 0x37 ] = KEY_BLUE,            // BLUE
+};
+
+EXPORT_SYMBOL_GPL(ir_codes_10moonstm3);
diff --git a/drivers/media/video/saa7134/saa7134-cards.c
b/drivers/media/video/saa7134/saa7134-cards.c
index 44f2077..5813509 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -4368,6 +4368,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
 	case SAA7134_BOARD_ENCORE_ENLTV:
 	case SAA7134_BOARD_ENCORE_ENLTV_FM:
+	case SAA7134_BOARD_10MOONSTVMASTER3:
 		dev->has_remote = SAA7134_REMOTE_GPIO;
 		break;
 	case SAA7134_BOARD_FLYDVBS_LR300:
diff --git a/drivers/media/video/saa7134/saa7134-input.c
b/drivers/media/video/saa7134/saa7134-input.c
index c0de37e..c87755b 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -333,6 +333,12 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keyup   = 0x040000;
 		polling      = 50; // ms
 		break;
+	case SAA7134_BOARD_10MOONSTVMASTER3:
+		ir_codes     = ir_codes_10moonstm3;
+		mask_keycode = 0x4f80000;
+		mask_keyup   = 0x8000000;
+		polling      = 50; //ms
+		break;
 	}
 	if (NULL == ir_codes) {
 		printk("%s: Oops: IR config error [card=%d]\n",
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 9807a7c..4e4d207 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -140,6 +140,7 @@ extern IR_KEYTAB_TYPE
ir_codes_budget_ci_old[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_asus_pc39[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_encore_enltv[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_tt_1500[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_10moonstm3[IR_KEYTAB_SIZE];
 
 #endif
 


