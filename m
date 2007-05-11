Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXEKNHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXEKNHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 09:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756428AbXEKNHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 09:07:39 -0400
Received: from mail.sjtu.org ([202.120.5.34]:52029 "ehlo appsrv1.sjtu.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755384AbXEKNHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 09:07:39 -0400
Subject: [PATCH 5/5] v4l: saa7134: enable ir-remote for 10moons TM300
From: Tony Wan <wankai@sjtu.org>
To: mchehab@infradead.org, michael@mihu.de
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 12 May 2007 05:07:17 +0800
Message-Id: <1178917637.3256.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Using Encore's key codes, we needn't add any additional key table.

Signed-off-by: Tony Wan <wankai@sjtu.org>
---
 drivers/media/video/saa7134/saa7134-cards.c |    1 +
 drivers/media/video/saa7134/saa7134-input.c |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

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
index c0de37e..817d4b6 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -333,6 +333,12 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keyup   = 0x040000;
 		polling      = 50; // ms
 		break;
+	case SAA7134_BOARD_10MOONSTVMASTER3:
+		ir_codes     = ir_codes_encore_enltv;
+		mask_keycode = 0x5f80000;
+		mask_keyup   = 0x8000000;
+		polling      = 50; //ms
+		break;
 	}
 	if (NULL == ir_codes) {
 		printk("%s: Oops: IR config error [card=%d]\n",


