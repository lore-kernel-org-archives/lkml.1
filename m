Return-Path: <linux-kernel-owner+w=401wt.eu-S933908AbYBBUVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbYBBUVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYBBUVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:21:04 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:53013 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbYBBUVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:21:04 -0500
Message-ID: <47A4D0AA.4080802@tiscali.nl>
Date: Sat, 02 Feb 2008 21:20:58 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] [rivers/media/video/tvaudio.c] add parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'!' has a higher priority than '&': bitanding has no effect.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index a755605..01ebcec 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -1571,14 +1571,14 @@ static int tvaudio_get_ctrl(struct CHIPSTATE *chip,
 		ctrl->value=chip->muted;
 		return 0;
 	case V4L2_CID_AUDIO_VOLUME:
-		if (!desc->flags & CHIP_HAS_VOLUME)
+		if (!(desc->flags & CHIP_HAS_VOLUME))
 			break;
 		ctrl->value = max(chip->left,chip->right);
 		return 0;
 	case V4L2_CID_AUDIO_BALANCE:
 	{
 		int volume;
-		if (!desc->flags & CHIP_HAS_VOLUME)
+		if (!(desc->flags & CHIP_HAS_VOLUME))
 			break;
 		volume = max(chip->left,chip->right);
 		if (volume)
@@ -1621,7 +1621,7 @@ static int tvaudio_set_ctrl(struct CHIPSTATE *chip,
 	{
 		int volume,balance;
 
-		if (!desc->flags & CHIP_HAS_VOLUME)
+		if (!(desc->flags & CHIP_HAS_VOLUME))
 			break;
 
 		volume = max(chip->left,chip->right);
@@ -1642,7 +1642,7 @@ static int tvaudio_set_ctrl(struct CHIPSTATE *chip,
 	case V4L2_CID_AUDIO_BALANCE:
 	{
 		int volume, balance;
-		if (!desc->flags & CHIP_HAS_VOLUME)
+		if (!(desc->flags & CHIP_HAS_VOLUME))
 			break;
 
 		volume = max(chip->left,chip->right);
@@ -1702,7 +1702,7 @@ static int chip_command(struct i2c_client *client,
 				break;
 			case V4L2_CID_AUDIO_VOLUME:
 			case V4L2_CID_AUDIO_BALANCE:
-				if (!desc->flags & CHIP_HAS_VOLUME)
+				if (!(desc->flags & CHIP_HAS_VOLUME))
 					return -EINVAL;
 				break;
 			case V4L2_CID_AUDIO_BASS:

