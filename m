Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXEJDNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXEJDNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 23:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbXEJDNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 23:13:10 -0400
Received: from mail.sjtu.org ([202.120.5.34]:7562 "ehlo appsrv1.sjtu.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751743AbXEJDNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 23:13:08 -0400
Subject: [PATCH 2/3] v4l: saa7134: enable ir-remote for 10moons TM300 card
From: Tony Wan <wankai@sjtu.org>
To: mchehab@infradead.org, michael@mihu.de
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 10 May 2007 11:04:02 +0800
Message-Id: <1178766248.29993.41.camel@wankai.sjtu.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the IR-remote of the 10moons TM300 card and add the key-codes for
it's remote. But to enable all the keys, "IR_KEYTAB_SIZE", the size of
code tables should be at least 256.

It has been tested using lirc. All the key codes are accepted.

This patch depends on the "[PATCH 1/3] v4l: Support 10moons TM300
(saa7130) Card"

Signed-off-by: Tony Wan <wankai@sjtu.org>
---
 drivers/media/common/ir-keymaps.c           |   71
+++++++++++++++++++++++++++
 drivers/media/video/saa7134/saa7134-cards.c |    1 +
 drivers/media/video/saa7134/saa7134-input.c |    6 ++
 include/media/ir-common.h                   |    1 +
 4 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/ir-keymaps.c
b/drivers/media/common/ir-keymaps.c
index cbd1184..df11ed4 100644
--- a/drivers/media/common/ir-keymaps.c
+++ b/drivers/media/common/ir-keymaps.c
@@ -1783,3 +1783,74 @@ IR_KEYTAB_TYPE ir_codes_tt_1500[IR_KEYTAB_SIZE] =
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
+#if IR_KEYTAB_SIZE>=256
+	[ 0x84 ] = KEY_ARCHIVE,         // Time shifting
+	[ 0x80 ] = KEY_SWITCHVIDEOMODE, // Selcect source
+
+	[ 0x9a ] = KEY_RECORD,          // Record
+	[ 0x82 ] = KEY_PLAY,            // Play/Pause
+	[ 0x85 ] = KEY_STOP,            // Stop
+	[ 0x83 ] = KEY_CAMERA,          // Snapshot
+
+	[ 0x88 ] = KEY_BACK,            // Backward <<
+	[ 0x8a ] = KEY_FORWARD,         // Forward >>
+	[ 0x89 ] = KEY_PREVIOUS,        // Back |<<
+	[ 0x8b ] = KEY_NEXT,            // End >>|
+
+	[ 0x8c ] = KEY_PROGRAM,         // Multi-view
+	[ 0x8d ] = KEY_AUDIO,           // Audio Tracks
+	[ 0x8e ] = KEY_SOUND,           // Sound
+	[ 0x8f ] = KEY_SUBTITLE,        // Subtitles
+
+	[ 0x90 ] = KEY_TIME,            // Set timer
+	[ 0x91 ] = KEY_CHANNEL,         // Stereo
+	[ 0x92 ] = KEY_LANGUAGE,        // Language
+	[ 0x93 ] = KEY_TEXT,            // Text
+
+	[ 0x99 ] = KEY_RED,             // RED
+	[ 0x81 ] = KEY_GREEN,           // GREEN
+	[ 0x87 ] = KEY_YELLOW,          // YELLOW
+	[ 0x97 ] = KEY_BLUE,            // BLUE
+#endif /* IR_KEYTAB_SIZE>=256 */
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
index c0de37e..5511aff 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -333,6 +333,12 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keyup   = 0x040000;
 		polling      = 50; // ms
 		break;
+	case SAA7134_BOARD_10MOONSTVMASTER3:
+		ir_codes     = ir_codes_10moonstm3;
+		mask_keycode = 0x7f80000;
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
 


